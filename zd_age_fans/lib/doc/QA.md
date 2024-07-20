## 问题记录

### Q: macos网络请求失败
A: [配置授权com.apple.security.network.client => true](https://flutter.cn/docs/development/platform-integration/macos/building)

### Q: pageView页面保活
A: [可滚动组件子项缓存](https://book.flutterchina.club/chapter6/keepalive.html#_6-8-1-automatickeepalive)

```dart
import 'package:flukit/flukit.dart';

KeepAliveWrapper(child: HomePage())
```

### Q: tabbar widgets require a materail widget ancestor
A: [How to Solve ʺNo Material widget foundʺ Error in Flutter](https://www.fluttercampus.com/guide/190/how-to-solve-no-meterial-widget-found-error-in-flutter/)

```dart
Material(
  child: CustomTabbarView()
)
```

### Q: 对函数判空处理

```dart
final void Function()? click;

widget.click?.call();
```

### 参考

- [chewie视频播放器使用](https://www.cnblogs.com/xbinbin/p/17916328.html)