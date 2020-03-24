import 'dart:async';

import 'package:flutter/services.dart';

class NativeVideoPlayer {
  static const MethodChannel _channel =
      const MethodChannel('native_video_player');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
