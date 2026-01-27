import 'package:flutter/material.dart';

/// 自定义 InheritedWidget 示例
///
/// InheritedWidget 原理：
/// 1. InheritedWidget 是 Flutter 中用于向下传递数据的特殊 Widget
/// 2. 它使用 Element 树中的 dependOnInheritedWidgetOfExactType 方法来建立依赖关系
/// 3. 当 InheritedWidget 的数据发生变化时，所有依赖它的子 Widget 都会重建
/// 4. 这种方式避免了层层传递 callback 的繁琐
class CounterProvider extends InheritedWidget {
  final int counter;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onReset;

  const CounterProvider({
    super.key,
    required this.counter,
    required this.onIncrement,
    required this.onDecrement,
    required this.onReset,
    required Widget child,
  }) : super(child: child);

  /// 静态方法，用于子 Widget 获取最近的一个 CounterProvider
  /// 这是使用 InheritedWidget 的标准模式
  static CounterProvider of(BuildContext context) {
    // dependOnInheritedWidgetOfExactType 会建立依赖关系
    // 当 CounterProvider 发生变化时，调用此方法的 Widget 会重建
    final CounterProvider? result =
        context.dependOnInheritedWidgetOfExactType<CounterProvider>();
    assert(result != null, 'No CounterProvider found in context');
    return result!;
  }

  /// 不建立依赖关系的方法（只读，不触发重建）
  static CounterProvider readWithoutDependence(BuildContext context) {
    // getInheritedWidgetOfExactType 不会建立依赖关系
    // 适用于只需要读取数据，不需要在数据变化时重建的情况
    final CounterProvider? result =
        context.getInheritedWidgetOfExactType<CounterProvider>();
    assert(result != null, 'No CounterProvider found in context');
    return result!;
  }

  /// 判断是否需要通知依赖的 Widget
  /// 返回 false 时，即使调用了 setState，依赖的 Widget 也不会重建
  @override
  bool updateShouldNotify(covariant CounterProvider oldWidget) {
    // 这里我们简单比较 counter 值
    // 如果 counter 没变，就不通知子 Widget 重建（性能优化）
    return counter != oldWidget.counter;
  }
}
class InheritedWidgetTestPage2 extends StatefulWidget {
  const InheritedWidgetTestPage2({super.key});

  @override
  State<InheritedWidgetTestPage2> createState() => _InheritedWidgetTestPage2State();
}

class _InheritedWidgetTestPage2State extends State<InheritedWidgetTestPage2> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    _logChange('增加');
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
    _logChange('减少');
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
    _logChange('重置');
  }

  void _logChange(String action) {
    print('🔄 Counter $action: $_counter');
  }
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

/// 主页面：包含 InheritedProvider 和子 Widget
class InheritedWidgetTestPage extends StatefulWidget {
  const InheritedWidgetTestPage({super.key});

  @override
  State<InheritedWidgetTestPage> createState() => _InheritedWidgetTestPageState();
}

class _InheritedWidgetTestPageState extends State<InheritedWidgetTestPage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
    _logChange('增加');
  }

  void _decrementCounter() {
    setState(() {
      _counter--;
    });
    _logChange('减少');
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
    });
    _logChange('重置');
  }

  void _logChange(String action) {
    print('🔄 Counter $action: $_counter');
  }

  @override
  Widget build(BuildContext context) {
    print('🏠 InheritedWidgetTestPage 重建 (counter: $_counter)');

    return CounterProvider(
      counter: _counter,
      onIncrement: _incrementCounter,
      onDecrement: _decrementCounter,
      onReset: _resetCounter,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('InheritedWidget 测试'),
        ),
        body: Column(
          children: [
            // 说明卡片
            Container(
              width: double.infinity,
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'InheritedWidget 原理',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '1. InheritedWidget 是一种特殊的数据传递机制\n'
                    '2. 使用 Element 树建立依赖关系\n'
                    '3. 数据变化时，依赖的子 Widget 自动重建\n'
                    '4. 避免了层层传递 callback\n'
                    '5. updateShouldNotify 决定是否通知子 Widget',
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ],
              ),
            ),

            // 计数器显示区域
            const CounterDisplay(),

            const SizedBox(height: 20),

            // 控制按钮区域
            const ControlButtons(),

            const SizedBox(height: 20),

            // 不依赖变化的 Widget 示例
            const IndependentWidget(),

            const Divider(height: 32),

            // 实时日志
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.terminal, color: Colors.grey.shade700),
                        const SizedBox(width: 8),
                        Text(
                          '重建日志 (查看控制台)',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '观察控制台输出，了解哪些 Widget 在何时重建：\n'
                      '• 父页面每次都会重建\n'
                      '• CounterDisplay 会重建（依赖数据）\n'
                      '• IndependentWidget 不会重建（不依赖数据）',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 显示计数的 Widget - 会依赖 CounterProvider
class CounterDisplay extends StatelessWidget {
  const CounterDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    // 使用 dependOnInheritedWidgetOfExactType 获取数据
    // 这会建立依赖关系，数据变化时此 Widget 会重建
    final provider = CounterProvider.of(context);

    print('📊 CounterDisplay 重建 (counter: ${provider.counter})');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.purple.shade400, Colors.purple.shade600],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.shade300,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '当前计数',
            style: TextStyle(
              fontSize: 16,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${provider.counter}',
            style: const TextStyle(
              fontSize: 72,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            provider.counter > 0 ? '正数' : (provider.counter < 0 ? '负数' : '零'),
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
          ),
        ],
      ),
    );
  }
}

/// 控制按钮 - 不需要依赖数据（只传递方法）
class ControlButtons extends StatelessWidget {
  const ControlButtons({super.key});

  @override
  Widget build(BuildContext context) {
    // 这个 Widget 只需要获取方法，不需要重建
    // 使用 getElementForInheritedWidgetOfExactType 不建立依赖
    final provider = CounterProvider.readWithoutDependence(context);

    print('🎮 ControlButtons 重建（不依赖数据变化）');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: provider.onDecrement,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade400,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Icon(Icons.remove, size: 28),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: provider.onReset,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade400,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Icon(Icons.refresh, size: 28),
        ),
        const SizedBox(width: 16),
        ElevatedButton(
          onPressed: provider.onIncrement,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green.shade400,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Icon(Icons.add, size: 28),
        ),
      ],
    );
  }
}

/// 独立的 Widget - 不依赖任何 InheritedWidget 数据
/// 用于对比：展示不依赖的 Widget 不会因为数据变化而重建
class IndependentWidget extends StatelessWidget {
  const IndependentWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 记录构建时间
    final buildTime = DateTime.now().toLocal().toString().substring(11, 19);

    print('🔵 IndependentWidget 重建（完全不依赖 CounterProvider）');

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.build, color: Colors.orange.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '独立 Widget（不依赖数据）',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '最后构建时间: $buildTime',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange.shade700,
                  ),
                ),
                Text(
                  '注意：此 Widget 不会因计数器变化而重建',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.orange.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
