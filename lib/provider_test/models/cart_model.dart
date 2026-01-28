import 'package:flutter/foundation.dart';

/// 购物车模型 - 展示多个 Provider 的使用
class CartModel extends ChangeNotifier {
  final List<String> _items = [];

  List<String> get items => List.unmodifiable(_items);

  int get itemCount => _items.length;

  void addItem(String item) {
    _items.add(item);
    print('🛒 CartModel: 添加商品 "$item", 总数: ${_items.length}');
    notifyListeners();
  }

  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      final removed = _items.removeAt(index);
      print('🛒 CartModel: 移除商品 "$removed", 总数: ${_items.length}');
      notifyListeners();
    }
  }

  void clear() {
    _items.clear();
    print('🛒 CartModel: 清空购物车');
    notifyListeners();
  }
}
