import 'package:get/get.dart';

/// 用户控制器
class UserController extends GetxController {
  // 响应式变量
  final RxString _name = 'Guest'.obs;
  final RxInt _level = 1.obs;

  // Getter
  String get name => _name.value;
  int get level => _level.value;

  // 更新名字
  void updateName(String name) {
    _name.value = name;
    print('👤 UserController: 更新名字为 "$name"');
  }

  // 升级
  void levelUp() {
    _level.value++;
    print('👤 UserController: 升级到等级 ${_level.value}');
  }

  @override
  void onInit() {
    super.onInit();
    print('🔄 UserController: onInit');
  }

  @override
  void onClose() {
    print('🗑️ UserController: onClose');
    super.onClose();
  }
}
