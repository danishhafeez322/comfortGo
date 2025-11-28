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
import '../../../controllers/home_controller.dart';

class AddRideScreen extends GetView<AddMyRideController> {
  const AddRideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final allCities = Get.find<HomeController>().cities;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
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
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: controller.formKey,
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

                      /// Required: Name
                      CommonTextFieldWidget(
                        controller: controller.nameCtrl,
                        hintText: "Name",
                        borderColor: AppColors.textFieldBorderColor,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter your name";
                          }
                          return null;
                        },
                      ),
                      vSpace(6),

                      /// Required: Contact Number
                      CommonTextFieldWidget(
                        controller: controller.contactCtrl,
                        hintText: "Contact Number",
                        inputType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter contact number";
                          }
                          if (value.length < 10) {
                            return "Enter valid contact number";
                          }
                          return null;
                        },
                      ),
                      vSpace(6),

                      /// Required: Vehicle Name
                      CommonTextFieldWidget(
                        controller: controller.vehicleNameCtrl,
                        hintText: "Vehicle Name",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter vehicle name";
                          }
                          return null;
                        },
                      ),
                      vSpace(6),

                      /// Optional: Vehicle Details
                      CommonTextFieldWidget(
                        controller: controller.vehicleDetailsCtrl,
                        hintText:
                            "Vehicle Details (e.g. color, year) - Optional",
                      ),
                      vSpace(6),

                      /// Required: Pickup Location
                      DropdownButtonFormField<String>(
                        value: controller.selectedPickup.value.isNotEmpty
                            ? controller.selectedPickup.value
                            : null,
                        decoration: InputDecoration(
                          labelText: "Pickup Location",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) =>
                            value == null ? "Select pickup location" : null,
                        items: allCities.map((city) {
                          return DropdownMenuItem(
                            value: city,
                            child: Text(city),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedPickup.value = value;
                            controller.pickupCtrl.text = value;
                            if (controller.selectedDrop.value == value) {
                              controller.selectedDrop.value = '';
                              controller.dropCtrl.clear();
                            }
                          }
                        },
                      ),
                      vSpace(6),

                      /// Required: Drop Location
                      DropdownButtonFormField<String>(
                        value: controller.selectedDrop.value.isNotEmpty
                            ? controller.selectedDrop.value
                            : null,
                        decoration: InputDecoration(
                          labelText: "Drop Location",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) =>
                            value == null ? "Select drop location" : null,
                        items: allCities
                            .where((c) => c != controller.selectedPickup.value)
                            .map(
                              (city) => DropdownMenuItem(
                                value: city,
                                child: Text(city),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.selectedDrop.value = value;
                            controller.dropCtrl.text = value;
                          }
                        },
                      ),

                      vSpace(6),

                      /// Optional: Stops
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
                      vSpace(6),

                      /// Optional: Departure Time
                      Text(
                        "Departure Time (Optional)",
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
                      vSpace(6),

                      /// Required: Seats Available
                      CommonTextFieldWidget(
                        controller: controller.seatsCtrl,
                        inputType: TextInputType.number,
                        hintText: "Seats Available",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter available seats";
                          }
                          final seats = int.tryParse(value);
                          if (seats == null || seats <= 0) {
                            return "Enter a valid seat count";
                          }
                          return null;
                        },
                      ),
                      vSpace(6),

                      /// Required: Fare
                      CommonTextFieldWidget(
                        controller: controller.fareCtrl,
                        inputType: TextInputType.number,
                        hintText: "Fare per person",
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter fare";
                          }
                          final fare = double.tryParse(value);
                          if (fare == null || fare <= 0) {
                            return "Enter valid fare amount";
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 16),
                      ExpandedButton(
                        onTap: () async {
                          if (controller.formKey.currentState!.validate()) {
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
