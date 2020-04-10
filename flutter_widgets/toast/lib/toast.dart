import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ToastGravity { TOP, BOTTOM, CENTER }

enum Orientations { Vertical, Horizontal }

class CustomToast {
  static const MethodChannel _channel = const MethodChannel('toast');

  /// toast 提示框隐藏
  /// ios不支持
  static Future<bool> cancelToast() async {
    bool res = await _channel.invokeMethod("cancelToast");
    return res;
  }

  /// loading 提示框隐藏
  static Future<bool> cancelLoading() async {
    bool res = await _channel.invokeMethod("cancelLoading");
    return res;
  }

  /// toast 展示
  /// msg 必传
  /// time toast的展示时间  android：0 段时间， -1 长时间，默认段时间； ios展示时间
  /// fontSize 文字大小
  /// gravity 显示位置， 中上下， ios端不支持上
  /// backgroundColor 背景颜色
  /// textColor 文字颜色
  /// iosTouchBgDismiss : ios端点击背景toast是否消失，不需要调用cancelToast()
  static Future<bool> showToast(
    String msg, {
    int time = 2,
    double fontSize = 16.0,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color backgroundColor,
    Color textColor,
    bool iosTouchBgDismiss = false,
  }) async {
    String gravityToast;
    if (gravity == ToastGravity.TOP) {
      gravityToast = "top";
    } else if (gravity == ToastGravity.CENTER) {
      gravityToast = "center";
    } else {
      gravityToast = "bottom";
    }

    Map<String, dynamic> params = <String, dynamic>{
      'msg': msg,
      'time': time,
      'gravity': gravityToast,
      'textcolor': textColor != null
          ? textColor.value
          : Color.fromRGBO(255, 255, 255, 1).value,
      'fontSize': fontSize,
      'iosTouchBgDismiss': iosTouchBgDismiss
    };

    if (defaultTargetPlatform == TargetPlatform.android) {
      params["bgcolor"] = backgroundColor != null
          ? backgroundColor.value
          : Color.fromRGBO(48, 48, 48, 1).value;
      params["textcolor"] = backgroundColor != null
          ? backgroundColor.value
          : Color.fromRGBO(255, 255, 255, 1).value;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      params["bgcolor"] = backgroundColor != null
          ? [
              backgroundColor.red,
              backgroundColor.green,
              backgroundColor.blue,
              backgroundColor.alpha
            ]
          : [48, 48, 48, 1];
      params["textcolor"] = backgroundColor != null
          ? [
              backgroundColor.red,
              backgroundColor.green,
              backgroundColor.blue,
              backgroundColor.alpha
            ]
          : [255, 255, 255, 1];
    }
    bool res = await _channel.invokeMethod('showToast', params);
    return res;
  }

  /// loading 提示框展示
  /// msg 显示内容
  /// status 1成功， -1 失败， 0 加载中 -2 警告
  /// canceledOnTouchOutside 空白地方点击消失
  /// cancelable 返回按钮点击消失，ios端不支持
  static Future<bool> showLoading({
    String msg = '',
    int status = 0,
    bool canceledOnTouchOutside = false,
    bool cancelable = false,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'msg': msg,
      'status': status,
      'canceledOnTouchOutside': canceledOnTouchOutside,
      'cancelable': cancelable
    };

    bool res = await _channel.invokeMethod('showLoading', params);
    return res;
  }
}
