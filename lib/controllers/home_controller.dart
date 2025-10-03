import 'package:comfort_go/models/ride_model.dart';
import 'package:comfort_go/repositories/ride_repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  final RideRepository rideRepository = RideRepository();

  // search fields
  final pickupController = TextEditingController();
  final dropController = TextEditingController();
  final dateController = TextEditingController();

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

  void clearTextFields() {
    pickupController.clear();
    dropController.clear();
    dateController.clear();
    filterTrips(rides);
  }
}
