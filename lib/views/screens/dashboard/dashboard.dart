import 'package:comfort_go/constants/app_colors.dart';
import 'package:comfort_go/constants/app_routes.dart';
import 'package:comfort_go/constants/enums.dart';
import 'package:comfort_go/controllers/dashboard_controller.dart';
import 'package:comfort_go/extentions/common_extensions.dart';
import 'package:comfort_go/views/screens/dashboard/components/bottom_nav_item.dart';
import 'package:comfort_go/views/screens/dashboard/components/fab_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class Dashboard extends GetView<DashboardController> {
  const Dashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final controller = Get.find<DashboardController>();
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: AppColors.whiteColor,
        body: SafeArea(
          child: Stack(
            children: [
              IndexedStack(
                index: controller.currentView.value.index,
                children: DashBoardView.values
                    .map((view) => controller.screens[view]!)
                    .toList(),
              ),

              // Blur overlay when FAB menu is open
              // if (controller.isFabOpen.value)
              //   Positioned.fill(
              //     child: BackdropFilter(
              //       filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              //       child:
              //           Container(
              //             color: Colors.white.withAlpha(
              //               165,
              //             ), // Optional: dim effect
              //           ).onTapWidget(
              //             onTap: () {
              //               controller.isFabOpen.value = false;
              //             },
              //           ),
              //     ),
              //   ),
              // FAB Menu Overlay
              // if (controller.isFabOpen.value) const PositionedFABMenu(),
            ],
          ),
        ),

        bottomNavigationBar: _BottomNavBar(),
        floatingActionButton: Obx(
          () => controller.isOnRootScreen.value
              ? FabButton()
              : controller.currentView.value.name ==
                    DashBoardView.offerRide.name
              ? FabButton(
                  title: "Offer a ride",
                  onTap: () => Get.toNamed(AppRoutes.addRideScreen),
                )
              : const SizedBox(),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
    });
  }
}

class _BottomNavBar extends GetView<DashboardController> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 74,
      width: 0.92.sw,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(2.r),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: DashBoardView.values.map((view) {
          return BottomNavItem(
            index: view.index,
            label: view.value,
            customIconString: view.icon,
            isSelected: controller.currentView.value == view,
            onTap: () => controller.selectBottomTab(view),
          );
        }).toList(),
      ),
    );
  }
}
