import 'package:comfort_go/constants/app_colors.dart';
import 'package:comfort_go/controllers/request_list_controller.dart';
import 'package:comfort_go/utils/app_sizes.dart';
import 'package:comfort_go/utils/spacer.dart';
import 'package:comfort_go/views/widgets/common_widgets/custom_bg_paint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RequestedRidesScreen extends GetView<RideRequestListController> {
  const RequestedRidesScreen({super.key});

  String formatDateTime(DateTime dateTime) {
    return DateFormat('dd MMM yyyy, hh:mm a').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(child: CustomPaint(painter: BackgroundPainter())),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              vSpace(0.01.sh),
              Text(
                "Ride Requests",
                style: TextStyle(
                  fontSize: FontSizes.largeFontSize(),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              /// Pull-to-refresh section
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.rideRequests.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: controller.fetchRideRequests,
                      child: ListView(
                        children: const [
                          SizedBox(
                            height: 600,
                            child: Center(
                              child: Text(
                                "No requests found.",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: controller.fetchRideRequests,
                    child: ListView.builder(
                      itemCount: controller.rideRequests.length,
                      itemBuilder: (context, index) {
                        final request = controller.rideRequests[index];
                        final isOwner =
                            request.ownerId ==
                            FirebaseAuth.instance.currentUser?.uid;

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
                          shadowColor: AppColors.secondaryColor.withOpacity(
                            0.25,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 🔹 Route header
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Icon(
                                      Icons.route,
                                      color: AppColors.primaryColor,
                                    ),
                                    hSpace(8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${request.pickupLocation} → ${request.destination}",
                                            style: TextStyle(
                                              fontSize:
                                                  FontSizes.mediumFontSize(),
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          vSpace(2),
                                          Text(
                                            "Departure: ${formatDateTime(request.time)}",
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

                                // 🔹 Passenger Info Card
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.person_outline,
                                        color: Colors.blueGrey,
                                      ),
                                      hSpace(8),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              request.passengerName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            vSpace(2),
                                            Text(
                                              "Seats Needed: ${request.seatsNeeded}",
                                              style: const TextStyle(
                                                fontSize: 13,
                                                color: Colors.black54,
                                              ),
                                            ),
                                            if (!request.isCompleted)
                                              Text(
                                                "Contact: ${request.contactNumber}",
                                                style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black54,
                                                ),
                                              ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                vSpace(10),

                                // 🔹 Status or Action
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (request.isCompleted)
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade100,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              size: 18,
                                              color: Colors.green,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              "Completed",
                                              style: TextStyle(
                                                color: Colors.green,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    else
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.shade100,
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                        ),
                                        child: const Row(
                                          children: [
                                            Icon(
                                              Icons.pending,
                                              size: 18,
                                              color: Colors.orangeAccent,
                                            ),
                                            SizedBox(width: 6),
                                            Text(
                                              "Pending",
                                              style: TextStyle(
                                                color: Colors.orangeAccent,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                    // ✅ Complete Button for Owner
                                    if (!request.isCompleted && isOwner)
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 8,
                                          ),
                                        ),
                                        onPressed: () => controller
                                            .markCompleted(request.id),
                                        icon: const Icon(Icons.check),
                                        label: const Text("Mark Complete"),
                                      ),
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
