import '../../../constants/app_colors.dart';
import '../../../views/widgets/common_widgets/common_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmationDialog extends StatelessWidget {
  const ConfirmationDialog({
    super.key,
    this.title,
    this.message,
    this.okText,
    this.cancelText,
  });

  final String? title;
  final String? message;
  final String? okText;
  final String? cancelText;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: CupertinoAlertDialog(
        title: title != null
            ? Text(
                title!,
                style: const TextStyle(
                  color: AppColors.textColor,
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // AssetView(
                  //   imagePath: AssetsPath.logoPath,
                  //   height: isTablet(context)
                  //       ? 20.w
                  //       : isLandScape()
                  //           ? 30.w
                  //           : 60.w,
                  //   width: isTablet(context) ? 30.w : 40.w,
                  // ),
                ],
              ),
        content: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: Text(
            "$message",
            style: const TextStyle(
              color: AppColors.textColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        actions: [
          CommonWidgets.actionButton(
            cancelText!,
            () {
              Get.back(result: false);
            },
            textColor: AppColors.textColor,
            backColor: AppColors.lightGrey,
          ),
          CommonWidgets.actionButton(
            okText!,
            () {
              Get.back(result: true);
            },
            textColor: Colors.white,
            backColor: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}
