import 'package:comfort_go/constants/enums.dart';
import 'package:comfort_go/views/screens/offer_ride/offer_ride_screen.dart';
import 'package:comfort_go/views/screens/requests/request_screen.dart';

import '../../views/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardController extends GetxController {
  final Rx<DashBoardView> currentView = DashBoardView.home.obs;
  late final ScrollController pwsListController;

  RxBool isFabOpen = false.obs;
  final isOnRootScreen = false.obs;

  @override
  void onInit() {
    super.onInit();
    pwsListController = ScrollController();
  }

  final Map<DashBoardView, Widget> screens = {
    DashBoardView.home: HomeScreen(),
    DashBoardView.offerRide: OfferRideScreen(),
    DashBoardView.requests: RideRequestsListScreen(),
  };

  void selectBottomTab(DashBoardView view) {
    if (view != currentView.value) {
      currentView.value = view;
      if (view != DashBoardView.requests) {
        isOnRootScreen.value = false;
      } else {
        isOnRootScreen.value = true;
      }
    }
  }

  void toggleFab() => isFabOpen.toggle();
}
