import 'package:get/get.dart';
import '../models/ride_request_model.dart';
import '../repositories/firebase_repository.dart';

class RideRequestListController extends GetxController {
  final FirebaseRepository _repository = FirebaseRepository();

  RxList<RideRequestModel> rideRequests = <RideRequestModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRideRequests();
  }

  Future<void> fetchRideRequests() async {
    isLoading.value = true;
    final requests = await _repository.getRideRequests();
    rideRequests.assignAll(requests);
    isLoading.value = false;
  }

  Future<void> markCompleted(String requestId) async {
    await _repository.markRequestCompleted(requestId);
    fetchRideRequests(); // refresh list
  }
}
