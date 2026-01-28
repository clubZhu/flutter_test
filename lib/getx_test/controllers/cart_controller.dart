import 'package:get/get.dart';

/// 购物车控制器
class CartController extends GetxController {
  // 响应式列表
  final RxList<String> _items = <String>[].obs;

  // Getter
  List<String> get items => _items;
  int get itemCount => _items.length;

  // 添加商品
  void addItem(String item) {
    _items.add(item);
    print('🛒 CartController: 添加商品 "$item", 总数: ${_items.length}');
  }

  // 移除商品
  void removeItem(int index) {
    if (index >= 0 && index < _items.length) {
      final removed = _items.removeAt(index);
      print('🛒 CartController: 移除商品 "$removed", 总数: ${_items.length}');
    }
  }

  // 清空购物车
  void clear() {
    _items.clear();
    print('🛒 CartController: 清空购物车');
  }

  @override
  void onInit() {
    super.onInit();
    print('🔄 CartController: onInit');
  }

  @override
  void onClose() {
    print('🗑️ CartController: onClose');
    super.onClose();
  }
}
