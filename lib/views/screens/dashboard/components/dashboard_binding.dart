import 'package:comfort_go/controllers/dashboard_controller.dart';
import 'package:comfort_go/controllers/request_list_controller.dart';
import 'package:get/get.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DashboardController(), fenix: true);
    Get.lazyPut(() => RideRequestListController(), fenix: true);
  }
}
