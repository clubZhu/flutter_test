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
                'Provider 使用要点',
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
            '1. context.watch<T>() - 在 build 中使用，建立监听关系\n'
            '2. context.read<T>() - 不建立监听，用于回调中读取数据\n'
            '3. Consumer<T> - 优化重建范围，只重建子组件\n'
            '4. Selector<T, R> - 精确监听特定字段，性能优化\n'
            '5. Provider.of<T>(context, listen: false) - 等同于 context.read\n\n'
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
