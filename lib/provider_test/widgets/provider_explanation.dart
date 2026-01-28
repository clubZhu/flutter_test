import 'package:flutter/material.dart';

/// Provider 原理说明卡片
class ProviderExplanation extends StatelessWidget {
  const ProviderExplanation({super.key});

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
          colors: [Colors.blue.shade400, Colors.blue.shade600],
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
                'Provider 原理',
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
            '• 基于 InheritedWidget 实现，提供更简洁的 API\n'
            '• ChangeNotifier 通过 notifyListeners() 通知变化\n'
            '• Provider 自动管理监听器的注册和注销\n'
            '• context.watch / context.read / Consumer 三种访问方式\n'
            '• Selector 可精确控制重建范围（性能优化）',
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
