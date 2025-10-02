import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import '../../../utils/device_type_utils.dart';
import '../../../views/widgets/common_widgets/common_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ErrorDialogBody extends StatelessWidget {
  final Function? ok;
  final String? message;
  const ErrorDialogBody({super.key, this.ok, this.message});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {},
      child: AlertDialog(
        surfaceTintColor: Colors.white,
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
        // contentPadding: EdgeInsets.zero,
        titlePadding: EdgeInsets.zero,
        actionsPadding: EdgeInsets.zero,
        content: Padding(
          padding: EdgeInsets.symmetric(vertical: isTablet(context) ? 20 : 15),
          child: Text(
            message ?? "",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          CommonWidgets.actionButton(
            ActionString.ok.toUpperCase(),
            () {
              Get.back(result: true);
              if (ok != null) {
                ok!.call();
              }
            },
            textColor: Colors.white,
            backColor: AppColors.primaryColor,
          ),
        ],
      ),
    );
  }
}
