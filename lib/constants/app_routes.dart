import 'package:comfort_go/views/screens/dashboard/dashboard.dart';
import 'package:get/get.dart';

class AppRoutes {
  static const String initial = '/';

  static List<GetPage> routes = [
    GetPage(name: initial, page: () => Dashboard()),
  ];
}
