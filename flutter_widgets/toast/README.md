## Toast

```
static Future<bool> showToast(
    String msg, {
    int time = 2,
    double fontSize = 16.0,
    ToastGravity gravity = ToastGravity.BOTTOM,
    Color backgroundColor,
    Color textColor,
    bool iosTouchBgDismiss = false,
  })
```

| property        | description                                                        | default    |
| --------------- | ------------------------------------------------------------------ |------------|
| msg             | String (Not Null)(required)，toast中显示的信息                                        |required    |
| time     | int                |2，要显示的时间长度 |
| gravity         | ToastGravity.TOP (or) ToastGravity.CENTER (or) ToastGravity.BOTTOM (Web Only supports top, bottom)。toast在屏幕中的位置 | ToastGravity.BOTTOM    |
| bgcolor         | Colors.red。toast的背景颜色                                                         |Colors.black    |
| textcolor       | Colors.white。显示的字体颜色                                                       |Colors.white    |
|iosTouchBgDismiss| 是否可以用户手动取消，ios端字段| false
### To cancel all the toasts call

```
/// 取消toast提示
/// ios端不支持
CustomToast.cancelToast()
```


## Loading

```
static Future<bool> showLoading({
    String msg = '',
    int status = 0,
    bool canceledOnTouchOutside = false,
    bool cancelable = false,
  }) 
```

| property        | description                                                        | default    |
| --------------- | ------------------------------------------------------------------ |------------|
| msg             | 显示文字，londing框显示的文字                                      |''    |
| status         | 0 加载中， 1 成功， -1 失败 -2 警告| 0  |
| cancelable         | 返回按钮点击隐藏。ios端不支持                                                           |false    |
| canceledOnTouchOutside       | 空白部分点击隐藏，                                                |false  |

### To cancel all the toasts call

```
/// 取消loading框
CustomToast.cancelLoading()
```
