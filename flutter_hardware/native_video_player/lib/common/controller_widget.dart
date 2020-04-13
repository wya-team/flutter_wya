import 'package:flutter/material.dart';
import 'package:native_video_player/video_player_widget/video_player_control.dart';
import 'package:video_player/video_player.dart';

typedef ScreenSwitching<bool> = Function(bool value);

///  共享数据
///
/// 本组件有三个控件，分别为控制按钮控件、手势滑动控件、视频播放控件
/// 这是三个控件以此嵌套默认填充满父控件。由于嵌套层数较多，层层传递属性有点麻烦
/// 因此创建InheritedWidget共享数据
class ControllerWidget extends InheritedWidget {
  ControllerWidget(
      {this.controlKey,
      this.child,
      this.controller,
      this.videoInit,
      this.title,
      this.screenSwitching});

  final String title;
  final GlobalKey<VideoPlayerControlState> controlKey;
  final Widget child;

  // 这个controller后面会常用，用于调用操作视频相关的api
  final VideoPlayerController controller;

  // video资源是否加载完成，加载完成后会获得总时长和视频长宽比等信息
  final bool videoInit;
  final ScreenSwitching screenSwitching;

  //定义一个便捷方法，方便子树中的widget获取共享数据
  static ControllerWidget of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ControllerWidget>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return false;
  }
}
