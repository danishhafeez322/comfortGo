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

            // get reservations subcollection
            final reservationsSnap = await d.reference
                .collection("reservations")
                .get();

            final reservations = reservationsSnap.docs
                .map((r) => Reservation.fromJson(r.data()..['userId'] = r.id))
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
  ) async {
    await _db
        .collection("rides")
        .doc(rideId)
        .collection("reservations")
        .doc(userId)
        .update({"status": status});
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
}
