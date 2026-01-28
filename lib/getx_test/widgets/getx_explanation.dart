import 'package:flutter/material.dart';

/// GetX 原理说明卡片
class GetxExplanation extends StatelessWidget {
  const GetxExplanation({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.teal.shade400, Colors.teal.shade600],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.info_outline, color: Colors.white, size: 28),
              SizedBox(width: 8),
              Text(
                'GetX 原理',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '• 使用 GetxController 管理状态和业务逻辑\n'
            '• 使用 .obs 创建响应式变量，自动更新 UI\n'
            '• GetX/Obx/GetBuilder 三种响应式方式\n'
            '• 无需 BuildContext 即可访问状态\n'
            '• Binding 管理依赖注入和生命周期\n'
            '• 自动内存管理，防止内存泄漏',
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
