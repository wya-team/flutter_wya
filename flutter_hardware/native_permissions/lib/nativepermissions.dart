import 'dart:async';

import 'package:flutter/services.dart';

class Nativepermissions {
  static const MethodChannel _channel =
      const MethodChannel('nativepermissions');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
