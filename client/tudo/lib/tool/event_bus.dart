// ignore_for_file: non_constant_identifier_names

import 'package:event_bus/event_bus.dart';

/// 单例
var CusBus = Bus.ins;

//订阅者回调
typedef EventCallback = void Function(Map<String, dynamic> args);

class Bus {
  Bus._();

  static final Bus ins = Bus._();

  //保存事件订阅者队列，key:事件名(id)，value: 对应事件的订阅者队列
  final _eMap = <Object, List<EventCallback>?>{};

  // 添加订阅者
  void on(eventName, EventCallback? f) {
    if (eventName == null || f == null) return;
    _eMap[eventName] ??= <EventCallback>[];
    _eMap[eventName]?.add(f);
  }

  // 移除订阅者
  void off(eventName, [EventCallback? f]) {
    var list = _eMap[eventName];
    if (eventName == null || list == null) return;
    if (f == null) {
      _eMap[eventName] = null;
    } else {
      list.remove(f);
    }
  }

  // 触发事件
  void emit({required String eventName, Map<String, dynamic>? args}) {
    var list = _eMap[eventName];
    if (list == null) return;
    int len = list.length - 1;
    for (var i = len; i > -1; --i) {
      // 反向遍历
      list[i].call(args ?? {});
    }
  }
}

class DmEventBus {
  static DmEventBus? _instance;

  EventBus eventBus = EventBus();

  DmEventBus._internal();

  factory DmEventBus.getDefault() {
    return _instance ??= DmEventBus._internal();
  }

  on<T>(Function(T event)? onData) {
    return eventBus.on<T>().listen((event) {
      onData!(event);
    });
  }

  post(event) {
    eventBus.fire(event);
  }
}
