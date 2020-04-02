import 'dart:async';

import 'package:flutter/services.dart';

class NativeRecord {
  static const MethodChannel _channel = const MethodChannel('native_record');

  /// 播放录音
  /// path : 录音路径
  /// volume : 声音大小，0.0-1.0
  /// speed : 播放速度，0.0-1.0
  /// numberOfLoops : 播放次数
  /// currentTime：播放的时间点开始，不能超过音频文件总长度
  static Future<bool> recordPlay(String path,
      {double volume, double speed, int numberOfLoops, int currentTime}) async {
    return await _channel.invokeMethod(
      'recordPlay',
      [path, volume, speed, numberOfLoops, currentTime],
    );
  }

  /// 暂停播放
  static Future recordPause() async {
    await _channel.invokeMethod(
      'recordPause',
    );
  }

  /// 恢复播放
  static Future recordResume() async {
    await _channel.invokeMethod(
      'recordResume',
    );
  }

  /// 停止播放
  static Future recordStop() async {
    await _channel.invokeMethod(
      'recordStop',
    );
  }
}
