import 'package:comfort_go/controllers/my_ride_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/app_sizes.dart';
import '../../../utils/spacer.dart';

class MyRidesScreen extends GetView<MyRideController> {
  const MyRidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          vSpace(0.05.sh),
          Text(
            "My Offered Rides",
            style: TextStyle(
              fontSize: FontSizes.largeFontSize(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.myRides.isEmpty) {
                return RefreshIndicator(
                  onRefresh: controller.refreshMyRides,
                  child: ListView(
                    children: const [
                      SizedBox(
                        height: 300,
                        child: Center(child: Text("No rides offered yet.")),
                      ),
                    ],
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: controller.refreshMyRides,
                child: ListView.builder(
                  itemCount: controller.myRides.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final ride = controller.myRides[index];
                    return ListTile(
                      title: Text(
                        "${ride.pickupLocation} → ${ride.dropLocation}",
                      ),
                      subtitle: Text(
                        "${ride.vehicleModel} (${ride.vehicleColor}, ${ride.vehicleYear})\nSeats: ${ride.seatsAvailable}",
                      ),
                      trailing: Text(
                        "${ride.departureTime.day}/${ride.departureTime.month} "
                        "${ride.departureTime.hour}:${ride.departureTime.minute}",
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],

        // floatingActionButton: FloatingActionButton(
        //   onPressed: () => Get.to(() => const AddRideScreen()),
        //   child: const Icon(Icons.add),
        // ),
      ),
    );
  }
}
