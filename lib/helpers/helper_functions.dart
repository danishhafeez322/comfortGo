import 'dart:developer';

import '../../utils/log_util.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helper {
  static Future<void> unFocusScope() async {
    try {
      var focus = FocusManager.instance.primaryFocus;
      if (focus != null && focus.hasFocus) {
        focus.unfocus();
      }
    } catch (e) {
      Log.e('unFocusScope:', '$e');
    }
  }

  static String checkHaveZ(String date) {
    if (!date.contains("Z")) {
      date = "${date}Z";
    }
    return date;
  }

  static Future<DateTime?> datePicker(BuildContext context) async {
    DateTime? pickedTime = await showDatePicker(
      context: context,
      firstDate: DateTime(1800),
      initialDate: DateTime.now(),
      lastDate: DateTime.now(),
    );
    return pickedTime;
  }

  static String formatTaskTime(DateTime? start, DateTime? end) {
    String startStr = start != null
        ? "${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}"
        : "--:--";
    String endStr = end != null
        ? "${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}"
        : "";
    return end != null ? "$startStr - $endStr" : startStr;
  }

  static String formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  /// Returns the difference between expiryDateTime (in UTC string)
  /// and the current local time.
  static Duration? getExpiryDifference(String? expiryDateTimeString) {
    if (expiryDateTimeString == null) return null;

    try {
      final formatter = DateFormat("dd/MM/yyyy HH:mm:ss");

      // Parse as UTC
      final expiryUtc = formatter.parseUtc(expiryDateTimeString);

      // Convert to local
      final expiryLocal = expiryUtc.toLocal();

      // Current local time
      final now = DateTime.now();

      return expiryLocal.difference(now);
    } catch (e) {
      log("Error parsing expiryDateTime: $e");
      return null;
    }
  }
}

class DateFormatTypes {
  static String formatDateWithOrdinal(DateTime date) {
    String weekday = DateFormat('EEEE').format(date); // e.g., Wednesday
    String month = DateFormat('MMMM').format(date); // e.g., January
    int day = date.day;

    String formatted =
        '$weekday $day${getDaySuffix(date.day)} $month ${date.year}';
    return formatted;
  }

  static String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
