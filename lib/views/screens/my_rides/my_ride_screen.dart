import 'package:comfort_go/constants/app_colors.dart';
import 'package:comfort_go/controllers/my_ride_controller.dart';
import 'package:comfort_go/views/widgets/common_widgets/custom_bg_paint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart'; // for date formatting

import '../../../utils/app_sizes.dart';
import '../../../utils/spacer.dart';

class MyRidesScreen extends GetView<MyRideController> {
  const MyRidesScreen({super.key});

  String formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: CustomPaint(painter: BackgroundPainter())),
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              vSpace(0.01.sh),
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
                            height: 600,
                            child: Center(
                              child: Text(
                                "No rides offered yet.",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.refreshMyRides,
                    child: ListView.builder(
                      itemCount: controller.myRides.length,
                      itemBuilder: (context, index) {
                        final ride = controller.myRides[index];

                        return Card(
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 4,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 3,
                          color: AppColors.cardBackground,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Top Section: Pickup → Drop
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.directions_car,
                                      color: AppColors.primaryColor,
                                    ),
                                    hSpace(8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${ride.pickupLocation} → ${ride.dropLocation}",
                                            style: TextStyle(
                                              fontSize:
                                                  FontSizes.mediumFontSize(),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          vSpace(2),
                                          Text(
                                            "Departure: ${formatDateTime(ride.departureTime)}",
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                vSpace(10),

                                // Vehicle Info Row
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.local_taxi,
                                        color: Colors.blueGrey,
                                      ),
                                      hSpace(8),
                                      Expanded(
                                        child: Text(
                                          "${ride.vehicleModel} (${ride.vehicleColor}, ${ride.vehicleYear})",
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                vSpace(8),

                                // Fare & Seats Row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.event_seat,
                                          color: Colors.teal,
                                        ),
                                        hSpace(4),
                                        Text(
                                          "Seats: ${ride.seatsAvailable}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.attach_money,
                                          color: Colors.green,
                                        ),
                                        hSpace(4),
                                        Text(
                                          "Fare: ${ride.fare}",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                vSpace(10),

                                // Actions
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    TextButton.icon(
                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      ),
                                      label: const Text("Edit"),
                                      onPressed: () {
                                        controller.editRide(ride.id, {
                                          "fare": "1500", // example update
                                          "seatsAvailable": 3,
                                        });
                                      },
                                    ),
                                    TextButton.icon(
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                      label: const Text("Delete"),
                                      onPressed: () {
                                        Get.defaultDialog(
                                          title: "Delete Ride",
                                          middleText:
                                              "Are you sure you want to delete this ride?",
                                          textConfirm: "Yes",
                                          textCancel: "No",
                                          confirmTextColor: Colors.white,
                                          onConfirm: () {
                                            controller.deleteRide(ride.id);
                                            Get.back();
                                          },
                                        );
                                      },
                                    ),
                                  ],
                                ),

                                const Divider(),

                                // Reservations Section
                                if (ride.reservations.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.symmetric(vertical: 8),
                                    child: Text(
                                      "No reservations yet.",
                                      style: TextStyle(color: Colors.grey),
                                    ),
                                  )
                                else
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        "Reservations:",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      vSpace(4),
                                      ...ride.reservations.asMap().entries.map((
                                        entry,
                                      ) {
                                        final index = entry.key;
                                        final reservation = entry.value;

                                        return Card(
                                          margin: const EdgeInsets.symmetric(
                                            vertical: 4,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: ListTile(
                                            leading: const Icon(Icons.person),
                                            title: Text(reservation.userName),
                                            subtitle: Text(
                                              "Contact: ${reservation.userContact}\n"
                                              "Seats reserved: ${reservation.seatsReserved}",
                                            ),
                                            trailing:
                                                reservation.status == "pending"
                                                ? Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      IconButton(
                                                        icon: const Icon(
                                                          Icons.check,
                                                          color: Colors.green,
                                                        ),
                                                        onPressed: () => controller
                                                            .updateReservationStatus(
                                                              ride.id,
                                                              reservation
                                                                  .userId,
                                                              "accepted",
                                                              index,
                                                            ),
                                                      ),
                                                      IconButton(
                                                        icon: const Icon(
                                                          Icons.close,
                                                          color: Colors.red,
                                                        ),
                                                        onPressed: () => controller
                                                            .updateReservationStatus(
                                                              ride.id,
                                                              reservation
                                                                  .userId,
                                                              "rejected",
                                                              index,
                                                            ),
                                                      ),
                                                    ],
                                                  )
                                                : Text(
                                                    reservation.status
                                                        .toUpperCase(),
                                                    style: TextStyle(
                                                      color:
                                                          reservation.status ==
                                                              "accepted"
                                                          ? Colors.green
                                                          : Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                              ],
                            ),
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
