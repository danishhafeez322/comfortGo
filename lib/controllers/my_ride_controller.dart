import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/ride_model.dart';
import '../repositories/ride_repository.dart';

class MyRideController extends GetxController {
  final RideRepository _repo = RideRepository();

  var rides = <Ride>[].obs;
  var myRides = <Ride>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // fetchAllRides();
    fetchMyRides();
  }

  // void fetchAllRides() {
  //   _repo.getAllRides().listen((data) {
  //     rides.value = data;
  //   });
  // }

  Future<void> fetchMyRides() async {
    _repo.getMyRides().listen((data) {
      myRides.value = data;
    });
  }

  Future<void> refreshMyRides() async {
    fetchMyRides();
    await Future.delayed(const Duration(milliseconds: 500)); // for indicator
  }

  Future<void> updateReservationStatus(
    String rideId,
    String userId,
    String status,
    int index,
  ) async {
    try {
      await _repo.updateReservationStatus(rideId, userId, status, index);

      // Update locally in myRides list
      final rideIndex = myRides.indexWhere((r) => r.id == rideId);
      if (rideIndex != -1) {
        final reservationIndex = myRides[rideIndex].reservations.indexWhere(
          (res) => res.userId == userId,
        );

        if (reservationIndex != -1) {
          myRides[rideIndex].reservations[reservationIndex].status = status;
          myRides.refresh();
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Could not update reservation: $e");
    }
  }

  // ✅ Delete ride
  Future<void> deleteRide(String rideId) async {
    try {
      await _repo.deleteRide(rideId);
      Get.snackbar(
        "Deleted",
        "Ride deleted successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // ✅ Edit ride details
  Future<void> editRide(String rideId, Map<String, dynamic> updates) async {
    try {
      await _repo.updateRide(rideId, updates);
      Get.snackbar(
        "Updated",
        "Ride updated successfully",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
