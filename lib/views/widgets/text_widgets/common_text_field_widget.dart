import 'package:comfort_go/constants/app_constants.dart';

import '../../../constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class CommonTextFieldWidget extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final String? label;
  final Function(String?)? onChanged;
  final TextInputType? inputType;
  final TextInputAction? inputAction;
  final Color? fontColor;
  final Color? hintColor;
  final TextAlign? textAlign;
  final bool isFilled;
  final bool isDisabled;
  final double? fontSize;
  final FontWeight? textFontWeight;
  final FontWeight? hintFontWeight;
  final Function? onTap;
  final int? maxLength;
  final int? maxLines;
  final Color? borderColor; // Add custom border color
  final bool? readOnly;
  final bool border;
  final Widget? suffix;
  final String? Function(String?)? validator; // Add this line

  CommonTextFieldWidget({
    super.key,
    this.controller,
    this.hintText,
    this.label,
    this.onChanged,
    this.inputType,
    this.inputAction,
    this.readOnly,
    this.border = false,
    this.suffix,
    this.fontColor,
    this.hintColor,
    this.textAlign,
    this.isFilled = false,
    this.isDisabled = true,
    this.fontSize,
    this.textFontWeight,
    this.hintFontWeight,
    this.onTap,
    this.maxLength,
    this.maxLines,
    this.borderColor,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return TextFormField(
        maxLength: maxLength,
        validator: validator,
        maxLines: maxLines ?? 1,
        onTap: () => onTap?.call(),
        controller: controller,
        style: TextStyle(
          color: fontColor ?? Colors.black,
          fontSize: fontSize,
          fontWeight: textFontWeight,
        ),
        enabled: isDisabled,
        textInputAction: inputAction,
        readOnly: readOnly ?? false,

        keyboardType: inputType,
        textAlign: textAlign ?? TextAlign.start,
        onChanged: onChanged,
        decoration: InputDecoration(
          // Replace with full InputDecoration
          hintText: hintText,
          suffixIcon: suffix,

          filled: isFilled,
          fillColor: isFilled ? (Colors.grey[100]) : null,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5.w),
            borderSide: border
                ? BorderSide(
                    color:
                        borderColor ??
                        AppColors.textFieldBorderColor, // Use custom or default
                    width: 1.w,
                  )
                : BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            // Border when enabled
            borderRadius: BorderRadius.circular(5.w),
            borderSide: BorderSide(
              color: borderColor ?? AppColors.textFieldBorderColor,
              width: 1.w,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            // Border when focused
            borderRadius: BorderRadius.circular(5.w),
            borderSide: BorderSide(
              color:
                  borderColor ??
                  AppColors.textFieldBorderColor, // Highlight when focused
              width: 1.5.w,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            // Border when focused
            borderRadius: BorderRadius.circular(5.w),
            borderSide: BorderSide(
              color:
                  borderColor ??
                  AppColors.textFieldBorderColor, // Highlight when focused
              width: 1.5.w,
            ),
          ),
          errorBorder: OutlineInputBorder(
            // Border when error
            borderRadius: BorderRadius.circular(5.w),
            borderSide: BorderSide(color: Colors.red, width: 1.w),
          ),
          disabledBorder: OutlineInputBorder(
            // Border when disabled
            borderRadius: BorderRadius.circular(5.w),
            borderSide: BorderSide(color: Colors.grey[600]!, width: 1.w),
          ),
          hintStyle: AppConstants.fieldStyle.copyWith(
            color: hintColor ?? AppColors.textColor.withOpacity(0.3),
            fontSize: fontSize,
            fontWeight: hintFontWeight,
          ),
        ),
      );
    });
  }
}
