import 'package:comfort_go/constants/app_colors.dart';
import 'package:comfort_go/controllers/ride_request_controller.dart';
import 'package:comfort_go/views/widgets/buttons/custom_button.dart';
import 'package:comfort_go/views/widgets/text_widgets/common_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/app_sizes.dart';

class AddRideRequestScreen extends GetView<RideRequestController> {
  const AddRideRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text("Request a Ride")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CommonTextFieldWidget(
                controller: controller.passengerNameController,
                hintText: "Your Name",
              ),
              const SizedBox(height: 8),
              CommonTextFieldWidget(
                controller: controller.contactController,
                inputType: TextInputType.phone,
                hintText: "Contact Number",
              ),
              const SizedBox(height: 8),
              CommonTextFieldWidget(
                controller: controller.pickupController,
                hintText: "Pickup Location",
              ),
              const SizedBox(height: 8),
              CommonTextFieldWidget(
                controller: controller.destinationController,
                hintText: "Destination",
              ),

              const SizedBox(height: 8),
              CommonTextFieldWidget(
                controller: controller.dateController,
                readOnly: true,
                hintText: "Date & Time",
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
                        "dd/MM/yyyy HH:mm:ss",
                      ).format(fullDateTime);
                    }
                  }
                },
              ),
              const SizedBox(height: 8),
              CommonTextFieldWidget(
                controller: controller.seatsController,
                inputType: TextInputType.number,
                hintText: "Seats Needed",
              ),
              const SizedBox(height: 20),

              Obx(
                () => controller.isLoading.value
                    ? const CircularProgressIndicator()
                    : ExpandedButton(
                        btnColor: AppColors.backButtonColors,
                        showBorder: true,
                        borderColor: AppColors.lightGrey,
                        btnTxtColor: AppColors.whiteColor,
                        txtSize: FontSizes.mediumFontSize(),
                        roundCorner: 10,
                        onTap: controller.submitRideRequest,
                        title: "Submit Request",
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
