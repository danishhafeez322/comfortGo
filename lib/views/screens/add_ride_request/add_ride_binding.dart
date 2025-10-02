import 'package:comfort_go/controllers/ride_request_controller.dart';
import 'package:get/get.dart';

class AddRideBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RideRequestController());
  }
}
