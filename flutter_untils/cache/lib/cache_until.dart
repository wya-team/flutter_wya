import 'dart:async';

import 'package:flutter/services.dart';

typedef PermissionStatusCallback = void Function();

class Cache {

  static const MethodChannel _channel = const MethodChannel('cache');

  /// 获取系统某个路径下的内存大小
  static Future<String> systemCache({String path}) async {
    final String systemCache = await _channel.invokeMethod(
      'getSystemCache',
      [path],
    );
    return systemCache;
  }

  /// 清除某个路径下的缓存
  static Future<bool> clearCache({String path}) async {
    final bool cacheCache = await _channel.invokeMethod(
        'clearCache',
        [path]
    );
    return cacheCache;
  }

  /// 获取剩余可用空间
  static Future<String> get availableSpace async {
    final String availableSpace = await _channel.invokeMethod(
      'availableSpace',
    );
    return availableSpace;
  }

  /// 获取设备所有储存空间
  static Future<String> get deviceCacheSpace async {
    final String deviceCacheSpace = await _channel.invokeMethod(
      'deviceCacheSpace',
    );
    return deviceCacheSpace;
  }

  /// --------------------------------------------  android  -------------------------------------------
  /// 获取SD卡某个路径下的内存大小
  static Future<String> sDFreeSize(String path) async {
    final String systemCache = await _channel.invokeMethod(
      'getSDFreeSize',
      [path],
    );
    return systemCache;
  }
}
