import 'package:comfort_go/extentions/on_tap_extension.dart';

import '../../../constants/app_colors.dart';
import '../../../utils/app_sizes.dart';
import '../../../utils/device_type_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ExpandedButton extends StatelessWidget {
  final Widget? prefix;
  final Widget? suffix;
  final bool? selected;
  final bool? disabled;
  final String? title;
  final Widget? titleWidget;
  final Function? onTap;
  final double? height;
  final double? txtSize;
  final double horizontalPadding;
  final Color? btnTxtColor;
  final Color? btnColor;
  final Gradient? btnGradientColor;
  final bool? isRow;
  final String? toolTipMessage;
  final double? roundCorner;
  final FontWeight? fontWeight;
  final bool isCheckConnectivity;
  final bool showBorder;
  final Color? borderColor;
  final MainAxisAlignment? mainAxisAlignment;
  const ExpandedButton({
    super.key,
    this.prefix,
    required this.selected,
    this.disabled,
    required this.onTap,
    required this.title,
    this.height,
    this.btnColor,
    this.toolTipMessage,
    this.isRow = false,
    this.txtSize,
    this.btnTxtColor,
    this.roundCorner,
    this.horizontalPadding = 20,
    this.fontWeight,
    this.btnGradientColor,
    this.suffix,
    this.mainAxisAlignment,
    this.isCheckConnectivity = false,
    this.titleWidget,
    this.showBorder = false,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = [
      if (prefix != null) ...[prefix!, SizedBox(width: isRow! ? 10.w : 15.w)],
      Flexible(
        child:
            titleWidget ??
            FittedBox(
              child: Text(
                title!,
                textAlign: TextAlign.center,
                // maxLines: 2,
                style: TextStyle(
                  fontWeight: fontWeight ?? FontWeight.w500,
                  fontSize: txtSize ?? (isTablet(context) ? 12.sp : 17.sp),
                  color: btnTxtColor ?? Colors.white,
                ),
              ),
            ),
      ),
      if (suffix != null) ...[SizedBox(width: isRow! ? 10.w : 15.w), suffix!],
    ];
    return Tooltip(
      message: toolTipMessage ?? title,
      child:
          Container(
            height:
                height ?? (isTablet(context) || isLandScape() ? 35.w : 60.w),
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding.w),
            decoration: BoxDecoration(
              color: selected!
                  ? (btnColor ?? AppColors.secondaryColor)
                  : btnColor?.withValues(alpha: 0.4) ?? AppColors.greyColor,
              gradient: selected! ? btnGradientColor : null,
              border: showBorder
                  ? Border.all(
                      color: borderColor ?? AppColors.lightBackgroundColor,
                      width: 1.0,
                    )
                  : null,
              borderRadius: BorderRadius.circular(
                roundCorner ?? appBorderRadius.r,
              ),
            ),
            child: isRow!
                ? Row(
                    mainAxisAlignment:
                        mainAxisAlignment ?? MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: widgetList,
                  )
                : Column(
                    mainAxisAlignment:
                        mainAxisAlignment ?? MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: widgetList,
                  ),
          ).onTapWidget(
            wantToCheckInternet: isCheckConnectivity,
            isDisabled: disabled ?? false,
            onTap: () {
              if (onTap != null) onTap!.call();
            },
          ),
    );
  }
}
