import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/counter_controller.dart';
import 'control_button.dart';

/// 计数器示例区域
class CounterSection extends StatelessWidget {
  const CounterSection({super.key});

  @override
  Widget build(BuildContext context) {
    print('🔢 CounterSection 重建');

    return GetX<CounterController>(
      builder: (controller) {
        print('🎯 GetX<CounterController> 重建, counter = ${controller.counter}');
        return Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.calculate, color: Colors.teal.shade700),
                    const SizedBox(width: 8),
                    Text(
                      '示例 1: 基础计数器',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.teal.shade700,
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),

                // GetX 方式
                const Text(
                  'GetX 方式（精确控制）:',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.teal.shade200),
                  ),
                  child: Column(
                    children: [
                      Text(
                        '${controller.counter}',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade700,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ControlButton(
                            icon: Icons.remove,
                            color: Colors.red,
                            onPressed: controller.decrement,
                          ),
                          const SizedBox(width: 16),
                          ControlButton(
                            icon: Icons.refresh,
                            color: Colors.grey,
                            onPressed: controller.reset,
                          ),
                          const SizedBox(width: 16),
                          ControlButton(
                            icon: Icons.add,
                            color: Colors.green,
                            onPressed: controller.increment,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Obx 方式
                const ObxCounterDisplay(),
                const SizedBox(height: 16),

                // GetBuilder 方式
                const GetBuilderCounterDisplay(),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// 使用 Obx 的计数器显示
class ObxCounterDisplay extends StatelessWidget {
  const ObxCounterDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CounterController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Obx 方式（最简洁）:',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        Obx(() {
          print('👀 Obx 重建, counter = ${controller.counter}');
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.cyan.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.cyan.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '当前计数 (Obx):',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.cyan.shade700,
                  ),
                ),
                Text(
                  '${controller.counter}',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.cyan.shade700,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}

/// 使用 GetBuilder 的计数器显示
class GetBuilderCounterDisplay extends StatelessWidget {
  const GetBuilderCounterDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'GetBuilder 方式（手动更新）:',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        GetBuilder<CounterController>(
          builder: (controller) {
            print('🔧 GetBuilder 重建, counter = ${controller.counter}');
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '当前计数 (GetBuilder):',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.indigo.shade700,
                    ),
                  ),
                  Text(
                    '${controller.counter}',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade700,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
