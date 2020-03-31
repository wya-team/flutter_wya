library noticebar;
import 'dart:ui';
import 'dart:async';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NoticeBar extends StatefulWidget {
  NoticeBar({
    this.scrollDirection = Axis.horizontal,
    this.reverse = false,
    this.leftWidget,
    this.rightWidget,
    @required this.textList,
    this.backgroundColor = Colors.white,
  }) : super();
  Axis scrollDirection;
  bool reverse;
  Widget leftWidget;
  Widget rightWidget;
  List<String> textList;
  Color backgroundColor;
  @override
  _NoticeBarState createState() => _NoticeBarState();
}

class _NoticeBarState extends State<NoticeBar>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  Timer _timer;
  double _offset = 0.0;

  final _image_width = 30.0;

  List<Widget> _views = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    addAnimation();
    reloadSubviews();

  }

  @override
  void didUpdateWidget(NoticeBar oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  void reloadSubviews() {
    List<Widget> widgets = [];
    if(widget.textList.length > 1) {
      widgets.add(ListView.builder(
        reverse: widget.reverse,
          scrollDirection: widget.scrollDirection,
          controller: _scrollController,
          physics: NeverScrollableScrollPhysics(),
          itemCount: widget.textList.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              height: 44,
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: _image_width),
                child: Text(
                  widget.textList[index],
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    backgroundColor: widget.backgroundColor,
                  ),
                  maxLines: 1,
                ),
              ),
            );
          }));
    }

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

      _scrollController = ScrollController(
        initialScrollOffset: _offset,
      );
      _scrollController.addListener(() {
//        print('_scrollController.position.maxScrollExtent==${_scrollController.position.maxScrollExtent}');
//        print('_scrollController.offset==${_scrollController.offset}');
        if (widget.scrollDirection == Axis.horizontal){
          double offsetScroll = 0.0;
          if (widget.leftWidget != null && widget.rightWidget != null){
            offsetScroll = _scrollController.position.maxScrollExtent + _image_width * 2;
          } else if (widget.leftWidget != null || widget.rightWidget != null){
            offsetScroll = _scrollController.position.maxScrollExtent + _image_width;
          } else {
            offsetScroll = _scrollController.position.maxScrollExtent;
          }
          if (offsetScroll <= _scrollController.offset) {
            _scrollController.jumpTo(0.0);
          }
        } else {
          if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
            _scrollController.jumpTo(0.0);
          }
        }

      });
      if(widget.scrollDirection == Axis.horizontal) {
        _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
          double newOffset = _scrollController.offset + 10;
          if (newOffset != _offset) {
            _offset = newOffset;
            _scrollController.animateTo(_offset,
                duration: Duration(milliseconds: 100), curve: Curves.linear);
          }
        });
      } else {
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

  @override
  void dispose() {
    // TODO: implement dispose
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
