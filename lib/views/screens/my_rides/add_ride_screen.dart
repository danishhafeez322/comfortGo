import 'package:comfort_go/controllers/my_ride_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddRideScreen extends GetView<MyRideController> {
  const AddRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(title: const Text("Offer a Ride")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: controller.nameCtrl,
                decoration: const InputDecoration(labelText: "Name"),
              ),
              TextFormField(
                controller: controller.contactCtrl,
                decoration: const InputDecoration(labelText: "Contact Number"),
              ),
              TextFormField(
                controller: controller.modelCtrl,
                decoration: const InputDecoration(labelText: "Vehicle Model"),
              ),
              TextFormField(
                controller: controller.colorCtrl,
                decoration: const InputDecoration(labelText: "Vehicle Color"),
              ),
              TextFormField(
                controller: controller.yearCtrl,
                decoration: const InputDecoration(labelText: "Vehicle Year"),
              ),
              TextFormField(
                controller: controller.pickupCtrl,
                decoration: const InputDecoration(labelText: "Pickup Location"),
              ),
              TextFormField(
                controller: controller.dropCtrl,
                decoration: const InputDecoration(labelText: "Drop Location"),
              ),
              TextFormField(
                controller: controller.seatsCtrl,
                decoration: const InputDecoration(labelText: "Seats Available"),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  if (formKey.currentState!.validate()) {
                    final success = await controller.addRide();
                    if (success) {
                      // refresh the list after adding
                      await controller.fetchMyRides();
                      Get.back();
                      Get.snackbar(
                        "Success",
                        "Ride added successfully",
                        snackPosition: SnackPosition.BOTTOM,
                      );
                    }
                  }
                },
                child: const Text("Add Ride"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
