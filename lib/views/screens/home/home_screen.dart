import 'package:comfort_go/constants/app_colors.dart';
import 'package:comfort_go/constants/app_routes.dart';
import 'package:comfort_go/controllers/home_controller.dart';
import 'package:comfort_go/extentions/on_tap_extension.dart';
import 'package:comfort_go/models/ride_model.dart';
import 'package:comfort_go/utils/app_sizes.dart';
import 'package:comfort_go/utils/spacer.dart';
import 'package:comfort_go/views/widgets/buttons/custom_button.dart';
import 'package:comfort_go/views/widgets/text_widgets/common_text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          Text(
            "Find a Trip",
            style: TextStyle(
              fontSize: FontSizes.largeFontSize(),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          // 🔍 Search Filters
          Row(
            children: [
              Expanded(
                child: CommonTextFieldWidget(
                  controller: controller.pickupController,
                  hintText: "Pickup City",
                  onChanged: (_) => controller.filterTrips(controller.rides),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: CommonTextFieldWidget(
                  controller: controller.dropController,
                  hintText: "Drop City",
                  onChanged: (_) => controller.filterTrips(controller.rides),
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
                final filteredTrips = controller.filterTrips(allTrips);

                if (filteredTrips.isEmpty) {
                  return const Center(
                    child: Text("No trips found for your search"),
                  );
                }

                return ListView.builder(
                  itemCount: filteredTrips.length,
                  itemBuilder: (context, index) {
                    final trip = filteredTrips[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 4,
                      color: AppColors.cardBackground, // Use F9FAF9 Off-White
                      shadowColor: AppColors.secondaryColor.withOpacity(0.3),
                      child: ListTile(
                        title: Text(
                          "${trip.pickupLocation} → ${trip.dropLocation}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textColor,
                          ),
                        ),
                        subtitle: Text(
                          "Departure: ${DateFormat('dd MMM, hh:mm a').format(trip.departureTime)}\n"
                          "Seats: ${trip.seatsAvailable}\n"
                          "Fare: ${trip.fare}",
                          style: TextStyle(color: AppColors.textColor),
                        ),
                        onTap: () {
                          Get.toNamed(AppRoutes.tripDetails, arguments: trip);
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
