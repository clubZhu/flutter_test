import 'package:flutter/foundation.dart';

/// 计数器模型 - 使用 ChangeNotifier
///
/// Provider 原理：
/// 1. Provider 基于 InheritedWidget 实现，提供更简洁的 API
/// 2. ChangeNotifier 通过 notifyListeners() 通知监听者
/// 3. ChangeNotifierProvider 会自动管理监听器的注册和注销
/// 4. 当 notifyListeners() 被调用时，依赖的 Widget 会重建
class CounterModel extends ChangeNotifier {
  int _counter = 0;

  int get counter => _counter;

  void increment() {
    _counter++;
    print('📢 CounterModel: notifyListeners() 被调用, counter = $_counter');
    notifyListeners(); // 通知所有监听者（依赖的 Widget 会重建）
  }

  void decrement() {
    _counter--;
    print('📢 CounterModel: notifyListeners() 被调用, counter = $_counter');
    notifyListeners();
  }

  void reset() {
    _counter = 0;
    print('📢 CounterModel: notifyListeners() 被调用, counter = $_counter');
    notifyListeners();
  }

  @override
  void dispose() {
    print('🗑️ CounterModel: dispose 被调用');
    super.dispose();
  }
}
