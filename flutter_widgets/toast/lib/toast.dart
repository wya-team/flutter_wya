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
  /// gravity 显示位置， 中上下
  /// backgroundColor 背景颜色
  /// textColor 文字颜色
  static Future<bool> showToast({
    @required String msg,
    int time = 0,
    double fontSize = 16.0,
    ToastGravity gravity,
    Color backgroundColor,
    Color textColor,
  }) async {
    String gravityToast = "bottom";
    if (gravity == ToastGravity.TOP) {
      gravityToast = "top";
    } else if (gravity == ToastGravity.CENTER) {
      gravityToast = "center";
    } else {
      gravityToast = "bottom";
    }

    final Map<String, dynamic> params = <String, dynamic>{
      'msg': msg,
      'time': time,
      'gravity': gravityToast,
      'bgcolor': backgroundColor != null ? backgroundColor.value : null,
      'textcolor': textColor != null ? textColor.value : null,
      'fontSize': fontSize,
    };

    bool res = await _channel.invokeMethod('showToast', params);
    return res;
  }

  /// loading 提示框展示
  /// msg 显示内容
  /// status 1成功， -1 失败， 0 加载中
  /// backgroundColor 显示位置， 中上下
  /// canceledOnTouchOutside 空白地方点击消失
  /// cancelable 返回按钮点击消失
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
