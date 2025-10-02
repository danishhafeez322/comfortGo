import 'package:comfort_go/constants/app_colors.dart';
import 'package:comfort_go/controllers/ride_request_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddRideRequestScreen extends GetView<RideRequestController> {
  const AddRideRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      appBar: AppBar(title: const Text("Request a Ride")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: controller.passengerNameController,
                decoration: const InputDecoration(labelText: "Your Name"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.contactController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "Contact Number"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.pickupController,
                decoration: const InputDecoration(labelText: "Pickup Location"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.destinationController,
                decoration: const InputDecoration(labelText: "Destination"),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.dateController,
                readOnly: true,
                decoration: const InputDecoration(labelText: "Date & Time"),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    TimeOfDay? time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    );
                    if (time != null) {
                      final fullDateTime = DateTime(
                        picked.year,
                        picked.month,
                        picked.day,
                        time.hour,
                        time.minute,
                      );
                      controller.dateController.text = DateFormat(
                        "yyyy-MM-ddTHH:mm:ss",
                      ).format(fullDateTime);
                    }
                  }
                },
              ),
              const SizedBox(height: 8),
              TextField(
                controller: controller.seatsController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Seats Needed"),
              ),
              const SizedBox(height: 20),

              Obx(
                () => controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: controller.submitRideRequest,
                        child: const Text("Submit Request"),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
