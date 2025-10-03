import 'package:comfort_go/constants/app_colors.dart';
import 'package:comfort_go/controllers/my_ride_controller.dart';
import 'package:comfort_go/views/widgets/common_widgets/custom_bg_paint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/app_sizes.dart';
import '../../../utils/spacer.dart';

class MyRidesScreen extends GetView<MyRideController> {
  const MyRidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: CustomPaint(
            painter: BackgroundPainter(), // Your custom background
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              vSpace(0.05.sh),
              Text(
                "My Offered Rides",
                style: TextStyle(
                  fontSize: FontSizes.largeFontSize(),
                  fontWeight: FontWeight.bold,
                ),
              ),
              vSpace(0.02.sh),
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
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 4,
                          color:
                              AppColors.cardBackground, // Use F9FAF9 Off-White
                          shadowColor: AppColors.secondaryColor.withOpacity(
                            0.3,
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ExpansionTile(
                            title: Text(
                              "${ride.pickupLocation} → ${ride.dropLocation}",
                            ),
                            subtitle: Text(
                              "${ride.vehicleModel} (${ride.vehicleColor}, ${ride.vehicleYear})\nSeats: ${ride.seatsAvailable}\n"
                              "Fare: ${ride.fare}",
                            ),
                            trailing: Text(
                              "${ride.departureTime.day}/${ride.departureTime.month} "
                              "${ride.departureTime.hour}:${ride.departureTime.minute}",
                            ),
                            children: [
                              if (ride.reservations.isEmpty)
                                const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text("No reservations yet."),
                                )
                              else
                                Column(
                                  children: ride.reservations.map((
                                    reservation,
                                  ) {
                                    return ListTile(
                                      title: Text(reservation.userName),
                                      subtitle: Text(
                                        "Seats reserved: ${reservation.seatsReserved}",
                                      ),
                                      trailing: reservation.status == "pending"
                                          ? Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.check,
                                                    color: Colors.green,
                                                  ),
                                                  onPressed: () {
                                                    controller
                                                        .updateReservationStatus(
                                                          ride.id,
                                                          reservation.userId,
                                                          "accepted",
                                                        );
                                                  },
                                                ),
                                                IconButton(
                                                  icon: const Icon(
                                                    Icons.close,
                                                    color: Colors.red,
                                                  ),
                                                  onPressed: () {
                                                    controller
                                                        .updateReservationStatus(
                                                          ride.id,
                                                          reservation.userId,
                                                          "rejected",
                                                        );
                                                  },
                                                ),
                                              ],
                                            )
                                          : Text(
                                              reservation.status.toUpperCase(),
                                              style: TextStyle(
                                                color:
                                                    reservation.status ==
                                                        "accepted"
                                                    ? Colors.green
                                                    : Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                    );
                                  }).toList(),
                                ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
