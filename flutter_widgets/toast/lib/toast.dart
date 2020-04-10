import 'dart:async';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum ToastGravity { TOP, BOTTOM, CENTER }

enum Orientations { Vertical, Horizontal }

class CustomToast {
  static const MethodChannel _channel = const MethodChannel('toast');

  static Future<bool> cancelToast() async {
    bool res = await _channel.invokeMethod("cancelToast");
    return res;
  }

  static Future<bool> cancelLoading() async {
    bool res = await _channel.invokeMethod("cancelLoading");
    return res;
  }

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

  static Future<bool> showLoading({
    String msg = '',
    Color backgroundColor,
    int status = 0,
    bool canceledOnTouchOutside = false,
    bool cancelable = false,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'msg': msg,
      'backgroundColor': backgroundColor != null ? backgroundColor.value : null,
      'status': status,
      'canceledOnTouchOutside': canceledOnTouchOutside,
      'cancelable': cancelable
    };

    bool res = await _channel.invokeMethod('showLoading', params);
    return res;
  }
}
