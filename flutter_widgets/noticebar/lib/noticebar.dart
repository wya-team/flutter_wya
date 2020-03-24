library noticebar;

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NoticeBar extends StatefulWidget {
  NoticeBar({
    this.leftImageName,
    this.rightImageName,
    this.text,
    this.backgroundColor = Colors.white,
  }) : super();
  String leftImageName;
  String rightImageName;
  String text;
  Color backgroundColor;
  @override
  _NoticeBarState createState() => _NoticeBarState();
}

class _NoticeBarState extends State<NoticeBar>
    with SingleTickerProviderStateMixin {
  GlobalKey textKey = GlobalKey();
  GlobalKey selfKey = GlobalKey();
  double item_width = 0.0;
  double self_width = 0.0;
  final padding = 5.0;
  final image_width = 30.0;
//  var textPadding = 0.0;
  List<Widget> views = [];

  AnimationController controller;
  Animation curve;
  Animation<Offset> animation;
  double animationValue;
  bool animationComplate;

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
    addAnimation();
    reloadSubviews();
    getMaxWidth();
  }

  void getMaxWidth() {
    WidgetsBinding binding = WidgetsBinding.instance;
    binding.addPostFrameCallback((timeStamp) {
      RenderObject renderObject = textKey.currentContext.findRenderObject();
      RenderObject selfObject = selfKey.currentContext.findRenderObject();
      setState(() {
        item_width = renderObject.semanticBounds.size.width;
        self_width = selfObject.semanticBounds.size.width;
      });
    });
  }

  void reloadSubviews() {
    List<Widget> widgets = [];
    widgets.add(
      item_width >
          (self_width -
              (widget.leftImageName != null ? image_width : 0) -
              (widget.rightImageName != null ? image_width : 0))
          ? SlideTransition(
        transformHitTests: true,
        textDirection: TextDirection.rtl,
        position: this.animation,
        child: Padding(
          padding: EdgeInsets.only(left: animationComplate == true ?  100 : image_width),
          child: Text(
            widget.text,
            key: textKey,
            style: TextStyle(color: Colors.black),
            maxLines: 1,
          ),
        ),
      )
          : Positioned(
        left: widget.leftImageName != null ? image_width : padding * 2,
        child: Text(
          widget.text,
          key: textKey,
          style: TextStyle(color: Colors.black),
          maxLines: 1,
        ),
      ),
    );
    if (widget.leftImageName != null) {
      widgets.add(Positioned(
        left: 0,
        top: 0,
        bottom: 0,
        width: image_width,
        child: Container(
          color: Colors.white,
          child: Image(image: AssetImage(widget.leftImageName)),
        ),
      ));
    }
    if (widget.rightImageName != null) {
      widgets.add(Positioned(
        right: 0,
        top: 0,
        bottom: 0,
        width: image_width,
        child: Container(
          color: Colors.white,
          child: Image(
            image: AssetImage(widget.rightImageName),
          ),
        ),
      ));
    }

    setState(() {
      views = widgets;
    });
  }

  void addAnimation() {
    controller = AnimationController(
      duration: Duration(milliseconds: 10000),
      vsync: this,
    );
    curve = CurvedAnimation(parent: controller, curve: Curves.linear);
    animation = Tween(
      begin: Offset(0.0, 0.0),
      end: Offset(1.0, 0.0),
    ).animate(curve)
      ..addListener(() {
        setState(() {
          animationValue = animation.value.dx;
          print(animationValue);
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          controller.forward();
        }
      });
    controller.forward();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
//    print('self_width==$self_width');
//    print('item_width==$item_width');
    return Container(
      key: selfKey,
      height: 44,
      color: widget.backgroundColor,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: views,
      ),
    );
  }
}

