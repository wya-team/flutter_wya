library slider;

import 'package:flutter/material.dart';

class CustomSlider extends StatefulWidget {
  /// slider高度
  final double height;

  /// slider宽度
  final double width;

  /// 最小值
  final int min;

  /// 最大值
  final int max;

  /// 值改变
  final ValueChanged valueChanged;

  /// 未选中颜色
  final Color unselectedColor;

  /// 选中颜色
  final Color selectedColor;

  /// 操作球的边框宽度
  final double handlerBorderWidth;

  /// 当前选中的值
  double selectedValue;

  CustomSlider(
      {this.height = 2,
      @required this.width,
      @required this.min,
      @required this.max,
      this.valueChanged,
      this.unselectedColor = Colors.white,
      this.selectedColor = Colors.blue,
      this.handlerBorderWidth = 2,
      this.selectedValue = 0});

  @override
  _CustomSliderState createState() => _CustomSliderState();
}

class _CustomSliderState extends State<CustomSlider> {
  double handlerHeight;

  /// 滑块起始位置
  double handlerStartX;

  /// 被选中颜色的总宽度==滑块起始位置
  double selectedWidth;

  @override
  void initState() {
    super.initState();
    selectedWidth = widget.width * (widget.selectedValue / widget.max);
    handlerStartX = selectedWidth;
    handlerHeight = widget.height + 20;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Stack(
      children: <Widget>[
        _getSliderWidget(),
        Positioned(left: handlerStartX, top: 0, child: _getSliderHandler())
      ],
    ));
  }

  /// 获取一个slider组件没有handler
  _getSliderWidget() {
    return Container(
      height: handlerHeight,
      width: widget.width,
      alignment: Alignment.center,
      // 进度显示
      child: Stack(
        children: <Widget>[
          Container(
            height: widget.height,
            width: widget.width,
            color: widget.unselectedColor,
          ),
          Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                height: widget.height,
                width: selectedWidth,
                color: widget.selectedColor,
              ))
        ],
      ),
    );
  }

  /// 获取一个sliderHandler
  _getSliderHandler() {
    return GestureDetector(
        child: Container(
          width: handlerHeight,
          height: handlerHeight,
          decoration: BoxDecoration(
              color: widget.unselectedColor,
              border: Border.all(
                color: widget.selectedColor,
                width: widget.handlerBorderWidth,
              ),
              borderRadius: BorderRadius.circular(handlerHeight / 2)),
        ),
        onPanUpdate: _onPanUpdate);
  }

  // 计算偏移量
  _onPanUpdate(DragUpdateDetails details) {
    // 计算偏移量
    RenderBox renderBox = context.findRenderObject();
    var position = renderBox.globalToLocal(details.globalPosition);
    setState(() {
      if (position.dx < handlerHeight / 2) {
        handlerStartX = 0;
        selectedWidth = 0;
        widget.selectedValue = 0;
      } else if (position.dx >= widget.width) {
        handlerStartX = widget.width - handlerHeight;
        selectedWidth = widget.width - handlerHeight;
        widget.selectedValue = 1;
      } else {
        handlerStartX = position.dx - 10;
        selectedWidth = position.dx;
        widget.selectedValue = (position.dx / widget.width);
      }
    });
    widget.valueChanged((widget.selectedValue * widget.max).toInt());
  }
}
