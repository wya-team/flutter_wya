#  Searchbar

## 相关属性介绍

属性名称 | 类型 | 默认值 | 备注 | 注释
---| ---| ---|---|---|
enabled | bool | true | 该属性暂未使用 | 用来控制是否允许输入
hideLeft | bool | - | 可以不传值，默认隐藏 | 是否显示左侧返回按钮
isNeedPushCenter | bool | false | 如果中间类型搜索框需要跳转需要设置isNeedPushCenter属性为tru | 中间样式的搜索框是否需要点击跳转
searchBarType | enum | normal | center, normal, cancel三种类型 | 用于配置需要显示哪种类型的搜索框
hint | String | - | 可不传默认赋值"搜索" | 占位文字
defaultText | String | - | | 默认输入的文字 |
leftButtonClick | Function | - | | 左侧返回按钮点击事件
rightButtonClick | Function | - | | 右侧取消按钮点击事件
inputBoxClick | Function | - | 如果中间类型搜索框需要跳转需要设置isNeedPushCenter属性为true | 输入框点击事件
onChanged | Function | - | 内容改变即可出发该方法 | 左侧返回按钮点击事件
inputBoxColor | Color | Colors.white | | 输入框背景色颜色
searchIconColor | Color | Colors.grey | | 搜索图标的颜色
height | double | 32 | | 输入框高度
borderRadius | double | 5 | 输入框圆角值

## 用法示例

```dart
Widget _getWidget(){
    return  Column(
      children: <Widget>[
        SearchBar(
          searchBarType: SearchBarType.center,
          hint: '搜索居中',
          onChanged: (text){
            print('中间搜索框输入内容：$text');
          },
        ),
        SearchBar(
          searchBarType: SearchBarType.normal,
          hint: '搜索左侧',
          inputBoxColor: Colors.blue,
          onChanged: (text){
            print('普通搜索框输入内容：$text');
          },
        ),
        SearchBar(
          searchBarType: SearchBarType.cancel,
          hint: '搜索+取消',
          onChanged: (text){
            print('取消搜索框输入内容：$text');
          },
        ),
      ],
    );
  }
```
