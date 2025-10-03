import 'package:comfort_go/controllers/request_list_controller.dart';
import 'package:comfort_go/utils/app_sizes.dart';
import 'package:comfort_go/utils/spacer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RequestedRidesScreen extends GetView<RideRequestListController> {
  const RequestedRidesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          vSpace(0.05.sh),
          Text(
            "Ride Requests",
            style: TextStyle(
              fontSize: FontSizes.largeFontSize(),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),

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
                        height: 500,
                        child: Center(child: Text("No requests found")),
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
                    return Card(
                      child: ListTile(
                        title: Text(
                          "${request.pickupLocation} → ${request.destination}",
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Passenger: ${request.passengerName}"),
                            Text("Seats Needed: ${request.seatsNeeded}"),
                            Text(
                              "Time: ${DateFormat('dd MMM, hh:mm a').format(request.time)}",
                            ),
                            if (!request.isCompleted)
                              Text("Contact: ${request.contactNumber}"),
                            if (request.isCompleted)
                              const Text(
                                "✅ Completed",
                                style: TextStyle(color: Colors.green),
                              ),
                          ],
                        ),
                        trailing:
                            (!request.isCompleted &&
                                request.ownerId ==
                                    FirebaseAuth
                                        .instance
                                        .currentUser
                                        ?.uid) // ✅ only owner
                            ? IconButton(
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                onPressed: () {
                                  controller.markCompleted(request.id);
                                },
                              )
                            : null,
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
