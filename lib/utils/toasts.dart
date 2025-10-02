import '../../constants/app_colors.dart';
import '../../constants/app_strings.dart';
import '../../constants/error_codes.dart';
import '../../utils/app_sizes.dart';
import '../../views/widgets/common_widgets/common_widget.dart';
import '../../views/widgets/dialogs/confirmation_dialog.dart';
import '../../views/widgets/dialogs/error_dialoge.dart';
import '../../views/widgets/dialogs/progress_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'device_type_utils.dart';

class ToastAndDialog {
  static void showCustomSnackBar(
    String message, {
    String? title,
    Color? backgroundColor,
    double borderRadius = 10,
    int duration = 3,
    Widget? titleWidget,
    // SnackPosition position = SnackPosition.TOP,
    ToastGravity? gravity,
    Color textColor = Colors.black,
  }) {
    Fluttertoast.showToast(
      msg: message,
      fontSize: isTablet(context!)
          ? isLandScape()
                ? 6.sp
                : 10.sp
          : isLandScape()
          ? 6.sp
          : 16.sp,
      textColor: Colors.white,
      gravity: gravity ?? ToastGravity.TOP,
      backgroundColor: backgroundColor ?? AppColors.secondaryColor,
    );
  }

  static progressIndicator({String? text}) {
    Get.dialog(
      ProgressDialog(text: text ?? AppStrings.wait),
      barrierDismissible: false,
    );
  }

  static Future<bool> confirmation({
    String? title,
    String? message,
    okText = ActionString.yes,
    cancelText = ActionString.no,
  }) async {
    return await Get.dialog(
      ConfirmationDialog(
        title: title,
        message: message,
        okText: okText,
        cancelText: cancelText,
      ),
      barrierDismissible: false,
    );
  }

  static Future showDialogueForProcessing(
    BuildContext context, {
    String? text,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) {},
          child: Material(
            color: Colors.transparent,
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: AppColors.bgColor,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  width: 120,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CommonWidgets.circularProgressIndicator(
                          color: AppColors.whiteColor,
                        ),
                        SizedBox(height: 5),
                        Text(
                          text ?? "Please wait...",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  static Future<bool?> bottomSheet({
    Widget? body,
    bool isScrollControlled = true,
    Color? bgColor,
    double? topRadius,
    bool isDismissible = false,
  }) async {
    return await Get.bottomSheet<bool?>(
      body!,
      backgroundColor: bgColor ?? AppColors.lightBackgroundColor,
      isScrollControlled: isScrollControlled,
      isDismissible: isDismissible,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(topRadius ?? appBorderRadius.r),
        ),
      ),
    );
  }

  static Future<bool?> errorDialog(
    dynamic error, {
    Function? ok,
    String messageError = ToastMessages.unknownError,
    String title = "",
    bool isPullToRefresh = false,
    bool authError = false,
  }) async {
    String message = messageError;
    if (error != null) {
      if (error is String) {
        message = error;
      } else if (error.message != null) {
        message = error.message;
      }
    }

    if (message == ErrorCode.connectionAbort ||
        message.contains(ErrorCode.failedHost)) {
      message = ToastMessages.unableToConnect;
    }

    if (message.contains(ErrorCode.invalidHtml)) {
      message = ErrorMessages.internalServerError;
    }

    if (message == ErrorMessages.internetNotAvailable) {
      return false;
    }
    return await Get.dialog(
      ErrorDialogBody(ok: ok, message: message),
      barrierDismissible: false,
    );
  }

  static Future<T?> cupertinoBottomSheet<T>({
    required String sheetHeading,
    required List<Widget> actions,
    double? titleFontsize,
  }) async {
    T? result = await Get.bottomSheet<T>(
      CupertinoActionSheet(
        title: sheetHeading.isNotEmpty
            ? Text(
                sheetHeading,
                // style: AppTextStyle.inter(
                //   fontSize:
                //       titleFontsize ?? (isTablet(context!) ? 12.sp : 18.sp),
                //   fontWeight: FontWeight.w600,
                //   color: AppColors.greyColor,
                // ),
              )
            : null,
        actions: actions,
        cancelButton: CupertinoActionSheetAction(
          onPressed: () {
            Get.back();
          },
          isDefaultAction: true,
          child: Text(
            ActionString.cancel,
            // style: AppTextStyle.inter(
            //   fontSize: titleFontsize ?? (isTablet(context!) ? 10.sp : 17.sp),
            //   fontWeight: FontWeight.w600,
            //   color: AppColors.blueColor,
            // ),
          ),
        ),
      ),
    );
    return result;
  }
}
