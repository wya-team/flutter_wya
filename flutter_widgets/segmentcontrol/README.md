# segmentcontrol

### API文档

##### 组件成员变量解释：

```dart
  /// 需要展示的内容例如：
  /// Map children = {'apple':Text('apple), 'orange':Text(orange)}
  final Map<T, Widget> children;

  /// 默认选中哪一个数据传入children中的key值即可
  final T groupValue;

  /// 数据改变
  final ValueChanged<T> onValueChanged;

  /// 未选中颜色
  final Color unselectedColor;

  /// 选中颜色
  final Color selectedColor;

  /// 边框颜色
  final Color borderColor;

  /// 点击颜色
  final Color pressedColor;

  final EdgeInsetsGeometry padding;

  final double width;

  final double height;
```

##### Demo

```dart
  _getSegmentControl() {
    Map<String, Text> map = {
      'apple': Text('Apple'),
      'orange': Text('Orange'),
      'banana': Text('Banana')
    };

    String _fruit = 'apple';

    return SegmentControl(
      children: map,
      groupValue: _fruit,
      onValueChanged: (value) {
        setState(() {
          _fruit = value;
        });
      },
      width: double.infinity,
      height: 120,
      unselectedColor: CupertinoColors.white,
      // 未选中颜色
      selectedColor: CupertinoColors.activeBlue,
      // 选中颜色
      borderColor: CupertinoColors.activeBlue,
      // 边框颜色
      pressedColor: const Color(0x33007AFF),
    ); // 点击时候的颜色
  }
```