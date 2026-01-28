import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'bindings/bindings.dart';
import 'widgets/widgets.dart';

/// GetX 测试主页面
class GetxTestPage extends StatelessWidget {
  const GetxTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    print('🏠 GetxTestPage 重建');

    return GetMaterialApp(
      // 使用 Binding 进行依赖注入
      initialBinding: GetxTestBinding(),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text('GetX 状态管理测试'),
        ),
        body: const SingleChildScrollView(
          child: Column(
            children: [
              // GetX 原理说明
              GetxExplanation(),

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
