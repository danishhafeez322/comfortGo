import '../constants/enums.dart';

import '../constants/app_assets.dart';
import '../constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension HexadecimalColorExtension on String {
  Color toHexadecimalColor() {
    String color = split("#").last;
    int remoteColor = int.parse("0xFF$color");
    return Color(remoteColor);
  }
}

extension CompactNumberExtension on int {
  String toCompactNumber() {
    return NumberFormat.compactCurrency(
      decimalDigits: 0,
      symbol: '',
    ).format(this);
  }
}

extension DashBoardViewExtension on DashBoardView {
  String get value {
    switch (this) {
      case DashBoardView.home:
        return AppStrings.home;
      case DashBoardView.offerRide:
        return AppStrings.offerRide;
      case DashBoardView.requests:
        return AppStrings.requests;
    }
  }

  String get icon {
    switch (this) {
      case DashBoardView.home:
        return AppAssets.homeSvg;
      case DashBoardView.offerRide:
        return AppAssets.offerRideSvg;
      case DashBoardView.requests:
        return AppAssets.requestsSvg;
    }
  }
}
