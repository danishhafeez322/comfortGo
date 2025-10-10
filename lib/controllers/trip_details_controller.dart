import 'package:comfort_go/models/ride_model.dart';
import 'package:comfort_go/repositories/ride_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TripDetailsController extends GetxController {
  final RideRepository rideRepository = RideRepository();

  ///trip details
  final nameCtrl = TextEditingController();
  final contactCtrl = TextEditingController();
  final numberOfSeatsCtrl = TextEditingController();

  Future<void> reserveYourSeat(Ride ride) async {
    try {
      final name = nameCtrl.text.trim();
      final contact = contactCtrl.text.trim();
      final seatsText = numberOfSeatsCtrl.text.trim();

      if (name.isEmpty || contact.isEmpty || seatsText.isEmpty) {
        Get.snackbar("Error", "Please enter all details");
        return;
      }

      final seats = int.tryParse(seatsText) ?? 1;
      if (seats <= 0) {
        Get.snackbar("Error", "Seats must be at least 1");
        return;
      }

      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        Get.snackbar("Error", "User not logged in");
        return;
      }

      await reserveSeat(
        rideId: ride.id,
        userId: currentUser.uid,
        userName: name,
        userContact: contact,
        seatsReserved: seats,
      );
      nameCtrl.clear();
      contactCtrl.clear();
      numberOfSeatsCtrl.clear();
      Get.back();
      Get.snackbar("Success", "Seat reserved successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to reserve seat: $e");
    }
  }

  /// Reserve seat
  Future<void> reserveSeat({
    required String rideId,
    required String userId,
    required String userName,
    required String userContact,
    required int seatsReserved,
  }) async {
    await rideRepository.reserveSeat(
      rideId: rideId,
      userId: userId,
      userName: userName,
      userContact: userContact,
      seatsReserved: seatsReserved,
    );
  }
}
