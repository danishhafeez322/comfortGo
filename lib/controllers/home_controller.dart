import 'package:comfort_go/models/trip_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // search fields
  final pickupController = TextEditingController();
  final dropController = TextEditingController();
  final dateController = TextEditingController();

  RxList<Trip> trips = <Trip>[].obs;
  RxList<Trip> filteredTrips = <Trip>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchTrips();
  }

  Future<void> pickDepartureDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      dateController.text = DateFormat('MM-dd-yyyy').format(picked);
      filterTrips();
    }
  }

  Future<void> fetchTrips() async {
    final snapshot = await _firestore.collection('trips').get();
    trips.value = snapshot.docs
        .map((doc) => Trip.fromJson(doc.data(), doc.id))
        .toList();
    filteredTrips.value = trips;
  }

  void filterTrips() {
    String pickup = pickupController.text.trim().toLowerCase();
    String drop = dropController.text.trim().toLowerCase();
    String date = dateController.text.trim();

    filteredTrips.value = trips.where((trip) {
      bool matchesPickup =
          pickup.isEmpty || trip.pickupLocation.toLowerCase().contains(pickup);
      bool matchesDrop =
          drop.isEmpty || trip.dropLocation.toLowerCase().contains(drop);
      bool matchesDate =
          date.isEmpty ||
          trip.departureTime.toIso8601String().split("T")[0] == date;

      return matchesPickup && matchesDrop && matchesDate;
    }).toList();
  }
}
