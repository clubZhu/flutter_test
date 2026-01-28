import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/counter_model.dart';
import 'static_widget.dart';

/// 性能优化示例区域
class PerformanceSection extends StatelessWidget {
  const PerformanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    print('⚡ PerformanceSection 重建');
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.speed, color: Colors.green.shade700),
                const SizedBox(width: 8),
                Text(
                  '示例 3: 性能优化',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            const Text(
              'Selector: 只监听特定字段的变化',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),

            // Selector 只监听 counter 的奇偶性，只有奇偶性变化时才重建
            Selector<CounterModel, bool>(
              selector: (context, counter) => counter.counter.isEven,
              builder: (context, isEven, child) {
                print('⚡ Selector<CounterModel, bool> 重建, isEven = $isEven');
                return Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isEven ? Colors.green.shade50 : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isEven ? Colors.green.shade200 : Colors.red.shade200,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isEven ? Icons.filter_2 : Icons.looks_one,
                        color: isEven ? Colors.green.shade700 : Colors.red.shade700,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        isEven ? '当前是偶数' : '当前是奇数',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isEven ? Colors.green.shade700 : Colors.red.shade700,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 16),

            // 不依赖状态的 Widget（用于对比）
            const StaticWidget(),
          ],
        ),
      ),
    );
  }
}
