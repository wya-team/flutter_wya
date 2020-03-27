## API

- *Cache*

##### iOS/Android

> iOS:获取系统某个路径下的内存大小，iOS下必传path
> android:获取应用所有缓存大小并格式化,返回String,带单位，path不传
```
systemCache({String path}) -> Future<String>
```

> iOS: 清除某个路径下的缓存，iOS下必传
> android: 清楚应用所有缓存，path不传
```
clearCache({String path}) -> Future<bool>
```

> 获取剩余可用空间
```
availableSpace() -> Future<String>
```

> 获取设备所有储存空间
```
deviceCacheSpace() -> Future<String>
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