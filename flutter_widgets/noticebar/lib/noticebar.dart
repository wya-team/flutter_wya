library noticebar;
import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';

enum NoticeType {
  /// 连续性
  constant,
  /// 阶段性
  subsection,
}

// ignore: must_be_immutable
class NoticeBar extends StatefulWidget {
  NoticeBar({
    this.leftWidget,
    this.rightWidget,
    @required this.text,
    this.type = NoticeType.constant,
    this.backgroundColor = Colors.white,
  }) : super();
  Widget leftWidget;
  Widget rightWidget;
  String text;
  NoticeType type;
  Color backgroundColor;
  @override
  _NoticeBarState createState() => _NoticeBarState();
}

class _NoticeBarState extends State<NoticeBar>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  Timer _timer;
  double _offset = 0.0;
  int _itemCount = 100;

  GlobalKey _textKey = GlobalKey();
  GlobalKey _selfKey = GlobalKey();
  double _item_width = 0.0;
  double _self_width = 0.0;

  /// 设置内容边距
  final _padding = 5.0;
  final _image_width = 30.0;

  List<Widget> _views = [];
  bool _flag = false;

  AnimationController _controller;
  Animation _curve;
  Animation<Offset> _animation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addAnimation();
    reloadSubviews();

    getMaxWidth();
  }

  @override
  void didUpdateWidget(NoticeBar oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    getMaxWidth();
  }

  void getMaxWidth() {
    WidgetsBinding binding = WidgetsBinding.instance;
    binding.addPostFrameCallback((timeStamp) {
      RenderObject selfObject = _selfKey.currentContext.findRenderObject();
      RenderObject renderObject = _textKey.currentContext.findRenderObject();
      _self_width = selfObject.semanticBounds.size.width;
      _item_width = renderObject.semanticBounds.size.width;

      _flag = _item_width >
          (_self_width -
              (widget.leftWidget != null ? _image_width : 0) -
              (widget.rightWidget != null ? _image_width : 0));
      reloadSubviews();
    });
  }

  void reloadSubviews() {
    List<Widget> widgets = [];
    widgets.add(
      _flag
          ? widget.type == NoticeType.subsection
              ? SlideTransition(
                  position: _animation,
                  child: Padding(
                    padding: EdgeInsets.only(left: _image_width),
                    child: Text(
                      widget.text,
                      key: _textKey,
                      style: TextStyle(color: Colors.black),
                      maxLines: 1,
                    ),
                  ),
                )
              : ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: _scrollController,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _itemCount,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 44,
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: _image_width),
                child: Text(
                  widget.text,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    backgroundColor: Colors.red,
                  ),
                  maxLines: 1,
                ),
              ),
            );
          })
          : Positioned(
              left: widget.leftWidget != null ? _image_width : _padding * 2,
              child: Text(
                widget.text,
                key: _textKey,
                style: TextStyle(color: Colors.black),
                maxLines: 1,
              ),
            ),
    );
    if (widget.leftWidget != null) {
      widgets.add(Positioned(
        left: 0,
        top: 0,
        bottom: 0,
        width: _image_width,
        child: Container(
          color: widget.backgroundColor,
          child: widget.leftWidget,
        ),
      ));
    }
    if (widget.rightWidget != null) {
      widgets.add(Positioned(
        right: 0,
        top: 0,
        bottom: 0,
        width: _image_width,
        child: Container(
          color: widget.backgroundColor,
          child: widget.rightWidget,
        ),
      ));
    }

    setState(() {
      _views = widgets;
    });
  }

  void addAnimation() {
    if (widget.type == NoticeType.subsection) {
      _controller = AnimationController(
        duration: Duration(milliseconds: 10000),
        vsync: this,
      );
      _curve = CurvedAnimation(parent: _controller, curve: Curves.linear);
      _animation = Tween(
        begin: Offset(0.0, 0.0),
        end: Offset(-1.0, 0.0),
      ).animate(_curve)
        ..addListener(() {
          setState(() {});
        })
        ..addStatusListener((status) {
          if (status == AnimationStatus.completed) {
          } else if (status == AnimationStatus.dismissed) {}
        });
      _controller.repeat();
    } else {
      _scrollController = ScrollController(
        initialScrollOffset: _offset,
      );
      _scrollController.addListener(() {
        if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
//          _scrollController.jumpTo(10.0);
        }
      });
      _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
        double newOffset = _scrollController.offset + 10;
        if (newOffset != _offset) {
          _offset = newOffset;
          _scrollController.animateTo(_offset,
              duration: Duration(milliseconds: 100), curve: Curves.linear);
        }
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (_controller != null) {
      _controller.dispose();
    }
    if (_timer != null) {
      _timer.cancel();
    }
    if (_scrollController != null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _selfKey,
      height: 44,
      color: widget.backgroundColor,
      child: Stack(
        overflow: Overflow.visible,
        alignment: Alignment.centerLeft,
        children: _views,
      ),
    );
  }
}
