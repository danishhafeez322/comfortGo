import 'package:flutter/material.dart';

import '../../../../models/ride_model.dart';
import 'ride_card.dart';

class RideListView extends StatelessWidget {
  final List<Ride> rides;
  const RideListView({super.key, required this.rides});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: rides.length,
      itemBuilder: (context, index) {
        return RideCard(ride: rides[index]);
      },
    );
  }
}
