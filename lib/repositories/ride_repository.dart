import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/ride_model.dart';

class RideRepository {
  final _db = FirebaseFirestore.instance;

  Future<void> addRide(Ride ride) async {
    await _db.collection("rides").add(ride.toMap());
  }

  Stream<List<Ride>> getAllRides() {
    return _db
        .collection("rides")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map(
          (snap) => snap.docs.map((d) => Ride.fromMap(d.data(), d.id)).toList(),
        );
  }

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

            // ✅ reservations are inline inside rideData
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

        if (!snapshot.exists) {
          throw Exception("Ride not found");
        }

        final rideData = snapshot.data()!;
        final reservations = List<Map<String, dynamic>>.from(
          rideData['reservations'] ?? [],
        );

        // 🔍 Find the reservation
        var index = reservations.indexWhere((r) => r['userId'] == userId);
        if (index == -1) {
          throw Exception("Reservation not found for this user");
        }
        index = listindex;

        // final currentStatus = (reservations[index]['status'] ?? '').toString();

        // ✏️ Update reservation status
        reservations[index]['status'] = status;

        int seatsAvailable = (rideData['seatsAvailable'] ?? 0) as int;

        // 🎯 If reservation was previously pending/accepted and now rejected → restore seats
        if (status == 'rejected') {
          final reservedSeats =
              (reservations[index]['seatsReserved'] ?? 1) as int;
          seatsAvailable += reservedSeats;
        }

        // ✅ Save updated array and seat count
        txn.update(rideRef, {
          "reservations": reservations,
          "seatsAvailable": seatsAvailable,
          "status": status,
        });
      });

      print("✅ Reservation status updated successfully for user $userId");
    } on FirebaseException catch (e) {
      print("❌ Firebase error while updating reservation: ${e.message}");
      rethrow;
    } catch (e) {
      print("❌ Unexpected error while updating reservation: $e");
      rethrow;
    }
  }

  /// Reserve seat for a ride
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

      // reduce seat count
      txn.update(rideRef, {'seatsAvailable': seatsAvailable - seatsReserved});

      // add reservation inline inside the ride doc
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

  // ✅ Delete a ride
  Future<void> deleteRide(String rideId) async {
    try {
      await _db.collection("rides").doc(rideId).delete();
    } catch (e) {
      rethrow;
    }
  }

  // ✅ Update ride details
  Future<void> updateRide(String rideId, Map<String, dynamic> updates) async {
    try {
      await _db.collection("rides").doc(rideId).update(updates);
    } catch (e) {
      rethrow;
    }
  }
}
