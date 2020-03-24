import 'dart:async';

import 'package:flutter/services.dart';

class NativePermissions {
  static const MethodChannel _channel =
      const MethodChannel('native_permissions');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
