import 'package:flutter/material.dart';
import 'package:get/get.dart';

bool isTablet(BuildContext context) {
  var shortestSide = MediaQuery.of(context).size.shortestSide;
  return shortestSide > 600;
}

bool isIpad(BuildContext context) {
  if (!Theme.of(context).platform.toString().contains('iOS')) return false;
  return isTablet(context) && MediaQuery.of(context).size.width > 768;
}

bool isIphone(BuildContext context) {
  if (!Theme.of(context).platform.toString().contains('iOS')) return false;
  return !isTablet(context);
}

bool isLandScape() {
  var context = Get.context;
  if (context == null) {
    return false;
  }
  return MediaQuery.orientationOf(context) == Orientation.landscape;
}
