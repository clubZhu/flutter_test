import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_model.dart';
import '../models/user_model.dart';

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
                  '示例 2: 多 Provider 协同',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange.shade700,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),

            // 同时监听两个 Provider
            Consumer2<CartModel, UserModel>(
              builder: (context, cart, user, child) {
                print('🛒 Consumer2<CartModel, UserModel> 重建');
                return Column(
                  children: [
                    // 用户信息
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '用户: ${user.name} (Lv.${user.level})',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.blue.shade700,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.arrow_upward),
                            onPressed: user.levelUp,
                            tooltip: '升级',
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 购物车信息
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '购物车: ${cart.itemCount} 件商品',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.orange.shade700,
                            ),
                          ),
                          if (cart.itemCount > 0)
                            IconButton(
                              icon: const Icon(Icons.delete_outline),
                              onPressed: cart.clear,
                              tooltip: '清空',
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // 商品列表
                    if (cart.items.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          '购物车为空',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 14,
                          ),
                        ),
                      )
                    else
                      Container(
                        constraints: const BoxConstraints(maxHeight: 150),
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: cart.items.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(cart.items[index]),
                              trailing: IconButton(
                                icon: const Icon(Icons.remove_circle),
                                onPressed: () => cart.removeItem(index),
                              ),
                            );
                          },
                        ),
                      ),
                    const SizedBox(height: 12),

                    // 添加商品按钮
                    Wrap(
                      spacing: 8,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => cart.addItem('苹果'),
                          icon: const Icon(Icons.add),
                          label: const Text('苹果'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => cart.addItem('香蕉'),
                          icon: const Icon(Icons.add),
                          label: const Text('香蕉'),
                        ),
                        ElevatedButton.icon(
                          onPressed: () => cart.addItem('橙子'),
                          icon: const Icon(Icons.add),
                          label: const Text('橙子'),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
