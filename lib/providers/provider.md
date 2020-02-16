
### dart
```
FutureProvider(
  create: (_) async => doSomeHttpRequest(),
  lazy: false,
  child: ...
)
lazy: true ,当读取值时才调用create/update 回调， false第一次provder 创建的时候
```
### 

- Selector默认深检测，可以使用shouldRebuild 自定义

- 创建model使用 create， 不要使用.value

### dart
```
Provider(
  create: (_) => new MyModel(),
  child: ...
)

dont
ChangeNotifierProvider.value(
  value: new MyModel(),
  child: ...
)
```
- 再利用 ChangeNotifier

### dart
```
MyChangeNotifier variable;

ChangeNotifierProvider.value(
  value: variable,
  child: ...
)
```

- ValueListenableProvider 单一数据源变化，数据变化时不需要调用notifyListeners