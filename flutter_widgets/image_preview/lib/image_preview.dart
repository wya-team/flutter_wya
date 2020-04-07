library image_preview;

import 'package:flutter/material.dart';

typedef ImagePreviewProvider = ImageProvider<dynamic> Function(
    BuildContext context, int index);
typedef ImagePreviewModelCallback = ImagePreviewModel Function(int index);

enum PageControlStyle {
  none,

  /// 小圆点, 不建议超过九张图时使用该模式
  dots,

  /// 分页器，example：1/10
  numberPage,
}

class ImagePreviewModel {
  /// 原图url，如果为null时，则不显示原图按钮
  String originalImageUrl;

  /// 图片大小，需要把单位字段也传入
  /// example：100kb
  String imageSize;

  /// 内部使用
  bool isShowOriginalImage = true;

  ImagePreviewModel({this.originalImageUrl, this.imageSize});

}

class ImagePreview extends StatefulWidget {
  ImagePreview({
    @required this.provider,
    @required this.itemCount,
    this.callback,
    this.pageControlStyle = PageControlStyle.none,
    this.minZoomNumber = 1.0,
    this.maxZoomNumber = 3.0,
  });

  /// 返回需要加载的图片类型，类型由外部定义
  /// ImageProvider
  ImagePreviewProvider provider;

  /// 用来控制界面显示元素的
  ImagePreviewModelCallback callback;

  /// 要显示图片的个数
  int itemCount;

  /// 控制栏样式，默认为none
  PageControlStyle pageControlStyle;

  /// 最小缩放倍数，默认为1.0
  double minZoomNumber;

  /// 最大缩放倍数，默认为3.0
  double maxZoomNumber;

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  ScrollController scrollController = ScrollController();
  double screenWidth;
  // 检测最后偏移量
  Offset _lastOffset;
  // 检测当前所在位置
  int _lastIndex = 0;
  // 初始缩放大小
  double _scaleNumber = 1;
  // 记录外部传入数据模型，用来改变页面状态和操作
  ImagePreviewModel _model;
  /// 记录内部图片加载ImageProvider
  List<ImageProvider<dynamic>> _imageProviders = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.callback != null) {
      _model = widget.callback(0);
    }
    scrollController.addListener(() {
      if (scrollController.offset % screenWidth == 0.0) {
        setState(() {
          if (widget.callback != null) {
            _model =
                widget.callback(
                    (scrollController.offset / screenWidth).toInt());
          }
        });
      }
    });
  }

  Widget imageInfoBar() {
    return Positioned(
      bottom: 25,
      height: 50,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20),
            child: _model?.originalImageUrl != null &&
                _model?.isShowOriginalImage == true ? RaisedButton(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              color: Color.fromRGBO(38, 38, 38, 1),
              onPressed: showOriginalImage,
              child: Text(
                '查看原图(${_model.imageSize})',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12.0,
                ),
              ),
            ) : null,
          ),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: SizedBox.fromSize(
              size: Size(120, 44),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 20,
                    height: 20,
                    color: Colors.red,
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    color: Colors.red,
                  ),
                  Container(
                    width: 20,
                    height: 20,
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget dotsBar() {
    List<Widget> dots = [];
    for (var index = 0; index < widget.itemCount; index++) {
      dots.add(Padding(
        padding: EdgeInsets.only(left: 3, right: 3),
        child: ClipOval(
          clipper: _MyClipper(),
          child: Container(
            width: 6.5,
            height: 6.5,
            color: _lastIndex == index
                ? Colors.white
                : Color.fromRGBO(49, 49, 49, 1),
          ),
        ),
      ));
    }
    return Positioned(
      bottom: 20,
      height: 20,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: dots,
      ),
    );
  }

  Widget numberPageBar() {
    return Positioned(
      bottom: 20,
      height: 20,
      left: 0,
      width: screenWidth,
      child: Text(
        '${_lastIndex + 1}/${widget.itemCount}',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget bottomBar() {
    if (widget.pageControlStyle == PageControlStyle.none) {
      return imageInfoBar();
    } else if (widget.pageControlStyle == PageControlStyle.dots) {
      return dotsBar();
    } else if (widget.pageControlStyle == PageControlStyle.numberPage) {
      return numberPageBar();
    }
  }

  void showOriginalImage() {
    print('_imageProviders==$_imageProviders');
    print((scrollController.offset / screenWidth).toInt());
    _imageProviders.replaceRange((scrollController.offset / screenWidth).toInt(),
        (scrollController.offset / screenWidth).toInt() + 1, [NetworkImage(
            _model.originalImageUrl
        )]);
    setState(() {
      _scaleNumber = 1;
      _model.isShowOriginalImage = false;
    });
  }

  void doubleTapClick() {
    if (_scaleNumber < widget.maxZoomNumber) {
      setState(() {
        _scaleNumber ++;
      });
    }
//                else if (_scaleNumber > widget.minZoomNumber) {
//                  setState(() {
//                    _scaleNumber --;
//                  });
//                }
  }

  void longTapClick() {
    print('长按');
  }

  void onHorizontalDragDownClick(DragDownDetails details) {
    _lastOffset = details.globalPosition;
  }

  void onHorizontalDragStartClick(DragStartDetails details) {
    if (details.globalPosition.dx < _lastOffset.dx) {
      print('向左滑');
      if (_lastIndex == widget.itemCount - 1) {
        print('左滑到底了');
      } else {
        setState(() {
          _lastIndex++;
        });
      }
    } else if (details.globalPosition.dx > _lastOffset.dx) {
      print('向右滑');
      if (_lastIndex == 0) {
        print('右滑到底了');
      } else {
        setState(() {
          _lastIndex--;
        });
      }
    }
    scrollController.animateTo(_lastIndex.toDouble() * screenWidth,
        duration: Duration(milliseconds: 200),
        curve: Curves.linear);
    setState(() {
      _scaleNumber = 1;
    });
  }

  void onScaleStartClick(ScaleStartDetails details) {
    print(details);
//    var number = _scaleNumber;
//    setState(() {
//      print('开始');
//      _scaleNumber = number;
//    });
  }

  void onScaleUpdateClick(ScaleUpdateDetails details) {
    print('上次的值==$_scaleNumber');
    print('这次的值==${details.scale}');
    if (details.scale - _scaleNumber > 0) {
      // 放大
      if (details.scale != 1 && details.scale < widget.maxZoomNumber) {
        setState(() {
          print('等于1了1');
          _scaleNumber = details.scale;
        });
      }
    }
    if (details.scale - _scaleNumber < 0) {
      if (details.scale != 1 && _scaleNumber > widget.minZoomNumber) {
        setState(() {
          print('等于1了2');
          _scaleNumber = details.scale;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Stack(
      children: <Widget>[
        ListView.builder(
          scrollDirection: Axis.horizontal,
          physics: NeverScrollableScrollPhysics(),
          controller: scrollController,
          itemCount: widget.itemCount,
          itemExtent: screenWidth,
          itemBuilder: (BuildContext context, int index) {
            var aa = widget.provider(context, index);
            if (_imageProviders.contains(aa) == false) {
              _imageProviders.add(aa);
            }
            return GestureDetector(
              onDoubleTap: doubleTapClick,
              onLongPress: longTapClick,
              onHorizontalDragDown: (DragDownDetails details) =>
                  onHorizontalDragDownClick(details),
              onHorizontalDragStart: (DragStartDetails details) =>
                  onHorizontalDragStartClick(details),
              onScaleStart: (ScaleStartDetails details) =>
                  onScaleStartClick(details),
              onScaleUpdate: (ScaleUpdateDetails details) =>
                  onScaleUpdateClick(details),
              child: Container(
                  color: Colors.black,
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      Transform.scale(
                        scale: _scaleNumber,
                        alignment: Alignment.center,
                        child: Image(
                          image: _imageProviders[index],
                        ),
                      ),
                    ],
                  )
              ),
            );
          },
        ),
        bottomBar(),
      ],
    );
  }
}

class _MyClipper extends CustomClipper<Rect> {
  @override
  Rect getClip(Size size) {
    return new Rect.fromLTRB(0, 0, size.width, size.height);
  }

  @override
  bool shouldReclip(CustomClipper<Rect> oldClipper) {
    return false;
  }
}