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

  DateTime? departureTime;

  var rides = <Ride>[].obs;
  var myRides = <Ride>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllRides();
    fetchMyRides();
  }

  void fetchAllRides() {
    _repo.getAllRides().listen((data) {
      rides.value = data;
    });
  }

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

  // Future<void> addRide({
  //   required String name,
  //   required String contactNumber,
  //   required String vehicleModel,
  //   required String vehicleColor,
  //   required String vehicleYear,
  //   required String pickupLocation,
  //   required String dropLocation,
  //   required DateTime departureTime,
  //   required int seatsAvailable,
  // }) async {
  //   final uid = FirebaseAuth.instance.currentUser!.uid;
  //   final ride = Ride(
  //     id: '',
  //     userId: uid,
  //     name: name,
  //     contactNumber: contactNumber,
  //     vehicleModel: vehicleModel,
  //     vehicleColor: vehicleColor,
  //     vehicleYear: vehicleYear,
  //     pickupLocation: pickupLocation,
  //     dropLocation: dropLocation,
  //     departureTime: departureTime,
  //     seatsAvailable: seatsAvailable,
  //   );
  //   await _repo.addRide(ride);
  // }
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
    super.onClose();
  }
}
