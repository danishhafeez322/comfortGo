import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/ride_model.dart';

class RideRepository {
  final _db = FirebaseFirestore.instance;
  final int _pageSize = 10; // 🔹 Pagination size
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;

  /// ✅ Add new ride
  Future<void> addRide(Ride ride) async {
    await _db.collection("rides").add(ride.toMap());
  }

  /// ✅ Get all rides (real-time stream)
  Stream<List<Ride>> getAllRides() {
    return _db
        .collection("rides")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((d) => Ride.fromMap(d.data(), d.id)).toList(),
        );
  }

  /// ✅ Pagination: fetch first page
  Future<List<Ride>> fetchInitialRides() async {
    _lastDocument = null;
    _hasMore = true;
    return _fetchPaginatedRides();
  }

  /// ✅ Pagination: fetch next page
  Future<List<Ride>> fetchNextRides() async {
    if (!_hasMore) return [];
    return _fetchPaginatedRides();
  }

  /// 🔹 Helper for pagination
  Future<List<Ride>> _fetchPaginatedRides() async {
    Query query = _db
        .collection("rides")
        .orderBy("createdAt", descending: true)
        .limit(_pageSize);

    if (_lastDocument != null) {
      query = query.startAfterDocument(_lastDocument!);
    }

    final snapshot = await query.get();

    if (snapshot.docs.isEmpty) {
      _hasMore = false;
      return [];
    }

    _lastDocument = snapshot.docs.last;

    return snapshot.docs
        .map((doc) => Ride.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  /// ✅ Get current user's rides
  Stream<List<Ride>> getMyRides() {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    return _db
        .collection("rides")
        .where("userId", isEqualTo: userId)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .asyncMap((snap) async {
          List<Ride> rides = [];

          for (var d in snap.docs) {
            final rideData = d.data();

            final reservations =
                (rideData['reservations'] as List<dynamic>? ?? [])
                    .map(
                      (res) =>
                          Reservation.fromJson(Map<String, dynamic>.from(res)),
                    )
                    .toList();

            rides.add(
              Ride.fromMap(rideData, d.id).copyWith(reservations: reservations),
            );
          }

          return rides;
        });
  }

  /// ✅ Update reservation status
  Future<void> updateReservationStatus(
    String rideId,
    String userId,
    String status,
    int listindex,
  ) async {
    try {
      final rideRef = _db.collection("rides").doc(rideId);

      await _db.runTransaction((txn) async {
        final snapshot = await txn.get(rideRef);

        if (!snapshot.exists) throw Exception("Ride not found");

        final rideData = snapshot.data()!;
        final reservations = List<Map<String, dynamic>>.from(
          rideData['reservations'] ?? [],
        );

        var index = reservations.indexWhere((r) => r['userId'] == userId);
        if (index == -1) throw Exception("Reservation not found for this user");
        index = listindex;

        reservations[index]['status'] = status;

        int seatsAvailable = (rideData['seatsAvailable'] ?? 0) as int;

        if (status == 'rejected') {
          final reservedSeats =
              (reservations[index]['seatsReserved'] ?? 1) as int;
          seatsAvailable += reservedSeats;
        }

        txn.update(rideRef, {
          "reservations": reservations,
          "seatsAvailable": seatsAvailable,
          "status": status,
        });
      });

      print("✅ Reservation status updated successfully for user $userId");
    } on FirebaseException catch (e) {
      print("❌ Firebase error: ${e.message}");
      rethrow;
    } catch (e) {
      print("❌ Unexpected error: $e");
      rethrow;
    }
  }

  /// ✅ Reserve seat for a ride
  Future<void> reserveSeat({
    required String rideId,
    required String userId,
    required String userName,
    required String userContact,
    required int seatsReserved,
  }) async {
    final rideRef = _db.collection("rides").doc(rideId);

    await _db.runTransaction((txn) async {
      final snapshot = await txn.get(rideRef);

      if (!snapshot.exists) throw Exception("Ride not found");

      final seatsAvailable = (snapshot['seatsAvailable'] as num).toInt();
      if (seatsAvailable < seatsReserved) {
        throw Exception("Not enough seats available");
      }

      txn.update(rideRef, {'seatsAvailable': seatsAvailable - seatsReserved});

      final reservations = List<Map<String, dynamic>>.from(
        snapshot['reservations'] ?? [],
      );
      reservations.add({
        'userId': userId,
        'userName': userName,
        'userContact': userContact,
        'seatsReserved': seatsReserved,
        'status': "pending",
      });

      txn.update(rideRef, {'reservations': reservations});
    });
  }

  /// ✅ Delete ride
  Future<void> deleteRide(String rideId) async {
    await _db.collection("rides").doc(rideId).delete();
  }

  /// ✅ Update ride
  Future<void> updateRide(String rideId, Map<String, dynamic> updates) async {
    await _db.collection("rides").doc(rideId).update(updates);
  }

  /// 🧹 Delete rides older than current date
  Future<void> deleteExpiredRides() async {
    final now = DateTime.now();

    try {
      final snapshot = await _db
          .collection("rides")
          .where("departureTime", isLessThan: Timestamp.fromDate(now))
          .get();

      if (snapshot.docs.isEmpty) {
        print("ℹ️ No expired rides found");
        return;
      }

      for (final doc in snapshot.docs) {
        await doc.reference.delete();
        print("🗑️ Deleted expired ride: ${doc.id}");
      }
    } catch (e) {
      print("❌ Error deleting expired rides: $e");
    }
  }
}
