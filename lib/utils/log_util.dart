import 'package:flutter/foundation.dart';

class Log {
  static void v(String tag, String? log) {
    if (kDebugMode) {
      print('${DateTime.now()} 📓 $tag: $log');
    }
  }

  static void d(String tag, String? log) {
    if (kDebugMode) {
      print('${DateTime.now()} 🍒 $tag: $log');
    }
  }

  static void e(String tag, String? log) {
    if (kDebugMode) {
      print('${DateTime.now()} 📕 $tag: $log');
    }
  }

  static void w(String tag, String? log) {
    if (kDebugMode) {
      print('${DateTime.now()} 📙 $tag: $log');
    }
  }

  static void i(String tag, String? log) {
    if (kDebugMode) {
      print('${DateTime.now()} 📗 $tag: $log');
    }
  }
}
