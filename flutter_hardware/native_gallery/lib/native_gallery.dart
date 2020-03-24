import 'dart:async';

import 'package:flutter/services.dart';

class NativeGallery {
  static const MethodChannel _channel =
      const MethodChannel('native_gallery');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
