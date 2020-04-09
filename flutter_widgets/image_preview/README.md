# ImagePreview
```
ImagePreview({
    @required this.provider,
    @required this.itemCount,
    this.selectIndex = 0,
    this.modelCallback,
    this.downloadCallback,
    this.pageControlStyle = PageControlStyle.none,
    this.minZoomNumber = 1.0,
    this.maxZoomNumber = 3.0,
  })  : assert(provider != null),
        assert(itemCount != null || itemCount == 0);
```

属性|解释|默认值|类型 
---|---|---|--- 
provider|返回需要加载的图片资源，如果要加载网络资源请使用NetworkImage| |ImagePreviewProvider
itemCount| 资源个数 | | int
selectIndex| 默认选中的下标，在PageControlStyle.dots模式下使用 | 0 | int
modelCallback| 返回当前页面配置数据 | | ImagePreviewModel Function(int index)
downloadCallback| 下载按钮回调 | | Function(int index)
pageControlStyle| 图片预览器样式 | none | PageControlStyle
minZoomNumber | 图片最小缩放值 | 1.0 | double
maxZoomNumber | 图片最大缩放值 | 3.0 | double


## PageControlStyle
枚举值|解释 
---|---
none | 界面下方出现显示原图按钮，及下载按钮
dots | 显示小圆点样式的PageControl
numberPage | 页码指示器

## ImagePreviewModel
属性|解释|默认值|类型 
---|---|---|--- 
originalImageUrl| 原图url | | String
imageSize | 原图大小 | | String

