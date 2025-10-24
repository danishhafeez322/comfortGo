import 'package:comfort_go/controllers/my_ride_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/ride_model.dart';
import '../repositories/ride_repository.dart';

class AddMyRideController extends GetxController {
  final RideRepository _repo = RideRepository();
  final MyRideController myRideController = MyRideController();
  final formKey = GlobalKey<FormState>();

  final vehicleNameCtrl = TextEditingController();
  final vehicleDetailsCtrl = TextEditingController();

  // text controllers
  final nameCtrl = TextEditingController();
  final contactCtrl = TextEditingController();

  final pickupCtrl = TextEditingController();
  final dropCtrl = TextEditingController();
  final seatsCtrl = TextEditingController();
  final fareCtrl = TextEditingController();
  final departureTimeCtrl = TextEditingController();
  final stopControllers = <TextEditingController>[].obs;

  DateTime? departureTime;

  final List<String> cities = [
    // Major Cities of Punjab
    'Lahore',
    'Islamabad',
    'Faisalabad',
    'Rawalpindi',
    'Multan',
    'Karachi',
    'Gujranwala',
    'Sialkot',
    'Sargodha',
    'Bahawalpur',
    'Sheikhupura',
    'Kasur',

    // Other big cities of Pakistan
    'Peshawar',
    'Quetta',
    'Hyderabad',
    'Sukkur',
    'Abbottabad',
    'Mardan',
    'Larkana',
    'Mirpur',
  ];
  RxString selectedPickup = ''.obs;
  RxString selectedDrop = ''.obs;

  Future<bool> addRide() async {
    try {
      final uid = FirebaseAuth.instance.currentUser!.uid;

      // ✅ Collect stops (ignore empty fields)
      final stops = stopControllers
          .map((ctrl) => ctrl.text.trim())
          .where((stop) => stop.isNotEmpty)
          .toList();

      // ✅ Use the picked date and time (from pickDepartureTime)
      DateTime? departureDateTime =
          departureTime; // <-- this now holds selected datetime

      // Fallback: if user didn’t pick manually
      if (departureDateTime == null || departureTimeCtrl.text.isEmpty) {
        departureDateTime = DateTime.now();
      }

      final ride = Ride(
        id: '', // Firestore assigns one automatically
        userId: uid,
        name: nameCtrl.text.trim(),
        contactNumber: contactCtrl.text.trim(),
        vehicleName: vehicleNameCtrl.text.trim(),
        vehicleDetails: vehicleDetailsCtrl.text.trim(),
        pickupLocation: pickupCtrl.text.trim(),
        dropLocation: dropCtrl.text.trim(),
        stops: stops,
        departureTime: departureDateTime,
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

  Future<void> pickDepartureTime(BuildContext context) async {
    // First: Select the Date
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate == null) return;

    // Then: Select the Time
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    // Combine both Date and Time into a single DateTime
    final DateTime finalDateTime = DateTime(
      pickedDate.year,
      pickedDate.month,
      pickedDate.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    departureTime = finalDateTime;

    // Update controller text (for displaying in TextField)
    departureTimeCtrl.text =
        "${pickedDate.day.toString().padLeft(2, '0')}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.year} "
        "${pickedTime.format(context)}";

    update(); // optional if you’re using GetBuilder somewhere
  }

  void clearForm() {
    nameCtrl.clear();
    contactCtrl.clear();
    pickupCtrl.clear();
    dropCtrl.clear();
    seatsCtrl.clear();
    departureTime = null;
    fareCtrl.clear();
  }

  void addStopField() {
    stopControllers.add(TextEditingController());
  }

  void removeStopField(int index) {
    stopControllers.removeAt(index);
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    contactCtrl.dispose();
    pickupCtrl.dispose();
    dropCtrl.dispose();
    seatsCtrl.dispose();
    fareCtrl.dispose();
    departureTime = null;
    stopControllers.value = [];
    super.onClose();
  }
}
