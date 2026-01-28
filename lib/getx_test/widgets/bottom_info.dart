import 'package:flutter/material.dart';

/// 底部信息卡片
class BottomInfo extends StatelessWidget {
  const BottomInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.amber.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.amber.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.amber.shade700),
              const SizedBox(width: 8),
              Text(
                'GetX 使用要点',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.amber.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '1. GetX<T> - 精确控制，可指定何时更新\n'
            '2. Obx() - 最简洁，自动追踪 .obs 变量\n'
            '3. GetBuilder<T> - 手动更新，性能最好\n'
            '4. Get.find<T>() - 不建立监听，只读数据\n'
            '5. 无需 BuildContext - 全局访问状态\n'
            '6. Binding - 管理依赖注入和生命周期\n\n'
            '查看控制台日志，了解各组件的重建时机！',
            style: TextStyle(
              fontSize: 13,
              height: 1.6,
              color: Colors.amber.shade900,
            ),
          ),
        ],
      ),
    );
  }
}
