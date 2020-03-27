import 'dart:convert';

extension StringExtension on String{

  /// 将一个JSONString转换为一个List类型
  /// callback => List
  List jsonStringTransToList() {
    return json.decode(this);
  }

  /// 将一个JSONString转换为一个Map类型
  /// callback => Map
  Map jsonStringTransToMap() {
    return json.decode(this);
  }

}
