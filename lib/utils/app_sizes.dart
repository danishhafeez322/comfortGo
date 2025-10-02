import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'device_type_utils.dart';

var context = Get.context;
final double appBorderRadius = 3.r;

enum DeviceState {
  tabletLandscape,
  tabletPortrait,
  phoneLandscape,
  phonePortrait,
}

DeviceState getDeviceState() {
  bool tablet = isTablet(context!);
  bool landscape = isLandScape();

  if (tablet && landscape) return DeviceState.tabletLandscape;
  if (tablet && !landscape) return DeviceState.tabletPortrait;
  if (!tablet && landscape) return DeviceState.phoneLandscape;
  return DeviceState.phonePortrait;
}

class FontSizes {
  static double extralargeFontSize() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 40.sp;
      case DeviceState.tabletPortrait:
        return 14.sp;
      case DeviceState.phoneLandscape:
        return 9.sp;
      case DeviceState.tabletLandscape:
        return 10.sp;
    }
  }

  static double largeFontSize() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 28.sp;
      case DeviceState.tabletPortrait:
        return 14.sp;
      case DeviceState.phoneLandscape:
        return 9.sp;
      case DeviceState.tabletLandscape:
        return 10.sp;
    }
  }

  static double largeFontSize1() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 20.sp;
      case DeviceState.tabletPortrait:
        return 12.sp;
      case DeviceState.phoneLandscape:
        return 8.sp;
      case DeviceState.tabletLandscape:
        return 8.sp;
    }
  }

  static double mediumFontSize() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 17.sp;
      case DeviceState.tabletPortrait:
        return 10.sp;
      case DeviceState.phoneLandscape:
        return 7.sp;
      case DeviceState.tabletLandscape:
        return 7.sp;
    }
  }

  static double mediumFontSize1() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 15.sp;
      case DeviceState.tabletPortrait:
        return 9.sp;
      case DeviceState.phoneLandscape:
        return 7.sp;
      case DeviceState.tabletLandscape:
        return 7.sp;
    }
  }

  static double smallFontSize() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 13.sp;
      case DeviceState.tabletPortrait:
        return 9.sp;
      case DeviceState.phoneLandscape:
        return 7.sp;
      case DeviceState.tabletLandscape:
        return 6.sp;
    }
  }
}

class AppCommonSizes {
  static double dashboardCardIndicatorHeight() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 10.h;
      case DeviceState.phoneLandscape:
        return 2.w;
      case DeviceState.tabletPortrait:
        return 10.h;
      case DeviceState.tabletLandscape:
        return 3.w;
    }
  }

  static double dashboardCardIndicatorWidth() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 24.w;
      case DeviceState.phoneLandscape:
        return 2.w;
      case DeviceState.tabletPortrait:
        return 10.h;
      case DeviceState.tabletLandscape:
        return 12.w;
    }
  }

  static double userTypeBoxWidth() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 0.26.sw;
      case DeviceState.phoneLandscape:
        return 92.w;
      case DeviceState.tabletPortrait:
        return 94.w;
      case DeviceState.tabletLandscape:
        return 84.w;
    }
  }

  static double userTypeBoxHeight() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 70.h;
      case DeviceState.phoneLandscape:
        return 140.h;
      case DeviceState.tabletPortrait:
        return 80.h;
      case DeviceState.tabletLandscape:
        return 100.h;
    }
  }

  static double painterOffsetYAxis() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return -1.sw * 0.18;
      case DeviceState.phoneLandscape:
        return -198.w;
      case DeviceState.tabletPortrait:
        return -1.sw / 3.4;
      case DeviceState.tabletLandscape:
        return -1.sw / 2.3;
    }
  }

  static double bottomPainterOffsetYAxis() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 1.sh * 0.34;
      case DeviceState.phoneLandscape:
        return 250.w;
      case DeviceState.tabletPortrait:
        return 1.sw / 3.4;
      case DeviceState.tabletLandscape:
        return 1.sw / 1.6;
    }
  }

  static double upperTopSplashPainterOffsetYAxis() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return -1.sw / 3;
      case DeviceState.phoneLandscape:
        return -1.sw / 2.4;
      case DeviceState.tabletPortrait:
        return -1.sw / 2.3;
      case DeviceState.tabletLandscape:
        return -1.sw / 2.3;
    }
  }

  static double upperBottomSplashPainterOffsetYAxis() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return -1.sw / 3.2;
      case DeviceState.phoneLandscape:
        return -1.sw / 2.5;
      case DeviceState.tabletPortrait:
        return -1.sw / 2.38;
      case DeviceState.tabletLandscape:
        return -1.sw / 2.38;
    }
  }

  static double lowerTopSplashPainterOffsetYAxis() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 246.h;
      case DeviceState.phoneLandscape:
        return 860.h;
      case DeviceState.tabletPortrait:
        return 336.h;
      case DeviceState.tabletLandscape:
        return 700.h;
    }
  }

  static double lowerBottomSplashPainterOffsetYAxis() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 240.h;
      case DeviceState.phoneLandscape:
        return 830.h;
      case DeviceState.tabletPortrait:
        return 328.h;
      case DeviceState.tabletLandscape:
        return 680.h;
    }
  }

  static double cupertinoLoaderRadius() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 25.w;
      case DeviceState.phoneLandscape:
        return 15.w;
      case DeviceState.tabletPortrait:
        return 25.w;
      case DeviceState.tabletLandscape:
        return 15.w;
    }
  }

  static double commonButtonHeight() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
      case DeviceState.phoneLandscape:
      case DeviceState.tabletPortrait:
      case DeviceState.tabletLandscape:
        return 50.w;
    }
  }

  static double commonButtonWidth() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
      case DeviceState.phoneLandscape:
      case DeviceState.tabletPortrait:
      case DeviceState.tabletLandscape:
        return 300.w;
    }
  }

  static EdgeInsets commonButtonPadding() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.w);
      case DeviceState.phoneLandscape:
        return EdgeInsets.symmetric(horizontal: 20.w, vertical: 3.5.w);
      case DeviceState.tabletPortrait:
        return EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.w);
      case DeviceState.tabletLandscape:
        return EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.w);
    }
  }

  static EdgeInsets commonButtonActionsPadding() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return EdgeInsets.symmetric(horizontal: 10.w);
      case DeviceState.phoneLandscape:
        return EdgeInsets.symmetric(horizontal: 5.w);
      case DeviceState.tabletPortrait:
        return EdgeInsets.symmetric(horizontal: 10.w);
      case DeviceState.tabletLandscape:
        return EdgeInsets.symmetric(horizontal: 5.w);
    }
  }

  static double commonButtonFontSize() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 18.sp;
      case DeviceState.tabletPortrait:
        return 16.sp;
      case DeviceState.phoneLandscape:
        return 10.sp;
      case DeviceState.tabletLandscape:
        return 10.sp;
    }
  }

  static EdgeInsets appBarLeadingPadding() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return EdgeInsets.only(left: 5.w);
      case DeviceState.phoneLandscape:
        return EdgeInsets.only(left: 3.w);
      case DeviceState.tabletPortrait:
        return EdgeInsets.only(left: 5.w);
      case DeviceState.tabletLandscape:
        return EdgeInsets.only(left: 3.w);
    }
  }

  static double fieldFontSize() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
      case DeviceState.tabletPortrait:
        return 17.sp;
      case DeviceState.phoneLandscape:
      case DeviceState.tabletLandscape:
        return 10.sp;
    }
  }

  static double requiredTextFontSize() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 17.sp;
      case DeviceState.tabletPortrait:
        return 17.sp;
      case DeviceState.phoneLandscape:
        return 10.sp;
      case DeviceState.tabletLandscape:
        return 10.sp;
    }
  }
}

class AppWidgetSizes {
  static double largeIconSize() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 44.w;
      case DeviceState.phoneLandscape:
        return 20.w;
      case DeviceState.tabletPortrait:
        return 26.w;
      case DeviceState.tabletLandscape:
        return 17.w;
    }
  }

  static double mediumIconSize() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 26.w;
      case DeviceState.phoneLandscape:
        return 13.w;
      case DeviceState.tabletPortrait:
        return 18.w;
      case DeviceState.tabletLandscape:
        return 12.w;
    }
  }

  static double smallIconSize() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 16.w;
      case DeviceState.phoneLandscape:
        return 8.w;
      case DeviceState.tabletPortrait:
        return 14.w;
      case DeviceState.tabletLandscape:
        return 8.w;
    }
  }

  static double dashboardCardWidth(BuildContext context) {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 0.9.sw;
      case DeviceState.phoneLandscape:
        return 0.42.sw;
      case DeviceState.tabletPortrait:
        return 0.4.sw;
      case DeviceState.tabletLandscape:
        return 0.42.sw;
    }
  }

  static double dashboardCardHeight(BuildContext context) {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 0.172.sh;
      case DeviceState.phoneLandscape:
        return 0.24.sw;
      case DeviceState.tabletPortrait:
        return 0.2.sw;
      case DeviceState.tabletLandscape:
        return 0.24.sh;
    }
  }
}

class LoginSizes {
  static double commonButtonFontSize() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 25.sp;
      case DeviceState.tabletPortrait:
        return 20.sp;
      case DeviceState.phoneLandscape:
      case DeviceState.tabletLandscape:
        return 12.sp;
    }
  }

  static double loginScreenPadding(BuildContext context) {
    DeviceState state = getDeviceState();
    switch (state) {
      case DeviceState.phonePortrait:
        return 20.w;
      case DeviceState.phoneLandscape:
        return 60.w;
      case DeviceState.tabletLandscape:
        return 60.w;
      case DeviceState.tabletPortrait:
        return 60.w;
    }
  }

  static double resetPasswordFontSize(BuildContext context) {
    DeviceState state = getDeviceState();
    switch (state) {
      case DeviceState.phoneLandscape:
        return 12.sp;
      case DeviceState.tabletLandscape:
        return 10.sp;
      case DeviceState.tabletPortrait:
        return 12.sp;
      case DeviceState.phonePortrait:
        return 20.sp;
    }
  }

  static double tenantNameFontSize(BuildContext context) {
    DeviceState state = getDeviceState();
    switch (state) {
      case DeviceState.phoneLandscape:
        return 15.sp;
      case DeviceState.tabletLandscape:
        return 15.sp;
      case DeviceState.tabletPortrait:
        return 20.sp;
      case DeviceState.phonePortrait:
        return 25.sp;
    }
  }

  static EdgeInsets textFieldAndButtonPadding() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phoneLandscape:
        return EdgeInsets.symmetric(horizontal: 50.w, vertical: 7.w);
      case DeviceState.tabletPortrait:
      case DeviceState.tabletLandscape:
        return EdgeInsets.symmetric(horizontal: 30.w, vertical: 6.w);
      case DeviceState.phonePortrait:
        return EdgeInsets.symmetric(horizontal: 30.w, vertical: 14.w);
    }
  }

  static EdgeInsets formTextPadding() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phoneLandscape:
        return EdgeInsets.symmetric(horizontal: 50.w, vertical: 6.w);
      case DeviceState.tabletPortrait:
      case DeviceState.tabletLandscape:
      case DeviceState.phonePortrait:
        return EdgeInsets.symmetric(horizontal: 30.w, vertical: 12.w);
    }
  }

  static double spaceAbove() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 60.w;
      case DeviceState.phoneLandscape:
        return 20.w;
      case DeviceState.tabletPortrait:
        return 10.w;
      case DeviceState.tabletLandscape:
        return 30.w;
    }
  }

  static EdgeInsets logoPadding() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
      case DeviceState.phoneLandscape:
        return EdgeInsets.symmetric(horizontal: 14.w, vertical: 30.w);
      case DeviceState.tabletPortrait:
        return EdgeInsets.symmetric(horizontal: 33.w, vertical: 20.w);
      case DeviceState.tabletLandscape:
        return EdgeInsets.symmetric(horizontal: 14.w, vertical: 20.w);
    }
  }

  static double logoSizeWidth(BuildContext context) {
    DeviceState state = getDeviceState();
    switch (state) {
      case DeviceState.phonePortrait:
        return 220.w;
      case DeviceState.phoneLandscape:
        return 120.w;
      case DeviceState.tabletLandscape:
        return 120.w;
      case DeviceState.tabletPortrait:
        return 150.w;
    }
  }

  static double logoSizeHeight(BuildContext context) {
    DeviceState state = getDeviceState();
    switch (state) {
      case DeviceState.phonePortrait:
        return 140.w;
      case DeviceState.phoneLandscape:
        return 60.w;
      case DeviceState.tabletLandscape:
        return 60.w;
      case DeviceState.tabletPortrait:
        return 90.w;
    }
  }

  static double noSloganlogoHeight() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 38.h;
      case DeviceState.tabletPortrait:
        return 34.h;
      case DeviceState.tabletLandscape:
        return 44.h;
      case DeviceState.phoneLandscape:
        return 62.h;
    }
  }

  static double logoWidth() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 0.58.sw;
      case DeviceState.tabletPortrait:
        return 0.58.sw;
      case DeviceState.tabletLandscape:
        return 0.43.sw;
      case DeviceState.phoneLandscape:
        return 0.47.sw;
    }
  }

  static double noSloganlogoWidth() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 0.28.sw;
      case DeviceState.tabletPortrait:
        return 0.24.sw;
      case DeviceState.tabletLandscape:
        return 0.17.sw;
      case DeviceState.phoneLandscape:
        return 0.12.sw;
    }
  }

  static double emailIsRegisteredFontSize(BuildContext context) {
    DeviceState state = getDeviceState();
    switch (state) {
      case DeviceState.phoneLandscape:
        return 8.sp;
      case DeviceState.tabletLandscape:
        return 6.sp;
      case DeviceState.tabletPortrait:
        return 8.sp;
      case DeviceState.phonePortrait:
        return 13.sp;
    }
  }
}

class ProfileSizes {
  static double biometricButtonHeight() {
    DeviceState state = getDeviceState();
    switch (state) {
      case DeviceState.phoneLandscape:
        return 0.05.sh;
      case DeviceState.tabletLandscape:
        return 0.1.sh;
      case DeviceState.tabletPortrait:
        return 50.w;
      case DeviceState.phonePortrait:
        return 62.w;
    }
  }

  static double pleaseEnterOtpFontSize() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phoneLandscape:
      case DeviceState.tabletLandscape:
        return 8.sp;
      case DeviceState.tabletPortrait:
        return 10.sp;
      case DeviceState.phonePortrait:
        return 16.sp;
    }
  }

  static double otpFieldHeight() {
    DeviceState state = getDeviceState();
    switch (state) {
      case DeviceState.phoneLandscape:
        return 30.w;
      case DeviceState.tabletLandscape:
        return 30.w;
      case DeviceState.tabletPortrait:
        return 50.w;
      case DeviceState.phonePortrait:
        return 62.w;
    }
  }

  static double otpFieldWidth() {
    DeviceState state = getDeviceState();
    switch (state) {
      case DeviceState.phoneLandscape:
        return 20.w;
      case DeviceState.tabletLandscape:
        return 20.w;
      case DeviceState.tabletPortrait:
        return 30.w;
      case DeviceState.phonePortrait:
        return 50.w;
    }
  }

  static double otpFontSize() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phoneLandscape:
        return 22.sp;
      case DeviceState.tabletLandscape:
        return 22.sp;
      case DeviceState.tabletPortrait:
        return 38.sp;
      case DeviceState.phonePortrait:
        return 48.sp;
    }
  }
}

class CustomDialogSizes {
  static double actionHeight() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 45.w;
      case DeviceState.phoneLandscape:
        return 20.w;
      case DeviceState.tabletPortrait:
        return 25.w;
      case DeviceState.tabletLandscape:
        return 23.w;
    }
  }

  static double fontSize() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phoneLandscape:
      case DeviceState.tabletLandscape:
        return 8.sp;
      case DeviceState.tabletPortrait:
        return 10.sp;
      case DeviceState.phonePortrait:
        return 16.sp;
    }
  }

  static EdgeInsets bodyPadding() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phoneLandscape:
      case DeviceState.tabletLandscape:
        return EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.w);
      case DeviceState.tabletPortrait:
      case DeviceState.phonePortrait:
        return EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.w);
    }
  }
}

class LogoSizes {
  static double logoFontSize(BuildContext context) {
    DeviceState state = getDeviceState();
    switch (state) {
      case DeviceState.phonePortrait:
        return 43.sp;
      case DeviceState.tabletPortrait:
        return 32.sp;
      case DeviceState.phoneLandscape:
        return 20.sp;
      case DeviceState.tabletLandscape:
        return 20.sp;
    }
  }
}

class BottomSheetSizes {
  static double onInitSheetHeight() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phoneLandscape:
        return 130.w;
      case DeviceState.tabletPortrait:
        return 230.w;
      case DeviceState.tabletLandscape:
        return 120.w;
      case DeviceState.phonePortrait:
        return 400.w;
    }
  }

  static double onLoginSheetHeight() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 400.w;
      case DeviceState.phoneLandscape:
        return 160.w;
      case DeviceState.tabletPortrait:
        return 230.w;
      case DeviceState.tabletLandscape:
        return 180.w;
    }
  }

  static double? agreeColumnWidth() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phoneLandscape:
      // return 160.w;
      case DeviceState.phonePortrait:
      case DeviceState.tabletPortrait:
      case DeviceState.tabletLandscape:
        return null;
    }
  }

  static WrapAlignment runAlignment() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return WrapAlignment.spaceEvenly;
      case DeviceState.phoneLandscape:
        return WrapAlignment.spaceEvenly;
      case DeviceState.tabletPortrait:
        return WrapAlignment.spaceEvenly;
      case DeviceState.tabletLandscape:
        return WrapAlignment.spaceEvenly;
    }
  }

  static double paragraphFontSize() {
    DeviceState state = getDeviceState();

    switch (state) {
      case DeviceState.phonePortrait:
        return 13.sp;
      case DeviceState.phoneLandscape:
        return (6.5).sp;
      case DeviceState.tabletPortrait:
        return 8.sp;
      case DeviceState.tabletLandscape:
        return 6.sp;
    }
  }
}
