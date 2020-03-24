import 'dart:async';

import 'package:flutter/services.dart';

class Date {
  static const MethodChannel _channel =
      const MethodChannel('date');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
