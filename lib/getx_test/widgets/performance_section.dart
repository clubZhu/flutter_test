import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/counter_controller.dart';

/// 性能优化示例区域
class PerformanceSection extends StatelessWidget {
  const PerformanceSection({super.key});

  @override
  Widget build(BuildContext context) {
    print('⚡ PerformanceSection 重建');

    final controller = Get.find<CounterController>();

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
              '精确控制更新范围:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 12),

            // 只监听 counter 的奇偶性
            Obx(() {
              final isEven = controller.counter.isEven;
              print('⚡ Obx (isEven) 重建, isEven = $isEven');
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
            }),
            const SizedBox(height: 16),

            // 不监听状态的 Widget
            const _StaticWidget(),
          ],
        ),
      ),
    );
  }
}

/// 静态 Widget - 不监听状态
class _StaticWidget extends StatelessWidget {
  const _StaticWidget();

  @override
  Widget build(BuildContext context) {
    // 使用 Get.find 不会建立监听关系
    final controller = Get.find<CounterController>();
    final snapshot = controller.counter;

    print('📦 _StaticWidget 重建（不监听状态变化）, counter = $snapshot');

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
            '使用 Get.find 读取数据\n'
            '不会因计数器变化而重建\n'
            '当前计数: $snapshot（读取时快照）',
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
