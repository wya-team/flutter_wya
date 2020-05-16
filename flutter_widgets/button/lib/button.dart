import 'package:flutter/material.dart';

enum ButtonState {
  normal,
  highLight,
  select,
}

enum ButtonDirection {
  /// 从左往右
  ltr,

  /// 从右往左
  rtl,

  /// 从上往下
  ttb,

  /// 从下往上
  btt,
}

enum ButtonAlign {
  center,
  left,
  right,
  top,
  bottom,
}

typedef ButtonTitleCallback = Widget Function(ButtonState state);
typedef ButtonImageCallback = Widget Function(ButtonState state);
typedef ButtonBoxDecorationCallback = BoxDecoration Function(ButtonState state);
typedef ButtonTapCallback = Function(bool select);

class Button extends StatefulWidget {
  Button(
      {this.disable = false,
        this.select = false,
        this.width,
        this.height,
        this.direction = ButtonDirection.ltr,
        this.align = ButtonAlign.center,
        this.titleCallback,
        this.imageCallback,
        @required this.boxDecorationCallback,
        this.tapCallback})
      : assert(titleCallback != null || imageCallback != null),
        assert(boxDecorationCallback != null);

  /// 是否禁用按钮
  bool disable;

  /// 是否选中
  bool select;

  double width;
  double height;

  /// 按钮内部的排列方式
  ButtonDirection direction;

  /// 按钮内部的对齐方式
  ButtonAlign align;

  /// 按钮标题回调
  ButtonTitleCallback titleCallback;

  /// 按钮图片回调
  ButtonImageCallback imageCallback;

  /// 按钮样式描述
  ButtonBoxDecorationCallback boxDecorationCallback;

  /// 按钮点击效果
  ButtonTapCallback tapCallback;

  @override
  _ButtonState createState() => _ButtonState();
}

class _ButtonState extends State<Button> with SingleTickerProviderStateMixin {
  ButtonState _stateType;

  Animation<Decoration> _animation;
  AnimationController _controller;
  Animation _curve;

  Widget subWidget() {
    if (widget.titleCallback != null && widget.imageCallback != null) {
      if (widget.direction == ButtonDirection.ltr ||
          widget.direction == ButtonDirection.rtl) {
        List<Widget> rows = [];
        if (widget.direction == ButtonDirection.ltr) {
          rows.add(widget.imageCallback(_stateType));
          rows.add(widget.titleCallback(_stateType));
        } else {
          rows.add(widget.titleCallback(_stateType));
          rows.add(widget.imageCallback(_stateType));
        }
        MainAxisAlignment axisAlignment = MainAxisAlignment.start;
        CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center;
        if (widget.align == ButtonAlign.center) {
          axisAlignment = MainAxisAlignment.center;
        } else if (widget.align == ButtonAlign.left) {
          axisAlignment = MainAxisAlignment.start;
        } else if (widget.align == ButtonAlign.right) {
          axisAlignment = MainAxisAlignment.end;
        } else if (widget.align == ButtonAlign.top) {
          crossAxisAlignment = CrossAxisAlignment.start;
        } else {
          crossAxisAlignment = CrossAxisAlignment.end;
        }
        return Row(
          mainAxisAlignment: axisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: rows,
        );
      } else {
        List<Widget> columns = [];
        if (widget.direction == ButtonDirection.ttb) {
          columns.add(widget.imageCallback(_stateType));
          columns.add(widget.titleCallback(_stateType));
        } else {
          columns.add(widget.titleCallback(_stateType));
          columns.add(widget.imageCallback(_stateType));
        }
        MainAxisAlignment axisAlignment = MainAxisAlignment.start;
        CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center;
        if (widget.align == ButtonAlign.center) {
          axisAlignment = MainAxisAlignment.center;
        } else if (widget.align == ButtonAlign.top) {
          axisAlignment = MainAxisAlignment.start;
        } else if (widget.align == ButtonAlign.bottom) {
          axisAlignment = MainAxisAlignment.end;
        } else if (widget.align == ButtonAlign.left) {
          crossAxisAlignment = CrossAxisAlignment.start;
        } else {
          crossAxisAlignment = CrossAxisAlignment.end;
        }
        return Column(
          mainAxisAlignment: axisAlignment,
          crossAxisAlignment: crossAxisAlignment,
          children: columns,
        );
      }
    } else if (widget.titleCallback != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.titleCallback(_stateType),
        ],
      );
    } else if (widget.imageCallback != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          widget.imageCallback(_stateType),
        ],
      );
    }
    return Text('aa');
  }

  Alignment subAlignment() {
    if (widget.align == ButtonAlign.center) {
      return Alignment.center;
    } else if (widget.align == ButtonAlign.left) {
      return Alignment.centerLeft;
    } else if (widget.align == ButtonAlign.right) {
      return Alignment.centerRight;
    } else if (widget.align == ButtonAlign.top) {
      return Alignment.topCenter;
    } else {
      return Alignment.bottomCenter;
    }
  }

  void resetAnimation() {
    _animation = DecorationTween(
      begin: BoxDecoration(
        color: widget.boxDecorationCallback(_stateType).color ??
            Colors.transparent,
      ),
      end: BoxDecoration(
        color: Colors.grey,
      ),
    ).animate(_curve)
      ..addStatusListener((AnimationStatus state) {
        //如果动画已完成，就反转动画
        if (state == AnimationStatus.completed) {
          _controller.reverse();
        }
      });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.select == true) {
      _stateType = ButtonState.select;
    } else {
      _stateType = ButtonState.normal;
    }
    //动画控制器
    _controller = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    //动画插值器
    _curve = CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn);
    //动画变化范围
    _animation = DecorationTween(
      begin: BoxDecoration(
        color: widget.boxDecorationCallback(_stateType).color ??
            Colors.transparent,
      ),
      end: BoxDecoration(
        color: Colors.grey,
      ),
    ).animate(_curve)
      ..addStatusListener((AnimationStatus state) {
        //如果动画已完成，就反转动画
        if (state == AnimationStatus.completed) {
          _controller.reverse();
        }
      });
  }

  @override
  void reassemble() {
    // TODO: implement reassemble
    super.reassemble();
    if (widget.select == true) {
      _stateType = ButtonState.select;
    } else {
      _stateType = ButtonState.normal;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (widget.disable == true) return;
        setState(() {
          widget.select = !widget.select;
          if (widget.disable == false) {
            if (widget.select == true) {
              _stateType = ButtonState.select;
            } else {
              _stateType = ButtonState.normal;
            }
            if (widget.tapCallback != null) {
              widget.tapCallback(widget.select);
            }
          }
          resetAnimation();
          _controller.forward();
        });
      },
      onLongPress: () {
        if (widget.disable == true) return;
        setState(() {
          _stateType = ButtonState.highLight;
        });
      },
      onLongPressEnd: (detail) {
        setState(() {
          _stateType = ButtonState.normal;
        });
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        alignment: subAlignment(),
        decoration: widget.boxDecorationCallback != null
            ? widget.boxDecorationCallback(_stateType)
            : null,
        child: DecoratedBoxTransition(
          decoration: _animation,
          child: subWidget(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
