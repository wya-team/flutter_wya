# extension_data

## List API文档

```dart
  /// 将一个List转换为一个JSON类型的String
  /// callback => String
  String listTransToJSONString() {}

  /// 安全删除某个范围内的元素，包含start，但是不包含end
  /// start: 开始位置
  /// end：结束位置
  /// callback => bool，越界会返回false
  bool safeRemoveRange(int start, int end) {}

  /// 安全删除某个元素
  /// index :所需要删除的元素下标
  /// callback => bool，越界会返回false
  bool safeRemoveAt(int index) {}

  /// 通过索引安全的获取一个元素
  /// index 需要获取元素的索引
  /// callback => 如果越界会返回一个null，没有越界会返回正常的值
  safeValueof(int index) {}
```

### Example

- 可使用list对象点语法直接调用

```dart
List<int> templist = [1,2,3];
templist.safeRemoveAt(0);
print(templist);// 输出结果为[2,3]
```


## Map API文档



- 调用方式：直接使用Map对象调用

```dart
  /// 将一个Map转换为一个JSON类型的String
  /// callback => String
  String mapTransToJSONString() {}
```

## String

```dart
  /// 将一个JSONString转换为一个List类型
  /// callback => List
  List jsonStringTransToList() {}

  /// 将一个JSONString转换为一个Map类型
  /// callback => Map
  Map jsonStringTransToMap() {}
```


