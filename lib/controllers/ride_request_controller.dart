import 'package:comfort_go/controllers/request_list_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/ride_request_model.dart';
import '../repositories/firebase_repository.dart';

class RideRequestController extends GetxController {
  final FirebaseRepository _repository = FirebaseRepository();
  late RideRequestListController _rideRequestListController;

  final passengerNameController = TextEditingController();
  final contactController = TextEditingController();
  final pickupController = TextEditingController();
  final destinationController = TextEditingController();
  final dateController = TextEditingController();
  final seatsController = TextEditingController();

  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    _rideRequestListController = Get.find<RideRequestListController>();
  }

  Future<void> submitRideRequest() async {
    if (passengerNameController.text.isEmpty ||
        contactController.text.isEmpty ||
        pickupController.text.isEmpty ||
        destinationController.text.isEmpty ||
        dateController.text.isEmpty ||
        seatsController.text.isEmpty) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    isLoading.value = true;

    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      final request = RideRequestModel(
        id: "",
        passengerName: passengerNameController.text,
        contactNumber: contactController.text,
        pickupLocation: pickupController.text,
        isCompleted: false,
        destination: destinationController.text,
        time: DateTime.parse(dateController.text),
        seatsNeeded: int.tryParse(seatsController.text) ?? 1,
        createdAt: DateTime.now(),
        ownerId: uid,
      );

      await _repository.addRideRequest(request);
      _rideRequestListController.fetchRideRequests(); // refresh list
      Get.back(); // close screen
      Get.snackbar("Success", "Ride request added successfully");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
