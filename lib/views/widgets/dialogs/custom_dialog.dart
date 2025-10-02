import 'package:comfort_go/extentions/on_tap_extension.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/app_sizes.dart';
import '../../../utils/device_type_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String btnTitle;
  final Widget? body;
  final EdgeInsets? bodyPadding;
  final EdgeInsets? insetPadding;
  final Function()? onActionTap;
  final Function()? onExitTap;
  final Function(bool, Object?)? onPopInvokedWithResult;
  final bool isCheckConnectivity;
  final bool isExitIcon;
  final bool canPop;
  final Color? btnColor;
  final Color? exitBTNColor;
  final Color? titleBarColor;
  final Color? titleColor;
  final Color? btnTitleColor;
  final BoxConstraints? constraints;
  final double? borderRadius;

  const CustomDialog({
    super.key,
    this.title = "",
    this.body,
    this.bodyPadding,
    this.onActionTap,
    this.insetPadding,
    this.btnTitle = "",
    this.btnColor,
    this.titleBarColor,
    this.titleColor,
    this.constraints,
    this.isCheckConnectivity = false,
    this.isExitIcon = false,
    this.onExitTap,
    this.btnTitleColor,
    this.exitBTNColor,
    this.borderRadius,
    this.onPopInvokedWithResult,
    this.canPop = true,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: onPopInvokedWithResult,
      child: Dialog(
        insetPadding: insetPadding,
        shape: borderRadius != null
            ? RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius!),
              )
            : null,
        child: Container(
          constraints: constraints,
          // constraints: constraints ?? CustomDialogSizes.dialogConstraints(),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (title.isNotEmpty)
                Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: titleBarColor ?? Colors.transparent,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10.r),
                          topRight: Radius.circular(10.r),
                        ),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: isLandScape() ? 5.w : 10.w,
                            ),
                            child: FittedBox(
                              child: Text(
                                title,
                                style: TextStyle(
                                  fontSize: CustomDialogSizes.fontSize(),
                                  fontWeight: FontWeight.w600,
                                  color: titleColor,
                                ),
                              ),
                            ),
                          ),
                          Divider(height: 0.w),
                        ],
                      ),
                    ),
                    if (isExitIcon)
                      Positioned(
                        top: 0,
                        bottom: 0,
                        right: isLandScape() ? 5.w : 10.w,
                        child:
                            Icon(
                              Icons.cancel,
                              color: exitBTNColor,
                              size: isLandScape() ? 15.w : 25.w,
                            ).onTapWidget(
                              onTap:
                                  onExitTap ??
                                  () {
                                    Get.back();
                                  },
                            ),
                      ),
                  ],
                ),
              Flexible(
                child: Container(
                  padding: bodyPadding ?? CustomDialogSizes.bodyPadding(),
                  child: body ?? const SizedBox.shrink(),
                ),
              ),
              if (onActionTap != null)
                Container(
                  height: CustomDialogSizes.actionHeight(),
                  decoration: BoxDecoration(
                    color: btnColor ?? AppColors.mediumGreenStatus,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(borderRadius ?? 10.r),
                      bottomRight: Radius.circular(borderRadius ?? 10.r),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      btnTitle.toUpperCase(),
                      style: TextStyle(
                        fontSize: CustomDialogSizes.fontSize(),
                        fontWeight: FontWeight.w600,
                        color: btnTitleColor ?? Colors.white,
                      ),
                    ),
                  ),
                ).onTapWidget(
                  wantToCheckInternet: isCheckConnectivity,
                  onTap: onActionTap ?? () {},
                ),
            ],
          ),
        ),
      ),
    );
  }
}
