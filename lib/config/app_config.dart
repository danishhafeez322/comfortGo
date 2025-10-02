import 'package:comfort_go/controllers/common_controllers/connectivity_controller.dart';
import 'package:comfort_go/controllers/dashboard_controller.dart';
import 'package:get/get.dart';

class AppConfigurations {
  static Future<void> initialize() async {
    Get.lazyPut(() => DashboardController(), fenix: true);
    Get.put(ConnectionManagerController());
  }
}
