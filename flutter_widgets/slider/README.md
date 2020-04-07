# Slider

## SliderAPI解释

名字 | 类型 | 默认值 | 解释
--- | --- | --- | ---
height | double | 2 | 线条宽度
width | double | - | 必需参数，slider宽度
min | int | - | 最小值
max | int | - |最大值
valueChanged | ValueChanged | - | 当slider发生滑动时调用
unselectedColor | Color | white | 未选中的颜色
selectedColor | Color | blue | 滑动选中的颜色
handlerBorderWidth | double | 2 | 操作球的边框宽度
selectedValue | double | 0 | 当前滑块已选中的值

## 示例

```dart
_getSlider() {
    return CustomSlider(
      width: 300,
      min: 0,
      max: 100,
      selectedValue: 40,
      valueChanged: (value) {
        print('当前进度$value%');
      },
    );
  }
```
