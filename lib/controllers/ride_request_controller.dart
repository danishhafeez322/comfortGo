import 'package:comfort_go/controllers/request_list_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
        time: selectedDateTime ?? DateTime.now(),
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

  DateTime? selectedDateTime;

  Future<void> pickDepartureDate(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (time != null) {
        selectedDateTime = DateTime(
          date.year,
          date.month,
          date.day,
          time.hour,
          time.minute,
        );

        // show nicely formatted string in the text field
        dateController.text = DateFormat(
          'dd/MM/yyyy hh:mm a',
        ).format(selectedDateTime!);
      }
    }
  }
}
