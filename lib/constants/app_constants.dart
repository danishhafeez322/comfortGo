import '../../constants/app_colors.dart';
import '../../utils/app_sizes.dart';
import 'package:flutter/material.dart';

class AppConstants {
  static TextStyle fieldStyle = TextStyle(
    // color: appController.appTheme.value.primaryColor,
    fontSize: AppCommonSizes.fieldFontSize(),
    fontWeight: FontWeight.w400,
  );
  static InputDecoration simpleTextFieldDecoration = InputDecoration(
    filled: true,
    fillColor: AppColors.whiteColor,
    contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 0),
    hintStyle: fieldStyle,

    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(appBorderRadius),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(appBorderRadius),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(appBorderRadius),
      borderSide: BorderSide.none,
    ),
  );

  static const int pageSizeLimit = 10;
  static int otpResendTime = 30;
}
