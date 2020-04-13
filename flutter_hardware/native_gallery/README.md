## 使用时需获取各平台对应的权限
- iOS
```
<key>NSPhotoLibraryUsageDescription</key>
<string>打开相册</string>
```

```
/// 打开相册
  /// maxSelectCount：选择的最大值
  /// sortAscending：是否升序排列
  /// allowSelectImage：是否允许选择图片
  /// allowSelectVideo：是否允许选择视频
  /// allowSelectOriginal：是否允许选择原图
  /// allowEditImage：是否可以编辑图片
  /// allowEditVideo：是否可以编辑视频
  /// canTakePicture：是否可以拍照
  /// allowChoosePhotoAndVideo：是否可以同时选中图片和视频
  /// maxEditVideoTime：编辑视频时最大裁剪时间
  /// maxVideoDuration：允许选择视频的最大时长
  /// iosExportVideoType：录制视频及编辑视频时候的视频导出格式
  ///
  /// 返回时应返回map类型
  /// 键：
  /// images:对应base64图片的数组
  /// videos：对应视频路径的数组, 导出视频时会把视频的预览图加入在images中
  static Future<Map<dynamic, dynamic>> openAlbum({
    int maxSelectCount = 1,
    bool sortAscending = false,
    bool allowSelectImage = true,
    bool allowSelectVideo = true,
    bool allowSelectOriginal = false,
    bool allowEditImage = false,
    bool allowEditVideo = false,
    bool canTakePicture = false,
    bool allowChoosePhotoAndVideo = true,
    int maxEditVideoTime = 10,
    int maxVideoDuration = 10,
    IOSExportVideoType iosExportVideoType = IOSExportVideoType.mov,
  }) 
```