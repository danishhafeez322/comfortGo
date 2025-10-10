import 'package:comfort_go/views/screens/add_ride_request/add_ride_binding.dart';
import 'package:comfort_go/views/screens/add_ride_request/add_ride_request.dart';
import 'package:comfort_go/views/screens/dashboard/components/dashboard_binding.dart';
import 'package:comfort_go/views/screens/dashboard/dashboard.dart';
import 'package:comfort_go/views/screens/my_rides/add_my_ride_binding.dart';
import 'package:comfort_go/views/screens/trip_details/trip_details_binding.dart';
import 'package:comfort_go/views/screens/trip_details/trip_details_screen.dart';
import 'package:get/get.dart';

import '../views/screens/my_rides/add_ride_screen.dart';

class AppRoutes {
  static const String initial = '/';
  static const String addRideRequests = '/add-ride-requests';
  static const String addRideScreen = '/add-ride-screen';
  static const String tripDetails = '/trip-detail';

  static List<GetPage> routes = [
    GetPage(
      name: initial,
      page: () => Dashboard(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: addRideRequests,
      page: () => AddRideRequestScreen(),
      binding: AddRideBinding(),
    ),
    GetPage(
      name: addRideScreen,
      page: () => AddRideScreen(),
      binding: AddMyRideBinding(),
    ),
    GetPage(
      name: tripDetails,
      page: () => TripDetailScreen(),
      binding: TripDetailsBinding(),
    ),
  ];
}
