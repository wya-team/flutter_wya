import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/services.dart';

typedef PermissionStatusCallback = void Function();

class Cache {
  static const MethodChannel _channel = const MethodChannel('cache');

  /// 获取系统某个路径下的内存大小
  /// path: 本地路径
  static Future<String> systemCache({String path}) async {
    final String systemCache = await _channel.invokeMethod(
      'getSystemCache',
      [path],
    );
    return systemCache;
  }

  /// 清除某个路径下的缓存
  /// path: 本地路径
  static Future<bool> clearCache({String path}) async {
    final bool cacheCache = await _channel.invokeMethod('clearCache', [path]);
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

  /// 保存图片到相册或本地路径
  /// data：数据流
  /// path：路径
  /// saveProjectNameAlbum：是否保存在自定义相册。如果customAlbum没有值时，会自动创建以项目名称为相册名
  /// customAlbum：自定义相册名字
  ///
  /// 返回值是Map,包含isSuccess，result，imagePath
  /// isSuccess:表示是否成功，bool值
  /// result：成功或者失败信息，String
  /// imagePath: 保存在相册时的路径，String
  static Future<dynamic> saveImage(Uint8List data,
      {String path, bool saveProjectNameAlbum, String customAlbum}) async {
    dynamic saveImage = await _channel.invokeMethod(
      'saveImage',
      {
        'path': path,
        'data': data,
        'saveProjectNameAlbum': saveProjectNameAlbum,
        'customAlbum': customAlbum,
      },
    );
    return saveImage;
  }

  /// 保存视频到相册
  /// path：路径
  /// saveProjectNameAlbum：是否保存在自定义相册。如果customAlbum没有值时，会自动创建以项目名称为相册名
  /// customAlbum：自定义相册名字
  /// 返回值是Map,包含isSuccess，result，videoPath
  /// isSuccess:表示是否成功，bool值
  /// result：成功或者失败信息，String
  /// videoPath: 保存在相册时的路径，String
  static Future<dynamic> saveVideo(String videoPath,
      {bool saveProjectNameAlbum, String customAlbum}) async {
    dynamic saveVideo = await _channel.invokeMethod(
      'saveVideo',
      {
        'path': videoPath,
        'saveProjectNameAlbum': saveProjectNameAlbum,
        'customAlbum': customAlbum,
      },
    );
    return saveVideo;
  }
}
