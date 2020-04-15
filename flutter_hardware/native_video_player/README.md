# native_video_player

可以播放三种类型的视频：网络、工程视频、本地视频

## API介绍

属性 | 类型 | 默认值 | 备注
--- | --- | --- | ---
url | String | - | 当前需要播放的地址
dataSource | String | - | asset需要播放的地址
file | File | - | file当前需要播放的地址
width | double | double.infinity | 播放器尺寸（大于等于视频播放区域）
height | double | double.infinity | 播放器尺寸（大于等于视频播放区域）
title | String | - | 用于横屏时展示在自定义的导航栏里
isAutoPlayer | bool | true | 进入界面自动播放
screenSwitching | function | - | 必须实现，在这里返回一个bool来隐藏appBar,横屏时需要隐藏appBar

## 用法

### 网络视频示例

```dart
import 'package:flutter/material.dart';
import 'package:native_video_player/video_player_widget/video_player_UI.dart';
class VideoPlayerPage extends StatefulWidget {
  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  bool _isShowAppBar = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isShowAppBar ? AppBar(
        title: Text('VidePlayer'),
        leading: BackButton(
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ): null,
      body: Column(
        children: [
          Container(
            child: VideoPlayerUI.network(
              screenSwitching: (value){
                setState(() {
                  _isShowAppBar = value;
                });
              },
              url: 'http://vfx.mtime.cn/Video/2019/02/04/mp4/190204084208765161.mp4',
              title: '《驯龙高手》',
              width: double.infinity,
              height: 180,
            ),
          )
        ],
      )
    );
  }
}
```

## asset类型示例

```
VideoPlayerUI.asset(
   dataSource:xx,
    width: xxx,
    height: double.infinity,
    title:'', // 视频需要显示的标题
    isAutoPlayer : true, // 是否需要自动播放
    screenSwitching(value){
        
    },
  )
```

## file类型示例

```
VideoPlayerUI.file(
   file:xx,
    width: xxx,
    height: double.infinity,
    title:'', // 视频需要显示的标题
    isAutoPlayer : true, // 是否需要自动播放
    screenSwitching(value){
        
    },
  )
```
