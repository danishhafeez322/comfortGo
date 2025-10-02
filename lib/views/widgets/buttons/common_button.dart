import 'package:comfort_go/extentions/on_tap_extension.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonButton extends StatelessWidget {
  final bool isWidthInfinite;
  final double? width;
  final bool fixedHeight;
  final double? height;
  final Function onTap;
  final String label;
  final Color? labelColor;
  final Color? buttonColor;
  final bool isButtonDisabled;
  final double? fontSize;
  final FontWeight? fontWeight;
  final EdgeInsetsGeometry? padding;
  final Widget? extraWidget;
  CommonButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isWidthInfinite = true,
    this.width,
    this.fixedHeight = false,
    this.height,
    this.labelColor,
    this.isButtonDisabled = false,
    this.buttonColor,
    this.fontSize,
    this.padding,
    this.fontWeight,
    this.extraWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Container(
        height: fixedHeight
            ? height ?? AppCommonSizes.commonButtonHeight()
            : null,
        width: isWidthInfinite
            ? double.infinity
            : width ?? AppCommonSizes.commonButtonWidth(),
        padding: padding ?? AppCommonSizes.commonButtonPadding(),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(appBorderRadius),
          color: buttonColor ?? AppColors.primaryColor,
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: fontSize ?? AppCommonSizes.commonButtonFontSize(),
                  color: labelColor ?? AppColors.whiteColor,
                  fontWeight: fontWeight ?? FontWeight.w500,
                ),
              ),
              if (extraWidget != null) extraWidget!,
            ],
          ),
        ),
      ).onTapWidget(onTap: () => onTap(), isDisabled: isButtonDisabled);
    });
  }
}
