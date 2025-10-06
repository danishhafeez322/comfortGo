import 'package:comfort_go/constants/app_colors.dart';
import 'package:comfort_go/controllers/home_controller.dart';
import 'package:comfort_go/models/ride_model.dart';
import 'package:comfort_go/utils/spacer.dart';
import 'package:comfort_go/views/widgets/buttons/custom_button.dart';
import 'package:comfort_go/views/widgets/common_widgets/custom_bg_paint.dart';
import 'package:comfort_go/views/widgets/text_widgets/common_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../utils/app_sizes.dart';

class TripDetailScreen extends StatelessWidget {
  const TripDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ride = Get.arguments as Ride; // ✅ get passed trip
    final controller = Get.find<HomeController>();

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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                vSpace(0.05.sh),
                Text(
                  "Trip Details",
                  style: TextStyle(
                    fontSize: FontSizes.largeFontSize(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "${ride.pickupLocation} → ${ride.dropLocation}",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Vehicle: ${ride.vehicleModel} (${ride.vehicleColor}, ${ride.vehicleYear})",
                ),
                Text(
                  "Departure: ${DateFormat('dd MMM, hh:mm a').format(ride.departureTime)}",
                ),
                Text("Seats Available: ${ride.seatsAvailable}"),
                const SizedBox(height: 20),

                // User Info Form
                CommonTextFieldWidget(
                  controller: controller.nameCtrl,
                  hintText: "Your Name",
                ),
                vSpace(6),
                CommonTextFieldWidget(
                  controller: controller.contactCtrl,
                  hintText: "Your Contact Number",
                  inputType: TextInputType.phone,
                ),
                vSpace(6),
                CommonTextFieldWidget(
                  controller: controller.numberOfSeatsCtrl,
                  hintText: "Number of seats",
                  inputType: TextInputType.number,
                ),
                const SizedBox(height: 20),

                SizedBox(
                  width: 0.55.sw,
                  child: ExpandedButton(
                    btnColor: AppColors.backButtonColors,
                    showBorder: true,
                    borderColor: AppColors.lightGrey,
                    btnTxtColor: AppColors.whiteColor,
                    txtSize: FontSizes.mediumFontSize(),
                    roundCorner: 10,
                    onTap: () => controller.reserveYourSeat(ride),
                    title: "Request to reserve Seat",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
