library image_preview;

import 'dart:ui';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

typedef ImagePreviewProvider = ImageProvider<dynamic> Function(
    BuildContext context, int index);
typedef ImagePreviewModelCallback = ImagePreviewModel Function(int index);
typedef ImageActionCallback = Function(int index);

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
    this.selectIndex = 0,
    this.modelCallback,
    this.actionCallback,
    this.pageControlStyle = PageControlStyle.none,
    this.minZoomNumber = 1.0,
    this.maxZoomNumber = 3.0,
  })  : assert(provider != null),
        assert(itemCount != null || itemCount == 0);

  /// 返回需要加载的图片类型，类型由外部定义
  /// ImageProvider
  ImagePreviewProvider provider;

  /// 用来控制界面显示元素的
  ImagePreviewModelCallback modelCallback;

  /// 下载按钮回调
  ImageActionCallback actionCallback;

  /// 默认选中的下标
  int selectIndex;

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
  PageController _pageController;
  double screenWidth;

  // 检测当前所在位置
  int _lastIndex = 0;

  // 记录外部传入数据模型，用来改变页面状态和操作
  ImagePreviewModel _model;

  /// 记录内部图片加载ImageProvider
  List<Widget> _imageProviders = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lastIndex = widget.selectIndex;
    for (var i = 0; i<widget.itemCount; i++){
      _imageProviders.add(ExtendedImage(image: AssetImage(''),));
    }
    if (widget.modelCallback != null) {
      _model = widget.modelCallback(0);
    }
    _pageController = PageController(
      initialPage: widget.selectIndex,
    );
    _pageController.addListener(() {
      if (_pageController.offset % screenWidth == 0.0) {
        setState(() {
          if (widget.modelCallback != null) {
            _model = widget.modelCallback(_pageController.page.toInt());
          }
          _lastIndex = _pageController.page.toInt();
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
                    _model?.isShowOriginalImage == true
                ? RaisedButton(
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
                  )
                : null,
          ),
          Padding(
            padding: EdgeInsets.only(right: 20),
            child: SizedBox.fromSize(
              size: Size(144, 44),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  IconButton(
                    icon: Image.asset('images/icon_photo_download.png', package: 'image_preview'),
                    color: Colors.white,
                    onPressed: (){
                      if (widget.actionCallback != null) {
                        widget.actionCallback(0);
                      }
                    },
                  ),
                  IconButton(
                    icon: Image.asset('images/icon_photo_view.png', package: 'image_preview'),
                    onPressed: (){
                      if (widget.actionCallback != null) {
                        widget.actionCallback(1);
                      }
                    },
                  ),
                  IconButton(
                    icon: Image.asset('images/icon_photo_operation.png', package: 'image_preview'),
                    onPressed: (){
                      if (widget.actionCallback != null) {
                        widget.actionCallback(2);
                      }
                    },
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
    _imageProviders.replaceRange((_pageController.offset / screenWidth).toInt(),
        (_pageController.offset / screenWidth).toInt() + 1, [
      ExtendedImage.network(_model.originalImageUrl,
          cache: false,
          mode: ExtendedImageMode.gesture, initGestureConfigHandler: (state) {
        return GestureConfig(
          minScale: widget.minZoomNumber,
          animationMinScale: 0.7,
          maxScale: widget.maxZoomNumber,
          animationMaxScale: 3.5,
          speed: 1.0,
          inertialSpeed: 100.0,
          initialScale: 1.0,
          inPageView: true,
          initialAlignment: InitialAlignment.center,
        );
      }, loadStateChanged: (ExtendedImageState state) {
        if (state.extendedImageLoadState == LoadState.loading) {
          print(state.loadingProgress);
          return Center(
            child: CupertinoActivityIndicator(
              radius: 30,
            ),
          );
        } else if (state.extendedImageLoadState == LoadState.failed) {
          return Center(
            child: Text(
              '失败',
              style: TextStyle(color: Colors.white),
            ),
          );
        } else {
          return state.completedWidget;
        }
      }),
    ]);
    setState(() {
      _model.isShowOriginalImage = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: <Widget>[
        ExtendedImageGesturePageView.builder(
            controller: _pageController,
            itemCount: widget.itemCount,
            itemBuilder: (BuildContext context, int index) {
              Widget aa = ExtendedImage(
                image: widget.provider(context, index),
                mode: ExtendedImageMode.gesture,
                initGestureConfigHandler: (state) {
                  return GestureConfig(
                    minScale: widget.minZoomNumber,
                    animationMinScale: 0.7,
                    maxScale: widget.maxZoomNumber,
                    animationMaxScale: 3.5,
                    speed: 1.0,
                    inertialSpeed: 100.0,
                    initialScale: 1.0,
                    inPageView: true,
                    initialAlignment: InitialAlignment.center,
                  );
                },
              );
              if (_imageProviders.contains(aa) == false) {
                _imageProviders.replaceRange(index, index+1, [aa]);
              }
              return Container(
                color: Colors.black,
                child: _imageProviders[index],
              );
            }),
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
