import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:comfort_go/extentions/on_tap_extension.dart';
import '../../../constants/app_colors.dart';
import '../../../constants/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AssetView extends StatelessWidget {
  const AssetView({
    super.key,
    required this.imagePath,
    this.height,
    this.isForAsset = false,
    this.width,
    this.color,
    this.scale,
    this.fit,
    this.showVideoThumbNail = true,
  });

  final String imagePath;
  final double? height;
  final double? width;
  final Color? color;
  final double? scale;
  final BoxFit? fit;
  final bool showVideoThumbNail;
  final bool isForAsset;

  @override
  Widget build(BuildContext context) {
    return _getView();
  }

  Widget _getView() {
    String mimType = imagePath.isURL
        ? ""
        : imagePath.split(".").last.toLowerCase();
    String path = imagePath;
    RxInt retryKey = 0.obs;

    if (mimType.isEmpty) {
      if (path.startsWith('http')) {
        if (imageFormats.any(
          (format) => path.toLowerCase().contains(format.toLowerCase()),
        )) {
          return Obx(
            () => CachedNetworkImage(
              key: ValueKey(retryKey.value),
              imageUrl: path,
              height: height,
              width: width,
              color: color,
              fit: fit ?? BoxFit.cover,
              placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
              errorListener: (obj) {},
              errorWidget: (context, url, error) {
                return Container(
                  height: 105.w,
                  width: 100.w,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.r),
                    child: const Icon(Icons.refresh),
                  ),
                ).onTapWidget(
                  onTap: () async {
                    retryKey.value++;
                  },
                );
                // return const Icon(Icons.error);
              },
            ),
          );
        }
      }
    }

    switch (mimType) {
      case "svg":
        return SvgPicture.asset(
          path,
          height: height,
          width: width,
          // color: color,
          colorFilter: color != null
              ? ColorFilter.mode(color!, BlendMode.srcIn)
              : null,
          fit: fit ?? BoxFit.fill,
        );
      case "png":
      case "jpg":
      case "jpeg":
        return isForAsset
            ? Image.asset(
                path,
                height: height,
                width: width,
                color: color,
                scale: scale ?? 1.0,
                fit: fit ?? BoxFit.cover,
              )
            : Image.file(
                File(path),
                height: height,
                width: width,
                color: color,
                scale: scale ?? 1.0,
                fit: fit ?? BoxFit.cover,
              );
      case "mp4":
      case "mov":
      case "avi":
      default:
        return Icon(
          Icons.error_outline,
          color: color ?? AppColors.redColor,
          size: width,
        );
    }
  }
}
