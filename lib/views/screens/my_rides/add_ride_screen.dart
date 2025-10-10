import 'package:comfort_go/controllers/add_my_ride_controller.dart';
import 'package:comfort_go/extentions/on_tap_extension.dart';
import 'package:comfort_go/utils/app_sizes.dart';
import 'package:comfort_go/utils/spacer.dart';
import 'package:comfort_go/views/widgets/buttons/custom_button.dart';
import 'package:comfort_go/views/widgets/common_widgets/custom_bg_paint.dart';
import 'package:comfort_go/views/widgets/text_widgets/common_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constants/app_colors.dart';

class AddRideScreen extends GetView<AddMyRideController> {
  const AddRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      resizeToAvoidBottomInset: true, // allows scroll when keyboard appears
      body: Stack(
        children: [
          // fixed background at bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationX(3.14159),
              child: CustomPaint(
                size: const Size(double.infinity, 200),
                painter: BackgroundPainter(),
              ),
            ),
          ),

          // scrollable content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Obx(
                  () => ListView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.arrow_back_ios,
                            size: AppWidgetSizes.mediumIconSize(),
                          ).onTapWidget(onTap: Get.back),
                          hSpace(5),
                          Text(
                            "Add ride details",
                            style: TextStyle(
                              fontSize: FontSizes.largeFontSize(),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      vSpace(0.012.sh),

                      // Basic Info
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

                      // Stops (Dynamic)
                      vSpace(6),
                      Text(
                        "Add Stops (Optional)",
                        style: TextStyle(
                          fontSize: FontSizes.mediumFontSize(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      vSpace(4),
                      ...controller.stopControllers.map((stopCtrl) {
                        final index = controller.stopControllers.indexOf(
                          stopCtrl,
                        );
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Row(
                            children: [
                              Expanded(
                                child: CommonTextFieldWidget(
                                  controller: stopCtrl,
                                  hintText: "Stop ${index + 1}",
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: AppColors.redColor,
                                ),
                                onPressed: () =>
                                    controller.removeStopField(index),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                      TextButton.icon(
                        onPressed: controller.addStopField,
                        icon: const Icon(Icons.add_circle_outline),
                        label: const Text("Add Stop"),
                      ),

                      // Departure Time
                      vSpace(6),
                      Text(
                        "Departure Time",
                        style: TextStyle(
                          fontSize: FontSizes.mediumFontSize(),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      vSpace(4),
                      GestureDetector(
                        onTap: () => controller.pickDepartureTime(context),
                        child: AbsorbPointer(
                          child: CommonTextFieldWidget(
                            controller: controller.departureTimeCtrl,
                            hintText: "Select time",
                            suffix: const Icon(Icons.access_time),
                          ),
                        ),
                      ),

                      // Fare and Seats
                      vSpace(6),
                      CommonTextFieldWidget(
                        controller: controller.seatsCtrl,
                        inputType: TextInputType.number,
                        hintText: "Seats Available",
                      ),
                      vSpace(6),
                      CommonTextFieldWidget(
                        controller: controller.fareCtrl,
                        inputType: TextInputType.number,
                        hintText: "Fare per person",
                      ),

                      const SizedBox(height: 16),
                      ExpandedButton(
                        onTap: () async {
                          if (formKey.currentState!.validate()) {
                            final success = await controller.addRide();
                            if (success) {
                              await controller.myRideController.fetchMyRides();
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
            ),
          ),
        ],
      ),
    );
  }
}
