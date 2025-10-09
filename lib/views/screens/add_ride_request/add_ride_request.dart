import 'package:comfort_go/constants/app_colors.dart';
import 'package:comfort_go/controllers/ride_request_controller.dart';
import 'package:comfort_go/extentions/on_tap_extension.dart';
import 'package:comfort_go/views/widgets/buttons/custom_button.dart';
import 'package:comfort_go/views/widgets/common_widgets/custom_bg_paint.dart';
import 'package:comfort_go/views/widgets/text_widgets/common_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/app_sizes.dart';
import '../../../utils/spacer.dart';

class AddRideRequestScreen extends GetView<RideRequestController> {
  const AddRideRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationX(
                3.14159,
              ), // flip vertically (pi radians)
              child: CustomPaint(
                size: Size(double.infinity, 240), // give it height
                painter: BackgroundPainter(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  vSpace(0.044.sh),
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
        ],
      ),
    );
  }
}
