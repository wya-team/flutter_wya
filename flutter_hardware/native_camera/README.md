## 写在使用之前的话
- iOS端需要在配置文件中加入 
``` 
<key>NSCameraUsageDescription</key>
<string>关于相机描述文字自己补充一下</string>
<key>NSMicrophoneUsageDescription</key>
<string>关于麦克风描述文字自己补充一下</string>
<key>NSPhotoLibraryAddUsageDescription</key>
<string>关于添加图片至相册</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>关于相册访问</string>
```

```
/// 打开照相机
/// cameraType：相机类型
/// cameraOrientation：摄像头朝向
/// time：拍摄时间长度
/// videoPreset：拍摄质量
/// saveAlbum：是否保存至相册
/// albumName：相册名称
///
/// 返回的数据应该是一个map
/// 键：
/// "imageBase64"：拍摄的图片数据
/// "imagePath": 拍摄的图片本地路径
/// "videoPath"：拍摄的视频的本地路径
static Future<Map<String, dynamic>> openCamera(
    {CameraType cameraType = CameraType.all,
    CameraOrientation cameraOrientation = CameraOrientation.back,
    int time = 15,
    VideoPreset videoPreset = VideoPreset.medium,
    bool saveAlbum = false,
    String albumName})
```