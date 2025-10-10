import 'package:comfort_go/controllers/add_my_ride_controller.dart';
import 'package:get/get.dart';

class AddMyRideBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddMyRideController());
  }
}
