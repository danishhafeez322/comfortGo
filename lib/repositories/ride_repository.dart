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
        .map(
          (snap) => snap.docs.map((d) => Ride.fromMap(d.data(), d.id)).toList(),
        );
  }
}
