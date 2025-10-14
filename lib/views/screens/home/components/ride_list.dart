import 'package:flutter/material.dart';
import '../../../../models/ride_model.dart';
import 'ride_card.dart';

class RideListView extends StatelessWidget {
  final List<Ride> rides;
  final ScrollController? scrollController;
  final bool isLoadingMore;

  const RideListView({
    super.key,
    required this.rides,
    this.scrollController,
    this.isLoadingMore = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: scrollController,
      padding: const EdgeInsets.only(bottom: 80),
      itemCount: rides.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        // 🧭 If loading more and at last item — show spinner
        if (isLoadingMore && index == rides.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
          );
        }

        final ride = rides[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: RideCard(ride: ride),
        );
      },
    );
  }
}
