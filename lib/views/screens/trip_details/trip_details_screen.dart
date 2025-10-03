import 'package:comfort_go/constants/app_colors.dart';
import 'package:comfort_go/controllers/home_controller.dart';
import 'package:comfort_go/models/ride_model.dart';
import 'package:comfort_go/utils/spacer.dart';
import 'package:comfort_go/views/widgets/text_widgets/common_text_field_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class TripDetailScreen extends StatelessWidget {
  const TripDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final trip = Get.arguments as Ride; // ✅ get passed trip
    final controller = Get.find<HomeController>();

    final nameCtrl = TextEditingController();
    final contactCtrl = TextEditingController();
    final numberOfSeatsCtrl = TextEditingController();

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(title: const Text("Trip Details")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${trip.pickupLocation} → ${trip.dropLocation}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              "Vehicle: ${trip.vehicleModel} (${trip.vehicleColor}, ${trip.vehicleYear})",
            ),
            Text(
              "Departure: ${DateFormat('dd MMM, hh:mm a').format(trip.departureTime)}",
            ),
            Text("Seats Available: ${trip.seatsAvailable}"),
            const SizedBox(height: 20),

            // User Info Form
            CommonTextFieldWidget(controller: nameCtrl, hintText: "Your Name"),
            vSpace(6),
            CommonTextFieldWidget(
              controller: contactCtrl,
              hintText: "Your Contact Number",
              inputType: TextInputType.phone,
            ),
            vSpace(6),
            CommonTextFieldWidget(
              controller: numberOfSeatsCtrl,
              hintText: "Number of seats",
              inputType: TextInputType.number,
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () async {
                if (nameCtrl.text.isEmpty ||
                    contactCtrl.text.isEmpty ||
                    numberOfSeatsCtrl.text.isEmpty) {
                  Get.snackbar("Error", "Please enter all details");
                  return;
                }

                final seats = int.tryParse(numberOfSeatsCtrl.text.trim()) ?? 1;

                if (seats <= 0) {
                  Get.snackbar("Error", "Seats must be at least 1");
                  return;
                }

                await controller.reserveSeat(
                  rideId: trip.id,
                  userId: FirebaseAuth
                      .instance
                      .currentUser!
                      .uid, // 👈 from Firebase
                  userName: nameCtrl.text.trim(),
                  userContact: contactCtrl.text.trim(),
                  seatsReserved: seats,
                );

                Get.back(); // go back to Home
                Get.snackbar("Success", "Seat reserved successfully");
              },
              child: const Text("Reserve Seat"),
            ),
          ],
        ),
      ),
    );
  }
}
