import 'dart:async';

import 'package:flutter/services.dart';

enum CameraType { all, image, video }

enum CameraOrientation { back, front }

enum VideoPreset { low, medium, high }

class NativeCamera {
  static const MethodChannel _channel = const MethodChannel('native_camera');

  /// 打开照相机
  /// cameraType：相机类型
  /// cameraOrientation：摄像头朝向
  /// time：拍摄时间长度
  /// videoPreset：拍摄质量
  /// saveAlbum：是否保存至相册
  /// albumName：相册名称
  ///
  /// 返回的数据应该是一个map
  /// 键：
  /// "imageBase64"：拍摄的图片数据
  /// "imagePath": 拍摄的图片本地路径
  /// "videoPath"：拍摄的视频的本地路径
  static Future<Map<String, dynamic>> openCamera(
      {CameraType cameraType = CameraType.all,
      CameraOrientation cameraOrientation = CameraOrientation.back,
      int time = 15,
      VideoPreset videoPreset = VideoPreset.medium,
      bool saveAlbum = false,
      String albumName}) async {
    var map = {"time": time, "saveAblum": saveAlbum, "albumName": albumName};

    /// 设置相机类型
    if (cameraType == CameraType.image) {
      map["cameraType"] = 1;
    } else if (cameraType == CameraType.video) {
      map["cameraType"] = 2;
    } else {
      map["cameraType"] = 0;
    }

    /// 设置摄像头方向
    if (cameraOrientation == CameraOrientation.front) {
      map["cameraOrientation"] = 1;
    } else {
      map["cameraOrientation"] = 0;
    }

    if (videoPreset == VideoPreset.low) {
      map["videoPreset"] = 0;
    } else if (videoPreset == VideoPreset.medium) {
      map["videoPreset"] = 1;
    } else {
      map["videoPreset"] = 2;
    }
    final Map<String, dynamic> version = await _channel.invokeMethod('openCamera', map);
    return version;
  }
}
