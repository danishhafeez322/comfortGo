import 'package:comfort_go/constants/app_routes.dart';
import 'package:comfort_go/extentions/on_tap_extension.dart';
import 'package:comfort_go/utils/spacer.dart';

import '../../../../constants/app_colors.dart';
import '../../../../constants/app_strings.dart';
import '../../../../controllers/dashboard_controller.dart';
import '../../../../utils/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class FabButton extends GetView<DashboardController> {
  final String? title;
  final VoidCallback? onTap;
  const FabButton({super.key, this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 134,
      height: 40,
      decoration: BoxDecoration(
        color: controller.isFabOpen.value
            ? AppColors.floatingButtonActiveColor
            : AppColors.backButtonColors,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FittedBox(
            child: Text(
              title ?? AppStrings.addRideRequest,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: FontSizes.smallFontSize(),
              ),
            ),
          ),
          hSpace(5),
          Icon(
            Icons.add,
            color: Colors.white,
            size: AppWidgetSizes.smallIconSize(),
          ),
        ],
      ),
    ).onTapWidget(
      onTap:
          onTap ??
          () {
            Get.toNamed(AppRoutes.addRideRequests);
          },
    );
  }
}
