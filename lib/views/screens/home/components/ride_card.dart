import 'package:comfort_go/extentions/on_tap_extension.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_routes.dart';
import '../../../../models/ride_model.dart';
import 'ride_card_painter.dart';

class RideCard extends StatelessWidget {
  final Ride ride;
  const RideCard({super.key, required this.ride});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: RideCardPainter(),
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 6,
        color: Colors.transparent,
        child:
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    AppColors.cardBackground.withOpacity(0.95),
                    Colors.white,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Route (Pickup → Stops → Drop)
                  _buildRouteSection(),

                  const Divider(height: 20),

                  /// Ride Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      _infoItem(Icons.attach_money, "Fare", ride.fare),
                    ],
                  ),
                ],
              ),
            ).onTapWidget(
              onTap: () => Get.toNamed(AppRoutes.tripDetails, arguments: ride),
            ),
      ),
    );
  }

  Widget _buildRouteSection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Indicators
        Column(
          children: [
            const Icon(
              Icons.radio_button_checked,
              color: Colors.green,
              size: 18,
            ),
            Container(
              width: 2,
              height: 16,
              color: Colors.grey.withOpacity(0.5),
            ),
            const Icon(Icons.location_on, color: Colors.redAccent, size: 18),
          ],
        ),
        const SizedBox(width: 8),

        /// Locations
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
              Text(
                ride.dropLocation,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.textColor,
                ),
              ),
              if (ride.stops.isNotEmpty)
                ...ride.stops.map(
                  (stop) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        const Icon(Icons.circle, size: 6, color: Colors.grey),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            stop,
                            style: TextStyle(
                              color: AppColors.textColor.withOpacity(0.8),
                              fontSize: 13,
                            ),
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
    );
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
}
