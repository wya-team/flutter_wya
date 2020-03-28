import 'dart:convert';

extension StringExtension on String{

  /// 将一个Map转换为一个JSON类型的String
  /// callback => String
  String mapTransToJSONString() {
    return json.encode(this);
  }
}