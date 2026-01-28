import 'package:get/get.dart';

/// 计数器控制器
///
/// GetX 原理：
/// 1. 使用 GetxController 或 GetxService 管理状态
/// 2. 使用 .obs 创建响应式变量
/// 3. 使用 GetX<T>、Obx、GetBuilder 监听变化
/// 4. 自动管理内存，页面销毁时自动释放
/// 5. 无需 BuildContext 即可访问状态
class CounterController extends GetxController {
  // 响应式变量 - 使用 .obs
  final RxInt _counter = 0.obs;

  // 普通变量 - 不会触发更新
  int updateCount = 0;

  // Getter
  int get counter => _counter.value;

  // 增加
  void increment() {
    _counter.value++;
    updateCount++;
    print('📢 CounterController: increment, counter = ${_counter.value}');
    // 使用 .obs 的变量会自动通知监听者
  }

  // 减少
  void decrement() {
    _counter.value--;
    updateCount++;
    print('📢 CounterController: decrement, counter = ${_counter.value}');
  }

  // 重置
  void reset() {
    _counter.value = 0;
    updateCount++;
    print('📢 CounterController: reset, counter = ${_counter.value}');
  }

  @override
  void onInit() {
    super.onInit();
    print('🔄 CounterController: onInit');
  }

  @override
  void onReady() {
    super.onReady();
    print('✅ CounterController: onReady');
  }

  @override
  void onClose() {
    print('🗑️ CounterController: onClose');
    super.onClose();
  }
}
