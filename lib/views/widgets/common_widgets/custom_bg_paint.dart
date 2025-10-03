// 🎨 Custom Painter for beautiful abstract blobs
import 'package:comfort_go/constants/app_colors.dart';
import 'package:flutter/material.dart';

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const baseColor = AppColors.primaryColor;

    final lightPaint = Paint()..color = baseColor.withOpacity(0.10);
    final mediumPaint = Paint()..color = baseColor.withOpacity(0.18);
    final darkPaint = Paint()..color = baseColor.withOpacity(0.26);

    // Draw lightest wave first (bottom)
    final lightPath = Path()
      ..moveTo(0, size.height * 0.2)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.1,
        size.width * 0.5,
        size.height * 0.15,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.22,
        size.width,
        size.height * 0.12,
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(lightPath, lightPaint);

    // // Medium wave
    final mediumPath = Path()
      ..moveTo(0, size.height * 0.24)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.12,
        size.width * 0.5,
        size.height * 0.2,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.3,
        size.width,
        size.height * 0.18,
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(mediumPath, mediumPaint);

    // Darkest wave (top)
    final darkPath = Path()
      ..moveTo(0, size.height * 0.30)
      ..quadraticBezierTo(
        size.width * 0.25,
        size.height * 0.14,
        size.width * 0.5,
        size.height * 0.30,
      )
      ..quadraticBezierTo(
        size.width * 0.75,
        size.height * 0.44,
        size.width,
        size.height * 0.26,
      )
      ..lineTo(size.width, 0)
      ..lineTo(0, 0)
      ..close();

    canvas.drawPath(darkPath, darkPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
