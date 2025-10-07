import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/ride_model.dart';
import '../repositories/ride_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyRideController extends GetxController {
  final RideRepository _repo = RideRepository();

  // text controllers
  final nameCtrl = TextEditingController();
  final contactCtrl = TextEditingController();
  final modelCtrl = TextEditingController();
  final colorCtrl = TextEditingController();
  final yearCtrl = TextEditingController();
  final pickupCtrl = TextEditingController();
  final dropCtrl = TextEditingController();
  final seatsCtrl = TextEditingController();
  final fareCtrl = TextEditingController();

  DateTime? departureTime;

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

  // Future<void> fetchMyRides() async {
  //   myRides.value = await ridesRepo.getMyRides();
  // }

  Future<void> refreshMyRides() async {
    fetchMyRides();
    await Future.delayed(const Duration(milliseconds: 500)); // for indicator
  }

  Future<bool> addRide() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final ride = Ride(
        id: '', // Firestore will assign one; you can overwrite after add
        userId: uid,
        name: nameCtrl.text.trim(),
        contactNumber: contactCtrl.text.trim(),
        vehicleModel: modelCtrl.text.trim(),
        vehicleColor: colorCtrl.text.trim(),
        vehicleYear: yearCtrl.text.trim(),
        pickupLocation: pickupCtrl.text.trim(),
        dropLocation: dropCtrl.text.trim(),
        departureTime: departureTime ?? DateTime.now(),
        seatsAvailable: int.tryParse(seatsCtrl.text.trim()) ?? 1,
        fare: fareCtrl.text.trim(),
      );

      await _repo.addRide(ride);
      clearForm();
      return true;
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
      );
      return false;
    }
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

  void clearForm() {
    nameCtrl.clear();
    contactCtrl.clear();
    modelCtrl.clear();
    colorCtrl.clear();
    yearCtrl.clear();
    pickupCtrl.clear();
    dropCtrl.clear();
    seatsCtrl.clear();
    departureTime = null;
    fareCtrl.clear();
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    contactCtrl.dispose();
    modelCtrl.dispose();
    colorCtrl.dispose();
    yearCtrl.dispose();
    pickupCtrl.dispose();
    dropCtrl.dispose();
    seatsCtrl.dispose();
    fareCtrl.dispose();
    super.onClose();
  }
}
