import 'package:comfort_go/constants/app_colors.dart';
import 'package:comfort_go/constants/app_routes.dart';
import 'package:comfort_go/controllers/home_controller.dart';
import 'package:comfort_go/extentions/on_tap_extension.dart';
import 'package:comfort_go/models/ride_model.dart';
import 'package:comfort_go/utils/app_sizes.dart';
import 'package:comfort_go/utils/spacer.dart';
import 'package:comfort_go/views/widgets/buttons/custom_button.dart';
import 'package:comfort_go/views/widgets/common_widgets/custom_bg_paint.dart';
import 'package:comfort_go/views/widgets/text_widgets/common_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
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
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              vSpace(0.01.sh),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Find a Trip",
                    style: TextStyle(
                      fontSize: FontSizes.largeFontSize(),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.notifications,
                    size: AppWidgetSizes.mediumIconSize(),
                    color: AppColors.backButtonColors,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 🔍 Search Filters
              Row(
                children: [
                  Expanded(
                    child: CommonTextFieldWidget(
                      controller: controller.pickupController,
                      hintText: "Pickup City",
                      onChanged: (_) =>
                          controller.filterTrips(controller.rides),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CommonTextFieldWidget(
                      controller: controller.dropController,
                      hintText: "Drop City",
                      onChanged: (_) =>
                          controller.filterTrips(controller.rides),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 0.48.sw,
                    child: CommonTextFieldWidget(
                      controller: controller.dateController,
                      readOnly: true,
                      hintText: "Departure Date",
                      onTap: () => controller.pickDepartureDate(context),
                    ),
                  ),
                  hSpace(4),
                  Icon(
                    Icons.refresh,
                  ).onTapWidget(onTap: controller.clearTextFields),
                  SizedBox(
                    width: 0.26.sw,
                    height: ProfileSizes.searchButtonHeight(),
                    child: ExpandedButton(
                      btnColor: AppColors.backButtonColors,
                      showBorder: true,
                      borderColor: AppColors.lightGrey,
                      btnTxtColor: AppColors.whiteColor,
                      txtSize: FontSizes.mediumFontSize(),
                      title: "Search",
                      roundCorner: 10,
                      onTap: () async {
                        controller.filterTrips(controller.rides);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 📋 Trips List (StreamBuilder with Firestore data)
              Expanded(
                child: StreamBuilder<List<Ride>>(
                  stream: controller.rideRepository.getAllRides(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text("No trips available"));
                    }

                    // ✅ All trips from Firestore
                    final allTrips = snapshot.data!;

                    // 🔎 Apply filters inside controller
                    final filteredRides = controller.filterTrips(allTrips);

                    if (filteredRides.isEmpty) {
                      return const Center(
                        child: Text("No trips found for your search"),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredRides.length,
                      itemBuilder: (context, index) {
                        final ride = filteredRides[index];
                        return CustomPaint(
                          painter: RideCardPainter(),
                          child: Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 6,
                            color: Colors.transparent,
                            shadowColor: AppColors.secondaryColor.withOpacity(
                              0.2,
                            ),
                            child:
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    gradient: LinearGradient(
                                      colors: [
                                        AppColors.cardBackground.withOpacity(
                                          0.95,
                                        ),
                                        Colors.white,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                  ),
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // Left route indicator column
                                          Column(
                                            children: [
                                              // Start point
                                              const Icon(
                                                Icons.radio_button_checked,
                                                color: Colors.green,
                                                size: 18,
                                              ),
                                              // Vertical line
                                              if (ride.stops != null &&
                                                  ride.stops.isNotEmpty)
                                                ...List.generate(
                                                  ride.stops.length,
                                                  (index) => Container(
                                                    width: 2,
                                                    height: 15,
                                                    color: Colors.grey
                                                        .withOpacity(0.5),
                                                  ),
                                                ),

                                              // End point
                                              const Icon(
                                                Icons.location_on,
                                                color: Colors.redAccent,
                                                size: 18,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(width: 8),

                                          // Right text column
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                // Pickup
                                                Text(
                                                  ride.pickupLocation,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: AppColors.textColor,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),

                                                // Drop
                                                Text(
                                                  ride.dropLocation,
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: AppColors.textColor,
                                                  ),
                                                ),

                                                // Stops (if any)
                                                if (ride.stops != null &&
                                                    ride.stops.isNotEmpty)
                                                  ...ride.stops.map(
                                                    (stop) => Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                            bottom: 4,
                                                          ),
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                            Icons.circle,
                                                            size: 6,
                                                            color: Colors.grey,
                                                          ),
                                                          const SizedBox(
                                                            width: 6,
                                                          ),
                                                          Text(
                                                            stop,
                                                            style: TextStyle(
                                                              color: AppColors
                                                                  .textColor
                                                                  .withOpacity(
                                                                    0.8,
                                                                  ),
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
                                      const Divider(height: 20),

                                      // Ride info section
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _infoItem(
                                            Icons.access_time,
                                            "Departure",
                                            DateFormat(
                                              'dd MMM, hh:mm a',
                                            ).format(ride.departureTime),
                                          ),
                                          _infoItem(
                                            Icons.event_seat,
                                            "Seats",
                                            "${ride.seatsAvailable}",
                                          ),
                                          _infoItem(
                                            Icons.attach_money,
                                            "Fare",
                                            "${ride.fare}",
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ).onTapWidget(
                                  onTap: () {
                                    Get.toNamed(
                                      AppRoutes.tripDetails,
                                      arguments: ride,
                                    );
                                  },
                                ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

Widget _infoItem(IconData icon, String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade700),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
          ),
        ],
      ),
      Text(
        value,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.textColor,
        ),
      ),
    ],
  );
}

class RideCardPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [Colors.blue.withOpacity(0.08), Colors.green.withOpacity(0.04)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      const Radius.circular(20),
    );
    canvas.drawRRect(rrect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
