## API

- *Cache*

##### iOS/Android

- iOS:获取系统某个路径下的内存大小，iOS下必传path
- android:获取应用所有缓存大小并格式化,返回String,带单位，path不传
```
systemCache({String path}) -> Future<String>
```

- iOS: 清除某个路径下的缓存，iOS下必传 
- android: 清楚应用所有缓存，path不传 
``` 
clearCache({String path}) -> Future<bool>
```

- 获取剩余可用空间
```
availableSpace() -> Future<String>
```

- 获取设备所有储存空间
```
deviceCacheSpace() -> Future<String>
```

- 保存图片到相册或者本地路径 
``` 
/// data：数据流
/// path：路径
/// saveProjectNameAlbum：是否保存在自定义相册。如果customAlbum没有值时，会自动创建以项目名称为相册名
/// customAlbum：自定义相册名字
/// 
/// 返回值是Map,包含isSuccess，result，imagePath
/// isSuccess:表示是否成功，bool值
/// result：成功或者失败信息，String
/// imagePath: 保存在相册时的路径，String
saveImage(Uint8List data,
      {String path, bool saveProjectNameAlbum, String customAlbum}) -> Future<dynamic>
```

- 保存视频到相册 
```
/// path：路径
/// saveProjectNameAlbum：是否保存在自定义相册。如果customAlbum没有值时，会自动创建以项目名称为相册名
/// customAlbum：自定义相册名字
///
/// isSuccess:表示是否成功，bool值
/// result：成功或者失败信息，String
/// videoPath: 保存在相册时的路径，String
saveVideo(String videoPath,
      {bool saveProjectNameAlbum, String customAlbum}) -> Future<dynamic>
```
#### iOS

#### Android

---

- ShardPreferences

##### iOS/Android
> 按键值对进行本地存储。T class is [bool, int, double, String, List<String>]
```
localSave<T>(String key, T value) -> Void
```

> 根据键获取值
```
localGet(String key) -> Future<dynamic>
```