import 'dart:async';

import 'package:flutter/services.dart';

class Cache {
  static const MethodChannel _channel =
      const MethodChannel('cache');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
