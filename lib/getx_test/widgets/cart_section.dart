import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/user_controller.dart';

/// 购物车示例区域
class CartSection extends StatelessWidget {
  const CartSection({super.key});

  @override
  Widget build(BuildContext context) {
    print('🛒 CartSection 重建');

    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.shopping_cart, color: Colors.orange.shade700),
                const SizedBox(width: 8),
                Text(
                  '示例 2: 多 Controller 协同',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // 同时监听两个 Controller
            Row(
              children: [
                Expanded(child: _UserInfoCard()),
                const SizedBox(width: 12),
                Expanded(child: _CartInfoCard()),
              ],
            ),
            const SizedBox(height: 12),

            _CartItemList(),
            const SizedBox(height: 12),

            _AddItemButtons(),
          ],
        ),
      ),
    );
  }
}

/// 用户信息卡片
class _UserInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userController = Get.find<UserController>();

    return Obx(() {
      print('👤 _UserInfoCard 重建');
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.blue.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              '用户: ${userController.name}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Lv.${userController.level}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.arrow_upward),
                  onPressed: userController.levelUp,
                  tooltip: '升级',
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}

/// 购物车信息卡片
class _CartInfoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Obx(() {
      print('🛒 _CartInfoCard 重建');
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.orange.shade50,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Text(
              '购物车',
              style: TextStyle(
                fontSize: 14,
                color: Colors.orange.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${cartController.itemCount}',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade700,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '件',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
            if (cartController.itemCount > 0)
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: cartController.clear,
                tooltip: '清空',
              ),
          ],
        ),
      );
    });
  }
}

/// 商品列表
class _CartItemList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Obx(() {
      print('📋 _CartItemList 重建');
      if (cartController.items.isEmpty) {
        return Container(
          padding: const EdgeInsets.all(24),
          child: Text(
            '购物车为空',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
        );
      }

      return Container(
        constraints: const BoxConstraints(maxHeight: 150),
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: cartController.items.length,
          itemBuilder: (context, index) {
            return ListTile(
              title: Text(cartController.items[index]),
              trailing: IconButton(
                icon: const Icon(Icons.remove_circle),
                onPressed: () => cartController.removeItem(index),
              ),
            );
          },
        ),
      );
    });
  }
}

/// 添加商品按钮
class _AddItemButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();

    return Wrap(
      spacing: 8,
      children: [
        ElevatedButton.icon(
          onPressed: () => cartController.addItem('苹果'),
          icon: const Icon(Icons.add),
          label: const Text('苹果'),
        ),
        ElevatedButton.icon(
          onPressed: () => cartController.addItem('香蕉'),
          icon: const Icon(Icons.add),
          label: const Text('香蕉'),
        ),
        ElevatedButton.icon(
          onPressed: () => cartController.addItem('橙子'),
          icon: const Icon(Icons.add),
          label: const Text('橙子'),
        ),
      ],
    );
  }
}
