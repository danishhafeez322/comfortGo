import 'package:comfort_go/constants/app_colors.dart';
import 'package:comfort_go/extentions/on_tap_extension.dart';
import 'package:flutter/material.dart';

class CommonWidgets {
  static Widget space({double? height = 0, double? width = 0}) {
    return SizedBox(height: height, width: width);
  }

  static circularProgressIndicator({EdgeInsets? padding, Color? color}) {
    return Center(
      child: Padding(
        padding: padding ?? const EdgeInsets.all(0),
        child: CircularProgressIndicator(
          color: color ?? AppColors.secondaryColor,
        ),
      ),
    );
  }

  static autoText(
    String text,
    Color color, {
    FontWeight? fontWeight,
    double? fontSize,
    TextAlign? textAlign,
  }) {
    return FittedBox(
      child: Text(
        text,
        textAlign: textAlign ?? TextAlign.center,
        style: TextStyle(
          color: color,
          fontWeight: fontWeight,
          fontSize: fontSize ?? 12,
        ),
      ),
    );
  }

  static actionButton(
    String text,
    Function onTap, {
    Color? textColor,
    Color? backColor,
  }) {
    return Material(
      color: backColor ?? Colors.grey[350],
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(
            text,
            style: TextStyle(
              color: textColor ?? AppColors.secondaryColor,
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    ).onTapWidget(
      onTap: () {
        onTap.call();
      },
    );
  }

  static customCard({
    double? elevation,
    Color? backgroundColor,
    Widget? child,
    double borderWidth = 1,
    bool checkInternet = false,
    Function? onTap,
    EdgeInsetsGeometry margin = EdgeInsets.zero,
    double borderRadius = 5,
  }) {
    return Card(
      elevation: elevation ?? 10,
      margin: margin,
      clipBehavior: Clip.antiAlias,
      shadowColor: Colors.black,
      color: backgroundColor ?? Colors.white,
      // shape: borderWidth >= 0
      //     ? RoundedRectangleBorder(
      //         side: BorderSide(width: borderWidth),
      //         borderRadius: BorderRadius.circular(borderRadius),
      //       )
      //     : null,
      child: child,
    ).onTapWidget(
      wantToCheckInternet: checkInternet,
      onTap: () {
        if (onTap != null) onTap.call();
      },
    );
  }
}
