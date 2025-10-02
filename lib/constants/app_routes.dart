import 'package:comfort_go/views/screens/add_ride_request/add_ride_binding.dart';
import 'package:comfort_go/views/screens/add_ride_request/add_ride_request.dart';
import 'package:comfort_go/views/screens/dashboard/components/dashboard_binding.dart';
import 'package:comfort_go/views/screens/dashboard/dashboard.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String initial = '/';
  static const String addRideRequests = '/add-ride-requests';

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
  ];
}
