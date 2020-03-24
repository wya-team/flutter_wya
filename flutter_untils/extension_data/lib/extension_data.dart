import 'dart:async';

import 'package:flutter/services.dart';

class ExtensionData {
  static const MethodChannel _channel =
      const MethodChannel('extension_data');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
