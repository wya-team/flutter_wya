import 'dart:async';

import 'package:flutter/services.dart';

class Toast {
  static const MethodChannel _channel =
      const MethodChannel('toast');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
