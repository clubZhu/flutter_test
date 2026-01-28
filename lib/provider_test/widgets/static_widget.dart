import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/counter_model.dart';

/// 静态 Widget - 不会因状态变化而重建
class StaticWidget extends StatelessWidget {
  const StaticWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // 使用 context.read 不会建立监听关系
    final counter = context.read<CounterModel>();
    print('📦 StaticWidget 重建（不监听状态变化）');

    return Container(
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
              Icon(Icons.block, color: Colors.grey.shade700),
              const SizedBox(width: 8),
              Text(
                '不监听状态的 Widget',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '使用 context.read 读取数据\n'
            '不会因计数器变化而重建\n'
            '当前计数: ${counter.counter}（读取时快照）',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
