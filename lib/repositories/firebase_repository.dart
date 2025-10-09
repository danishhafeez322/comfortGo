import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/ride_request_model.dart';

class FirebaseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addRideRequest(RideRequestModel request) async {
    await _firestore.collection("rideRequests").add(request.toJson());
  }

  Future<List<RideRequestModel>> getRideRequests() async {
    final snapshot = await _firestore.collection("rideRequests").get();
    return snapshot.docs
        .map((doc) => RideRequestModel.fromJson(doc.data(), doc.id))
        .toList();
  }

  Future<void> markRequestCompleted(String requestId) async {
    await _firestore.collection("rideRequests").doc(requestId).update({
      "isCompleted": true,
    });
  }
}
