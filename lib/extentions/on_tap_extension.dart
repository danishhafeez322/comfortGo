import '../../constants/app_strings.dart';
import '../../controllers/common_controllers/connectivity_controller.dart';
import '../../helpers/helper_functions.dart';
import '../../utils/toasts.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension WidgetExtensions on Widget {
  Widget onTapWidget({
    required void Function() onTap,
    bool wantToCheckInternet = false,
    bool isDisabled = false,
  }) {
    return GestureDetector(
      onTap: () async {
        if (isDisabled) return;
        if (wantToCheckInternet) {
          final connection = Get.find<ConnectionManagerController>();

          if (!connection.isConnected.value) {
            ToastAndDialog.showCustomSnackBar(
              ToastMessages.checkInternetConnection,
            );
            return;
          }
        }
        Helper.unFocusScope();
        onTap.call();
      },
      child: this,
    );
  }

  Widget withTooltip({String? message}) {
    return Tooltip(message: message, child: this);
  }
}

/// onTap Extension For TextSpan Inline

extension TapTextSpanExtension on TapGestureRecognizer {
  TapGestureRecognizer onTapTextSpan({
    required void Function() onTap,
    bool wantToCheckInternet = true,
  }) {
    return TapGestureRecognizer()
      ..onTap = () {
        if (wantToCheckInternet) {
          final connection = Get.find<ConnectionManagerController>();

          if (!connection.isConnected.value) {
            ToastAndDialog.showCustomSnackBar(
              ToastMessages.checkInternetConnection,
            );
            return;
          }
        }
        onTap.call();
      };
  }
}
