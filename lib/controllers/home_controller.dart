import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:comfort_go/models/ride_model.dart';
import 'package:comfort_go/repositories/ride_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final RideRepository rideRepository = RideRepository();

  // search fields
  final pickupController = TextEditingController();
  final dropController = TextEditingController();
  final dateController = TextEditingController();

  RxList<Ride> rides = <Ride>[].obs;
  RxList<Ride> filteredRides = <Ride>[].obs;

  /// loading states
  RxBool isLoading = false.obs;
  RxBool isLoadingMore = false.obs;

  @override
  void onInit() {
    super.onInit();
    _deleteExpiredRides();
    listenToRides();
  }

  void listenToRides() {
    _firestore
        .collection('rides')
        .orderBy('departureTime', descending: false)
        .snapshots()
        .listen((snapshot) {
          final rideList = snapshot.docs
              .map((doc) => Ride.fromMap(doc.data(), doc.id))
              .toList();
          rides.assignAll(rideList);
          filterRides(rides);
        });
  }

  Future<void> _deleteExpiredRides() async {
    try {
      await rideRepository.deleteExpiredRides();
    } catch (e) {
      debugPrint('Error deleting expired rides: $e');
    }
  }

  Future<void> pickDepartureDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      // Use consistent ISO format (yyyy-MM-dd)
      dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      filterRides(rides);
    }
  }

  RxList<Ride> filterRides(List<Ride> rides) {
    String pickup = pickupController.text.trim().toLowerCase();
    String drop = dropController.text.trim().toLowerCase();
    String date = dateController.text.trim();

    filteredRides.value = rides.where((ride) {
      bool matchesPickup =
          pickup.isEmpty || ride.pickupLocation.toLowerCase().contains(pickup);
      bool matchesDrop =
          drop.isEmpty || ride.dropLocation.toLowerCase().contains(drop);
      bool matchesDate =
          date.isEmpty ||
          DateFormat('yyyy-MM-dd').format(ride.departureTime) == date;

      return matchesPickup && matchesDrop && matchesDate;
    }).toList();

    return filteredRides;
  }

  Future<void> fetchInitialRides() async {
    isLoading.value = true;
    try {
      final result = await rideRepository.fetchInitialRides();
      rides.assignAll(result);
      filterRides(rides);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to fetch rides: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMoreRides() async {
    if (isLoadingMore.value) return;

    isLoadingMore.value = true;
    try {
      final result = await rideRepository.fetchNextRides();
      rides.addAll(result);
      filterRides(rides);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load more rides: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isLoadingMore.value = false;
    }
  }

  void clearTextFields() {
    pickupController.clear();
    dropController.clear();
    dateController.clear();
    filterRides(rides);
  }

  @override
  void onClose() {
    pickupController.dispose();
    dropController.dispose();
    dateController.dispose();
    super.onClose();
  }
}
