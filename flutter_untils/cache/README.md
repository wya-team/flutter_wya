## API

- *Cache*

##### iOS/Android

> 获取系统某个路径下的内存大小
```
systemCache(String path) -> Future<String>
```

> 清除某个路径下的缓存
```
clearCache(String path) -> Future<bool>
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