library segmentcontrol;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SegmentControl<T> extends StatefulWidget {
  /// 需要展示的内容例如：Map children = {'apple':Text('apple), 'orange':Text(orange)}
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

  SegmentControl({
    Key key,
    @required this.children,
    @required this.onValueChanged,
    @required this.width,
    @required this.height,
    this.groupValue,
    this.unselectedColor,
    this.selectedColor,
    this.borderColor,
    this.pressedColor,
    this.padding,
  })  : assert(children != null),
        assert(children.length >= 2),
        assert(onValueChanged != null),
        assert(width != null),
        assert(height != null),
        assert(
          groupValue == null ||
              children.keys.any((T child) => child == groupValue),
          'The groupValue must be either null or one of the keys in the children map.',
        ),
        super(key: key);

  @override
  _SegmentControlState createState() => _SegmentControlState();
}

class _SegmentControlState extends State<SegmentControl> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: CupertinoSegmentedControl(
        children: widget.children,
        groupValue: widget.groupValue,
        onValueChanged: widget.onValueChanged,
        unselectedColor: widget.unselectedColor,
        selectedColor: widget.selectedColor,
        pressedColor: widget.pressedColor,
        borderColor: widget.borderColor,
        padding: widget.padding,
      ),
    );
  }
}
