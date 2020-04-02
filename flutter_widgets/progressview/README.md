# progressview

圆型进度条

### 参数
参数|类型|含义|必传
---|---|---|---
strokeWidth|double|粗细|否
radius|double|圆的半径|是
colors|List|渐变色数组|否
strokeCapRound|bool|两端是否为圆角|否
backgroundColor|Color|进度条背景色|否
totalAngle|double|进度条的总弧度，2*PI为整圆，小于2*PI则不是整圆|否
value|double|当前进度，取值范围 [0.0-1.0]|否

### 使用
```
ProgressViewWidget(
          colors: [
            Colors.red,
            Colors.amber,
            Colors.cyan,
            Colors.green[200],
            Colors.blue,
            Colors.red
          ],
          radius: 100.0,
          strokeWidth: 8.0,
          strokeCapRound: true,
          value: 0.9,
          totalAngle: 1 * pi
        ),
```
 
