// GENERATED CODE - DO NOT MODIFY MANUALLY
// **************************************************************************
// Auto generated by https://github.com/fluttercandies/ff_annotation_route
// **************************************************************************

import 'package:flutter/widgets.dart';

import 'pages/custom_image_demo.dart';
import 'pages/image_demo.dart';
import 'pages/image_editor_demo.dart';
import 'pages/loading_progress.dart';
import 'pages/main_page.dart';
import 'pages/paint_image_demo.dart';
import 'pages/photo_view_demo.dart';
import 'pages/pic_swiper_page.dart';
import 'pages/waterfall_flow_demo.dart';
import 'pages/zoom_image_demo.dart';

RouteResult getRouteResult({String name, Map<String, dynamic> arguments}) {
  switch (name) {
    case "fluttercandies://WaterfallFlowDemo":
      return RouteResult(
        widget: WaterfallFlowDemo(),
        routeName: "WaterfallFlow",
        description:
            "show how to build loading more WaterfallFlow with ExtendedImage.",
      );
    case "fluttercandies://customimage":
      return RouteResult(
        widget: CustomImageDemo(),
        routeName: "custom image load state",
        description: "show image with loading,failed,animation state",
      );
    case "fluttercandies://image":
      return RouteResult(
        widget: ImageDemo(),
        routeName: "image",
        description:
            "cache image,save to photo Library,image border,shape,borderRadius",
      );
    case "fluttercandies://imageeditor":
      return RouteResult(
        widget: ImageEditorDemo(),
        routeName: "image editor",
        description: "crop,rotate and flip with image editor",
      );
    case "fluttercandies://loadingprogress":
      return RouteResult(
        widget: LoadingProgress(),
        routeName: "loading progress",
        description: "show how to make loading progress for network image",
      );
    case "fluttercandies://mainpage":
      return RouteResult(
        widget: MainPage(),
        routeName: "MainPage",
      );
    case "fluttercandies://paintimage":
      return RouteResult(
        widget: PaintImageDemo(),
        routeName: "paint image",
        description:
            "show how to paint any thing before/after image is painted",
      );
    case "fluttercandies://photoview":
      return RouteResult(
        widget: PhotoViewDemo(),
        routeName: "photo view",
        description: "show how to zoom/pan image in page view like WeChat",
      );
    case "fluttercandies://picswiper":
      return RouteResult(
        widget: PicSwiperPage(
          index: arguments['index'],
          pics: arguments['pics'],
          tuChongItem: arguments['tuChongItem'],
        ),
        showStatusBar: false,
        routeName: "PicSwiper",
        pageRouteType: PageRouteType.transparent,
      );
    case "fluttercandies://zoomimage":
      return RouteResult(
        widget: ZoomImageDemo(),
        routeName: "image zoom",
        description: "show how to zoom/pan image",
      );
    default:
      return RouteResult();
  }
}

class RouteResult {
  /// The Widget return base on route
  final Widget widget;

  /// Whether show this route with status bar.
  final bool showStatusBar;

  /// The route name to track page
  final String routeName;

  /// The type of page route
  final PageRouteType pageRouteType;

  /// The description of route
  final String description;

  const RouteResult({
    this.widget,
    this.showStatusBar = true,
    this.routeName = '',
    this.pageRouteType,
    this.description = '',
  });
}

enum PageRouteType { material, cupertino, transparent }

List<String> routeNames = [
  "fluttercandies://WaterfallFlowDemo",
  "fluttercandies://customimage",
  "fluttercandies://image",
  "fluttercandies://imageeditor",
  "fluttercandies://loadingprogress",
  "fluttercandies://mainpage",
  "fluttercandies://paintimage",
  "fluttercandies://photoview",
  "fluttercandies://picswiper",
  "fluttercandies://zoomimage"
];

class Routes {
  const Routes._();

  /// "show how to build loading more WaterfallFlow with ExtendedImage."
  ///
  /// [name] : fluttercandies://WaterfallFlowDemo
  /// [routeName] : WaterfallFlow
  /// [description] : "show how to build loading more WaterfallFlow with ExtendedImage."
  static const String FLUTTERCANDIES_WATERFALLFLOWDEMO =
      "fluttercandies://WaterfallFlowDemo";

  /// "show image with loading,failed,animation state"
  ///
  /// [name] : fluttercandies://customimage
  /// [routeName] : custom image load state
  /// [description] : "show image with loading,failed,animation state"
  static const String FLUTTERCANDIES_CUSTOMIMAGE =
      "fluttercandies://customimage";

  /// "cache image,save to photo Library,image border,shape,borderRadius"
  ///
  /// [name] : fluttercandies://image
  /// [routeName] : image
  /// [description] : "cache image,save to photo Library,image border,shape,borderRadius"
  static const String FLUTTERCANDIES_IMAGE = "fluttercandies://image";

  /// "crop,rotate and flip with image editor"
  ///
  /// [name] : fluttercandies://imageeditor
  /// [routeName] : image editor
  /// [description] : "crop,rotate and flip with image editor"
  static const String FLUTTERCANDIES_IMAGEEDITOR =
      "fluttercandies://imageeditor";

  /// "show how to make loading progress for network image"
  ///
  /// [name] : fluttercandies://loadingprogress
  /// [routeName] : loading progress
  /// [description] : "show how to make loading progress for network image"
  static const String FLUTTERCANDIES_LOADINGPROGRESS =
      "fluttercandies://loadingprogress";

  /// MainPage
  ///
  /// [name] : fluttercandies://mainpage
  /// [routeName] : MainPage
  static const String FLUTTERCANDIES_MAINPAGE = "fluttercandies://mainpage";

  /// "show how to paint any thing before/after image is painted"
  ///
  /// [name] : fluttercandies://paintimage
  /// [routeName] : paint image
  /// [description] : "show how to paint any thing before/after image is painted"
  static const String FLUTTERCANDIES_PAINTIMAGE = "fluttercandies://paintimage";

  /// "show how to zoom/pan image in page view like WeChat"
  ///
  /// [name] : fluttercandies://photoview
  /// [routeName] : photo view
  /// [description] : "show how to zoom/pan image in page view like WeChat"
  static const String FLUTTERCANDIES_PHOTOVIEW = "fluttercandies://photoview";

  /// PicSwiper
  ///
  /// [name] : fluttercandies://picswiper
  /// [routeName] : PicSwiper
  /// [arguments] : [index, pics, tuChongItem]
  /// [showStatusBar] : false
  /// [pageRouteType] : PageRouteType.transparent
  static const String FLUTTERCANDIES_PICSWIPER = "fluttercandies://picswiper";

  /// "show how to zoom/pan image"
  ///
  /// [name] : fluttercandies://zoomimage
  /// [routeName] : image zoom
  /// [description] : "show how to zoom/pan image"
  static const String FLUTTERCANDIES_ZOOMIMAGE = "fluttercandies://zoomimage";
}
