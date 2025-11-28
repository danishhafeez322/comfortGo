import 'package:comfort_go/constants/app_colors.dart';
import 'package:comfort_go/controllers/ride_request_controller.dart';
import 'package:comfort_go/extentions/on_tap_extension.dart';
import 'package:comfort_go/views/widgets/buttons/custom_button.dart';
import 'package:comfort_go/views/widgets/common_widgets/custom_bg_paint.dart';
import 'package:comfort_go/views/widgets/text_widgets/common_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../controllers/home_controller.dart';
import '../../../utils/app_sizes.dart';
import '../../../utils/spacer.dart';

class AddRideRequestScreen extends GetView<RideRequestController> {
  const AddRideRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final allCities = Get.find<HomeController>().cities;

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationX(3.14159),
              child: CustomPaint(
                size: const Size(double.infinity, 240),
                painter: BackgroundPainter(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    vSpace(0.024.sh),
                    Row(
                      children: [
                        Icon(
                          Icons.arrow_back_ios,
                          size: AppWidgetSizes.mediumIconSize(),
                        ).onTapWidget(onTap: Get.back),
                        hSpace(5),
                        Text(
                          "Request a Ride",
                          style: TextStyle(
                            fontSize: FontSizes.largeFontSize(),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    vSpace(0.012.sh),

                    /// Passenger Info
                    CommonTextFieldWidget(
                      controller: controller.passengerNameController,
                      hintText: "Your Name",
                      validator: (value) => value == null || value.isEmpty
                          ? "Enter your name"
                          : null,
                    ),
                    const SizedBox(height: 8),
                    CommonTextFieldWidget(
                      controller: controller.contactController,
                      inputType: TextInputType.phone,
                      hintText: "Contact Number",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter contact number";
                        }
                        if (!RegExp(r'^\d{10,11}$').hasMatch(value)) {
                          return "Enter a valid number";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),

                    /// Pickup Location
                    Obx(() {
                      return DropdownButtonFormField<String>(
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
                            controller.pickupController.text = value;

                            // Clear drop if pickup changed to same city
                            if (controller.selectedDrop.value == value) {
                              controller.selectedDrop.value = '';
                              controller.destinationController.clear();
                            }
                          }
                        },
                      );
                    }),
                    vSpace(6),

                    /// Drop Location
                    Obx(() {
                      final availableDropCities = allCities
                          .where(
                            (city) => city != controller.selectedPickup.value,
                          )
                          .toList();

                      return DropdownButtonFormField<String>(
                        value: controller.selectedDrop.value.isNotEmpty
                            ? controller.selectedDrop.value
                            : null,
                        decoration: InputDecoration(
                          labelText: "Drop Location",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Select drop location";
                          }
                          if (value == controller.selectedPickup.value) {
                            return "Drop location cannot be same as pickup";
                          }
                          return null;
                        },
                        items: availableDropCities
                            .map(
                              (city) => DropdownMenuItem(
                                value: city,
                                child: Text(city),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          if (value != null) {
                            // Extra safety
                            if (value == controller.selectedPickup.value) {
                              Get.snackbar(
                                "Invalid Selection",
                                "Drop location cannot be same as pickup location.",
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.redAccent.withOpacity(
                                  0.2,
                                ),
                              );
                              return;
                            }
                            controller.selectedDrop.value = value;
                            controller.destinationController.text = value;
                          }
                        },
                      );
                    }),

                    const SizedBox(height: 8),

                    /// Date & Time
                    CommonTextFieldWidget(
                      controller: controller.dateController,
                      readOnly: true,
                      hintText: "Date & Time",
                      validator: (value) => value == null || value.isEmpty
                          ? "Select date & time"
                          : null,
                      onTap: () => controller.pickDepartureDate(context),
                    ),
                    const SizedBox(height: 8),

                    /// Seats Needed
                    CommonTextFieldWidget(
                      controller: controller.seatsController,
                      inputType: TextInputType.number,
                      hintText: "Seats Needed",
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Enter number of seats";
                        }
                        final numSeats = int.tryParse(value);
                        if (numSeats == null || numSeats <= 0) {
                          return "Enter valid seat count";
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    /// Submit Button
                    Obx(() {
                      return controller.isLoading.value
                          ? const Center(child: CircularProgressIndicator())
                          : ExpandedButton(
                              btnColor: AppColors.backButtonColors,
                              showBorder: true,
                              borderColor: AppColors.lightGrey,
                              btnTxtColor: AppColors.whiteColor,
                              txtSize: FontSizes.mediumFontSize(),
                              roundCorner: 10,
                              title: "Submit Request",
                              onTap: () {
                                if (formKey.currentState!.validate()) {
                                  controller.submitRideRequest();
                                }
                              },
                            );
                    }),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
