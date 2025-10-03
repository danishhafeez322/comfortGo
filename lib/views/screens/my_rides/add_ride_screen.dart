import 'package:comfort_go/controllers/my_ride_controller.dart';
import 'package:comfort_go/utils/app_sizes.dart';
import 'package:comfort_go/utils/spacer.dart';
import 'package:comfort_go/views/widgets/buttons/custom_button.dart';
import 'package:comfort_go/views/widgets/text_widgets/common_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/app_colors.dart';

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
              CommonTextFieldWidget(
                controller: controller.nameCtrl,
                hintText: "Name",
                borderColor: AppColors.textFieldBorderColor,
              ),
              vSpace(6),
              CommonTextFieldWidget(
                controller: controller.contactCtrl,
                hintText: "Contact Number",
              ),
              vSpace(6),
              CommonTextFieldWidget(
                controller: controller.modelCtrl,
                hintText: "Vehicle Model",
              ),
              vSpace(6),
              CommonTextFieldWidget(
                controller: controller.colorCtrl,
                hintText: "Vehicle Color",
              ),
              vSpace(6),
              CommonTextFieldWidget(
                controller: controller.yearCtrl,
                hintText: "Vehicle Year",
              ),
              vSpace(6),
              CommonTextFieldWidget(
                controller: controller.pickupCtrl,
                hintText: "Pickup Location",
              ),
              vSpace(6),
              CommonTextFieldWidget(
                controller: controller.dropCtrl,
                hintText: "Drop Location",
              ),
              vSpace(6),
              CommonTextFieldWidget(
                controller: controller.seatsCtrl,
                inputType: TextInputType.number,
                hintText: "Seats Available",
              ),
              const SizedBox(height: 12),
              ExpandedButton(
                onTap: () async {
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
                title: "Add Ride",
                btnColor: AppColors.backButtonColors,
                showBorder: true,
                borderColor: AppColors.lightGrey,
                btnTxtColor: AppColors.whiteColor,
                txtSize: FontSizes.mediumFontSize(),
                roundCorner: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
