import 'package:get/get.dart';
import '../controllers/controllers.dart';

/// GetX 测试页面的 Binding
///
/// Binding 的作用：
/// 1. 依赖注入 - 在页面加载前创建 Controller
/// 2. 内存管理 - 页面销毁时自动释放 Controller
/// 3. 解耦 - 页面与 Controller 分离
class GetxTestBinding extends Bindings {
  @override
  void dependencies() {
    print('🔗 GetxTestBinding: 注入依赖');

    // 懒加载 Controller - 只在首次使用时创建
    Get.lazyPut<CounterController>(() => CounterController());
    Get.lazyPut<CartController>(() => CartController());
    Get.lazyPut<UserController>(() => UserController());
  }
}
