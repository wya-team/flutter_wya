library noticebar;

import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NoticeBar extends StatefulWidget {
  NoticeBar({
    Key key,
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.leftWidget,
    this.rightWidget,
    @required this.textList,
    this.backgroundColor = Colors.white,
    this.autoAnimation = true,
  }) : super(key: key);

  Axis scrollDirection;

  bool reverse;

  Widget leftWidget;

  Widget rightWidget;

  List<String> textList;

  Color backgroundColor;

  bool autoAnimation;

  @override
  NoticeBarState createState() => NoticeBarState();
}

class NoticeBarState extends State<NoticeBar>
    with SingleTickerProviderStateMixin {
  Timer _timer;
  double _offset = 0.0;
  final _scrollController = ScrollController();
  final _image_width = 30.0;

  List<Widget> _views = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createScroll();
    _reloadSubviews();
    if (widget.autoAnimation == true) {
      startAnimation();
    }
  }

  @override
  void reassemble() {
    // TODO: implement reassemble
    super.reassemble();
    if (widget.autoAnimation == true) {
      startAnimation();
    }
  }

  void _reloadSubviews() {
    List<Widget> widgets = [];
    List<Widget> aa = [];
    widget.textList.forEach((element) {
      aa.add(Container(
        height: 44,
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: EdgeInsets.only(left: _image_width),
          child: Text(
            element,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
              backgroundColor: Colors.transparent,
            ),
            maxLines: 1,
          ),
        ),
      ));
    });
    widgets.add(
      ListView(
        reverse: widget.reverse,
        scrollDirection: widget.scrollDirection,
        controller: _scrollController,
        physics: NeverScrollableScrollPhysics(),
        children: aa,
      ),
    );

    if (widget.leftWidget != null) {
      widgets.add(Positioned(
        left: 0,
        top: 0,
        bottom: 0,
        width: _image_width,
        child: Container(
          color: Color.fromRGBO(widget.backgroundColor.red,
              widget.backgroundColor.green, widget.backgroundColor.blue, 1),
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
          color: Color.fromRGBO(widget.backgroundColor.red,
              widget.backgroundColor.green, widget.backgroundColor.blue, 1),
          child: widget.rightWidget,
        ),
      ));
    }

    setState(() {
      _views = widgets;
    });
  }

  void _createScroll() {
    _scrollController.addListener(() {
//        print('_scrollController.position.maxScrollExtent==${_scrollController.position.maxScrollExtent}');
//        print('_scrollController.offset==${_scrollController.offset}');
      if (widget.scrollDirection == Axis.horizontal) {
        double offsetScroll = _scrollController.position.maxScrollExtent;
        if (offsetScroll <= _scrollController.offset) {
          _scrollController.jumpTo(0.0);
        }
      } else {
        if (_scrollController.position.maxScrollExtent ==
            _scrollController.offset) {
          _scrollController.jumpTo(0.0);
        }
      }
    });
  }

  void startAnimation() {
    if (widget.scrollDirection == Axis.horizontal) {
      if (widget.textList.length == 1 && widget.textList.first.length < 20)
        return;
      if (_timer != null) return;
      _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
        if (_scrollController.hasClients == true) {
          setState(() {
            double newOffset = _scrollController.offset + 10;
            if (newOffset != _offset) {
              _offset = newOffset;
              _scrollController.animateTo(_offset,
                  duration: Duration(milliseconds: 100), curve: Curves.linear);
            }
          });
        }
      });
    } else {
      if (widget.textList.length < 2) return;
      if (_timer != null) return;
      _timer = Timer.periodic(Duration(seconds: 2), (timer) {
        double newOffset = _scrollController.offset + 44;
        if (newOffset != _offset) {
          _offset = newOffset;
          _scrollController.animateTo(_offset,
              duration: Duration(milliseconds: 500), curve: Curves.linear);
        }
      });
    }
  }

  void stopAnimation() {
    if (_timer != null) {
      _timer.cancel();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    stopAnimation();
    if (_scrollController != null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.autoAnimation == true) {
      startAnimation();
    }
    return Container(
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
