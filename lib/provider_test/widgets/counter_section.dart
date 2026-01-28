import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/counter_model.dart';
import 'control_button.dart';
import 'watch_counter_display.dart';

/// 计数器示例区域
class CounterSection extends StatelessWidget {
  const CounterSection({super.key});

  @override
  Widget build(BuildContext context) {
    print('🔢 CounterSection 重建');

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.calculate, color: Colors.purple.shade700),
                const SizedBox(width: 8),
                Text(
                  '示例 1: 基础计数器',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.purple.shade700,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // 使用 Consumer 监听变化
            const Text(
              'Consumer 方式（推荐用于小范围重建）:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            Consumer<CounterModel>(
              builder: (context, counter, child) {
                print('🎯 Consumer<CounterModel> 重建, counter = ${counter.counter}');
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.purple.shade200),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${counter.counter}',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.purple.shade700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ControlButton(
                            icon: Icons.remove,
                            color: Colors.red,
                            onPressed: counter.decrement,
                          ),
                          const SizedBox(width: 16),
                          ControlButton(
                            icon: Icons.refresh,
                            color: Colors.grey,
                            onPressed: counter.reset,
                          ),
                          const SizedBox(width: 16),
                          ControlButton(
                            icon: Icons.add,
                            color: Colors.green,
                            onPressed: counter.increment,
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // 使用 context.watch 方式
            const Text(
              'context.watch 方式（Flutter 10.2+ 推荐）:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),
            const WatchCounterDisplay(),
          ],
        ),
      ),
    );
  }
}
