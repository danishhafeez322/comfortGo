import 'package:comfort_go/constants/app_colors.dart';
import 'package:comfort_go/controllers/home_controller.dart';
import 'package:comfort_go/utils/app_sizes.dart';
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
                child: TextField(
                  controller: controller.pickupController,
                  decoration: InputDecoration(
                    hintText: "Pickup City",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  onChanged: (_) => controller.filterTrips(),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: controller.dropController,
                  decoration: InputDecoration(
                    hintText: "Drop City",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  onChanged: (_) => controller.filterTrips(),
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
                child: TextField(
                  controller: controller.dateController,
                  readOnly: true,
                  decoration: InputDecoration(
                    hintText: "Departure Date",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  onTap: () => controller.pickDepartureDate(context),
                ),
              ),
              SizedBox(
                width: 0.34.sw,
                height: ProfileSizes.searchButtonHeight(),
                child: ExpandedButton(
                  selected: true,
                  btnColor: AppColors.backButtonColors,
                  showBorder: true,
                  borderColor: AppColors.lightGrey,
                  btnTxtColor: AppColors.whiteColor,
                  txtSize: FontSizes.mediumFontSize(),
                  title: "Search",
                  roundCorner: 10,
                  onTap: () async {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // 📋 Trips List
          Expanded(
            child: Obx(() {
              if (controller.filteredTrips.isEmpty) {
                return const Center(child: Text("No trips found"));
              }
              return ListView.builder(
                itemCount: controller.filteredTrips.length,
                itemBuilder: (context, index) {
                  final trip = controller.filteredTrips[index];
                  return Card(
                    child: ListTile(
                      title: Text(
                        "${trip.pickupLocation} → ${trip.dropLocation}",
                      ),
                      subtitle: Text(
                        "Driver: ${trip.driverName}\n"
                        "Departure: ${DateFormat('dd MMM, hh:mm a').format(trip.departureTime)}\n"
                        "Seats: ${trip.seatsAvailable}",
                      ),
                      onTap: () {
                        // Example: Navigate to TripDetail
                        Get.toNamed('/trip-detail', arguments: trip);
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
