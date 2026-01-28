import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/models.dart';
import 'widgets/widgets.dart';

/// Provider 测试主页面
class ProviderTestPage extends StatelessWidget {
  const ProviderTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    print('🏠 ProviderTestPage 重建');

    // 使用 MultiProvider 提供多个状态
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider: 创建并管理 ChangeNotifier
        ChangeNotifierProvider(create: (_) => CounterModel()),
        ChangeNotifierProvider(create: (_) => CartModel()),
        ChangeNotifierProvider(create: (_) => UserModel()),
      ],
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('Provider 状态管理测试'),
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              // Provider 原理说明
              ProviderExplanation(),

              // 计数器示例
              CounterSection(),

              // 购物车示例
              CartSection(),

              // 性能优化示例
              PerformanceSection(),

              // 底部说明
              BottomInfo(),
            ],
          ),
        ),
      ),
    );
  }
}
