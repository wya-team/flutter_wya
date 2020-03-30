import 'dart:convert';

extension ListExtension on List{

  /// 将一个List转换为一个JSON类型的String
  /// callback => String
  String listTransToJSONString() {
    /// 需要实现数组转json字符串
    return json.encode(this);
  }

  /// 安全删除某个范围内的元素，包含start，但是不包含end
  /// start: 开始位置
  /// end：结束位置
  /// callback => bool，越界会返回false
  bool safeRemoveRange(int start, int end) {
    if (start >= this.length && end >= this.length) {
      return false;
    }
    this.removeRange(start, end);
    return true;
  }

  /// 安全删除某个元素
  /// index :所需要删除的元素下标
  /// callback => bool，越界会返回false
  bool safeRemoveAt(int index) {
    if (index >= this.length) {
      return false;
    }
    this.removeAt(index);
    return true;
  }

  /// 通过索引安全的获取一个元素
  /// index 需要获取元素的索引
  /// callback => 如果越界会返回一个null，没有越界会返回正常的值
  safeValueof(int index) {
    if (index >= this.length) {
      return null;
    }
    return this[index];
  }

}