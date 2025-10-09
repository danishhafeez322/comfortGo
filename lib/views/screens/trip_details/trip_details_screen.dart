import 'package:comfort_go/constants/app_colors.dart';
import 'package:comfort_go/controllers/home_controller.dart';
import 'package:comfort_go/extentions/on_tap_extension.dart';
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
    final ride = Get.arguments as Ride;
    final controller = Get.find<HomeController>();

    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Background Painter
          Align(
            alignment: Alignment.bottomCenter,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationX(3.14159),
              child: CustomPaint(
                size: const Size(double.infinity, 220),
                painter: BackgroundPainter(),
              ),
            ),
          ),

          // Foreground content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  vSpace(0.01.sh),
                  Row(
                    children: [
                      Icon(
                        Icons.arrow_back_ios,
                        size: AppWidgetSizes.mediumIconSize(),
                      ).onTapWidget(onTap: Get.back),
                      hSpace(5),
                      Text(
                        "Trip Details",
                        style: TextStyle(
                          fontSize: FontSizes.largeFontSize(),
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Route visualization
                  Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: AppColors.cardBackground,
                    shadowColor: AppColors.secondaryColor.withOpacity(0.2),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Route line
                          Column(
                            children: [
                              const Icon(
                                Icons.radio_button_checked,
                                color: Colors.green,
                                size: 18,
                              ),

                              ...List.generate(
                                ride.stops.length,
                                (index) => Container(
                                  width: 2,
                                  height: 15,
                                  color: Colors.grey.withOpacity(0.5),
                                ),
                              ),
                              const Icon(
                                Icons.location_on,
                                color: Colors.redAccent,
                                size: 18,
                              ),
                            ],
                          ),
                          const SizedBox(width: 12),

                          // Locations text
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  ride.pickupLocation,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppColors.textColor,
                                  ),
                                ),
                                const SizedBox(height: 4),

                                // Drop location
                                Text(
                                  ride.dropLocation,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: AppColors.textColor,
                                  ),
                                ),
                                // Stops
                                if (ride.stops.isNotEmpty)
                                  ...ride.stops.map(
                                    (stop) => Padding(
                                      padding: const EdgeInsets.only(bottom: 4),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.circle,
                                            size: 6,
                                            color: Colors.grey,
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            stop,
                                            style: TextStyle(
                                              color: AppColors.textColor
                                                  .withOpacity(0.8),
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Vehicle and ride details
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _infoRow(
                            Icons.directions_car,
                            "Vehicle",
                            "${ride.vehicleModel} (${ride.vehicleColor}, ${ride.vehicleYear})",
                          ),
                          _infoRow(Icons.person, "Driver", ride.name),
                          _infoRow(Icons.phone, "Contact", ride.contactNumber),
                          _infoRow(
                            Icons.access_time,
                            "Departure",
                            DateFormat(
                              'dd MMM yyyy, hh:mm a',
                            ).format(ride.departureTime),
                          ),
                          _infoRow(
                            Icons.event_seat,
                            "Seats Available",
                            "${ride.seatsAvailable}",
                          ),
                          _infoRow(
                            Icons.attach_money,
                            "Fare per Person",
                            ride.fare,
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Passenger info form
                  Text(
                    "Reserve Your Seat",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: FontSizes.mediumFontSize(),
                      color: AppColors.textColor,
                    ),
                  ),
                  const SizedBox(height: 12),

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
                    hintText: "Number of Seats",
                    inputType: TextInputType.number,
                  ),
                  const SizedBox(height: 20),

                  Center(
                    child: SizedBox(
                      width: 0.7.sw,
                      child: ExpandedButton(
                        btnColor: AppColors.backButtonColors,
                        showBorder: true,
                        borderColor: AppColors.lightGrey,
                        btnTxtColor: AppColors.whiteColor,
                        txtSize: FontSizes.mediumFontSize(),
                        roundCorner: 10,
                        onTap: () => controller.reserveYourSeat(ride),
                        title: "Request to Reserve Seat",
                      ),
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

  Widget _infoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: AppColors.secondaryColor, size: 20),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textColor,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(color: AppColors.textColor.withOpacity(0.8)),
            ),
          ),
        ],
      ),
    );
  }
}
