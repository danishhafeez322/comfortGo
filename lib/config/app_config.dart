import 'package:comfort_go/controllers/common_controllers/connectivity_controller.dart';
import 'package:get/get.dart';

class AppConfigurations {
  static Future<void> initialize() async {
    Get.put(ConnectionManagerController());
  }
}
