import 'package:comfort_go/utils/spacer.dart';
import 'package:comfort_go/views/widgets/assets_views_widgets/asset_view_widget.dart';

import '../../../../constants/app_colors.dart';
import '../../../../utils/app_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BottomNavItem extends StatelessWidget {
  final int index;
  final String label;
  final String customIconString;
  final Icon? icon;
  final bool isSelected;
  final VoidCallback onTap;

  const BottomNavItem({
    super.key,
    required this.index,
    required this.label,
    this.icon,
    required this.customIconString,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor : AppColors.navbuttonColor,
          borderRadius: BorderRadius.circular(2.r),
          border: Border.all(color: AppColors.textFieldBorderColor),
        ),
        child: Row(
          children: [
            FittedBox(
              child: Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? AppColors.whiteColor
                      : AppColors.darkBlueColor,
                  fontSize: FontSizes.mediumFontSize1(),
                ),
              ),
            ),
            hSpace(6),
            AssetView(
              imagePath: customIconString,
              isForAsset: true,
              width: 20,
              color: isSelected
                  ? AppColors.whiteColor
                  : AppColors.darkBlueColor,
            ),
          ],
        ),
      ),
    );
  }
}
