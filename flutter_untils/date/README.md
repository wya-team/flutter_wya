# date

时间工具类.

## API

> 获取当前时间
```
getNow() -> DateTime
```

> 获取当前时间戳(13位，毫秒级)
```
getNowTimeStamp() -> int
```

> 时间戳转日期
```
timeStampToDate() -> String
```

> 拼接成date
```
dentistAppointment(int year,
      [int month, int day, int hour, int minute, int second]) -> DateTime
```

> 时间比较 -- 在之前
```
isBefore(DateTime dateTime) -> bool
```

> 时间比较 -- 在之后
```
isAfter(DateTime dateTime) -> bool
```

> 时间比较 -- 相同
```
isAtSameMomentAs(DateTime dateTime) -> bool
```

> 时间增加 dateBase + duration
```
fiftyDaysFromNow(DateTime dateBase, Duration duration) -> DateTime
```

> 时间减少 dateBase - duration
```
fiftyDaysAgo(DateTime dateBase, Duration duration) -> DateTime
```

> 比较两个时间 差 小时数
```
compare(DateTime before, DateTime after) -> Duration
```

> 获取年
```
getYear() -> String
```

> 获取月
```
getMonth() -> String
```

> 获取日
```
getDay() -> String
```

> 获取时
```
getHour() -> String
```

> 获取分
```
getMinute() -> String
```

> 获取秒
```
getSecond() -> String
```

> 获取星期几
```
getWeekDay() -> String
```

> 格式化时间戳

> TimeStamp:毫秒值

> format:[yyyy, '-', mm, '-', dd],[yyyy, '年', mm, '月', dd, '日],

> 结果： 2019?08?04  02?08?02
```
getFormatDate(int timeStamp, [List<String> formats]) -> String
```

Formats|样式
---|---
YMD_HMS|1993-04-28 05:16:51
YMD|1993-04-28
YMD_CHINESS|1993年04月28日
HMS|05:16:51
HMS_CHINESS|05时16分51秒
YMD_HMS_CHINESS|1993年04月28日 05时16分51秒
YMD_CHINESS_HMS|1993年04月28日 05:16:51
