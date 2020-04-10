## Toast

```dart
 CustomToast.showToast(
      msg: "This is Short Toast",
      time:0,
      gravity: ToastGravity.CENTER,
      backgroundColor: Colors.black,
      textColor: Colors.white,
    );
```

| property        | description                                                        | default    |
| --------------- | ------------------------------------------------------------------ |------------|
| msg             | String (Not Null)(required)                                        |required    |
| time     | int                |0 |
| gravity         | ToastGravity.TOP (or) ToastGravity.CENTER (or) ToastGravity.BOTTOM (Web Only supports top, bottom) | ToastGravity.BOTTOM    |
| bgcolor         | Colors.red                                                         |Colors.black    |
| textcolor       | Colors.white                                                       |Colors.white    |

### To cancel all the toasts call

```dart
CustomToast.cancelToast()
```


## Loading

```dart
CustomToast.showLoading(
        msg: '加载中...', 
        cancelable: true, 
        canceledOnTouchOutside: true, 
        status:0);
```

| property        | description                                                        | default    |
| --------------- | ------------------------------------------------------------------ |------------|
| msg             | 显示文字                                      |加载中...    |
| status         | 0 加载中， 1 成功， -1 失败 | 0  |
| cancelable         | 返回按钮点击隐藏                                                     |false    |
| canceledOnTouchOutside       | 空白部分点击隐藏                                                      |false  |

### To cancel all the toasts call

```dart
CustomToast.cancelLoading()
```
