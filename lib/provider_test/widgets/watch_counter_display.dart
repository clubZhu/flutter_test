import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/counter_model.dart';

/// 使用 context.watch 的计数器显示
class WatchCounterDisplay extends StatelessWidget {
  const WatchCounterDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    // context.watch 会让 Widget 监听模型变化
    final counter = context.watch<CounterModel>();
    print('👀 context.watch<CounterModel> 重建, counter = ${counter.counter}');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '当前计数 (watch):',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.deepPurple.shade700,
            ),
          ),
          Text(
            '${counter.counter}',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
