import 'package:comfort_go/models/ride_model.dart';
import 'package:comfort_go/repositories/ride_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  final RideRepository rideRepository = RideRepository();

  // search fields
  final pickupController = TextEditingController();
  final dropController = TextEditingController();
  final dateController = TextEditingController();

  ///trip details
  final nameCtrl = TextEditingController();
  final contactCtrl = TextEditingController();
  final numberOfSeatsCtrl = TextEditingController();

  RxList<Ride> rides = <Ride>[].obs;
  RxList<Ride> filteredRides = <Ride>[].obs;

  Future<void> pickDepartureDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      dateController.text = DateFormat('MM-dd-yyyy').format(picked);
      filterTrips(rides);
    }
  }

  RxList<Ride> filterTrips(List<Ride> trips) {
    String pickup = pickupController.text.trim().toLowerCase();
    String drop = dropController.text.trim().toLowerCase();
    String date = dateController.text.trim();

    filteredRides.value = trips.where((ride) {
      bool matchesPickup =
          pickup.isEmpty || ride.pickupLocation.toLowerCase().contains(pickup);
      bool matchesDrop =
          drop.isEmpty || ride.dropLocation.toLowerCase().contains(drop);
      bool matchesDate =
          date.isEmpty ||
          ride.departureTime.toIso8601String().split("T")[0] == date;

      return matchesPickup && matchesDrop && matchesDate;
    }).toList();
    return filteredRides;
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

  void clearTextFields() {
    pickupController.clear();
    dropController.clear();
    dateController.clear();
    filterTrips(rides);
  }
}
