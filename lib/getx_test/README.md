# GetX 测试模块

## 目录结构

```
lib/getx_test/
├── controllers/                # 控制器层 (业务逻辑和状态管理)
│   ├── counter_controller.dart  # 计数器控制器
│   ├── cart_controller.dart     # 购物车控制器
│   ├── user_controller.dart     # 用户控制器
│   └── controllers.dart         # 统一导出
├── bindings/                    # 依赖注入层
│   ├── getx_test_binding.dart   # GetX 测试页面 Binding
│   └── bindings.dart            # 统一导出
├── pages/                       # 页面层
│   ├── getx_test_page.dart      # GetX 测试主页面
│   └── pages.dart               # 统一导出
├── widgets/                     # UI 组件层
│   ├── getx_explanation.dart    # GetX 原理说明卡片
│   ├── control_button.dart      # 控制按钮组件
│   ├── counter_section.dart     # 计数器示例区域
│   ├── cart_section.dart        # 购物车示例区域
│   ├── performance_section.dart # 性能优化示例区域
│   ├── bottom_info.dart         # 底部信息卡片
│   └── widgets.dart             # 统一导出
└── getx_test.dart              # 统一导出入口

```

## 使用方法

### 导入主页面
```dart
import 'package:flutter_architecture_test/getx_test/pages/getx_test_page.dart';

// 在路由中使用
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => GetxTestPage()),
);
```

### 导入所有内容
```dart
import 'package:flutter_architecture_test/getx_test/getx_test.dart';
```

### 单独导入
```dart
// Controllers
import 'package:flutter_architecture_test/getx_test/controllers/controllers.dart';

// Bindings
import 'package:flutter_architecture_test/getx_test/bindings/bindings.dart';

// Pages
import 'package:flutter_architecture_test/getx_test/pages/pages.dart';

// Widgets
import 'package:flutter_architecture_test/getx_test/widgets/widgets.dart';
```

## 功能说明

### Controllers (控制器)

GetX 使用 Controller 管理状态和业务逻辑，替代 Provider 的 ChangeNotifier。

#### CounterController
计数器控制器，演示基础的响应式状态管理
- 使用 `.obs` 创建响应式变量
- 自动通知 UI 更新
- 无需手动调用 notifyListeners()

#### CartController
购物车控制器，演示列表状态管理
- RxList 响应式列表
- 自动追踪列表变化

#### UserController
用户控制器，演示多个响应式变量
- RxString、RxInt 等响应式类型
- 多个状态的协同管理

### Bindings (依赖注入)

GetX 使用 Binding 管理依赖注入和生命周期。

#### GetxTestBinding
- 页面级别的依赖注入
- 使用 Get.lazyPut 懒加载 Controller
- 页面销毁时自动释放 Controller
- 解耦页面与 Controller

### Widgets (UI组件)

#### GetxExplanation
显示 GetX 的核心原理说明

#### CounterSection
示例 1：基础计数器
- **GetX<T>**: 精确控制更新时机
- **Obx()**: 最简洁的响应式写法
- **GetBuilder<T>**: 手动控制更新，性能最好

#### CartSection
示例 2：多 Controller 协同
- 同时使用多个 Controller
- Get.find<T>() 查找已注入的 Controller
- 展示购物车和用户信息的交互

#### PerformanceSection
示例 3：性能优化
- 精确控制更新范围
- Get.find vs Obx 的区别
- 展示不监听状态的组件

## GetX vs Provider 对比

| 特性 | Provider | GetX |
|------|---------|------|
| 状态管理 | ChangeNotifier | GetxController |
| 响应式变量 | 需要手动 notifyListeners() | .obs 自动更新 |
| 访问方式 | 需要 BuildContext | 无需 BuildContext |
| 依赖注入 | Provider/ChangeNotifierProvider | Binding/Get.put/lazyPut |
| 内存管理 | 手动管理 | 自动管理 |
| 代码简洁性 | 较繁琐 | 更简洁 |
| 性能 | 良好 | 优秀 |
| 学习曲线 | 中等 | 简单 |

## 三种响应式方式对比

### 1. GetX\<T\>
```dart
GetX<CounterController>(
  builder: (controller) => Text('${controller.counter}'),
)
```
- ✅ 精确控制何时更新
- ✅ 可以指定条件更新
- ✅ 初始化时也会执行
- ❌ 代码相对繁琐

### 2. Obx()
```dart
Obx(() => Text('${controller.counter}'))
```
- ✅ 最简洁
- ✅ 自动追踪 .obs 变量
- ❌ 无法精确控制
- ❌ 必须使用 .obs 变量

### 3. GetBuilder\<T\>
```dart
GetBuilder<CounterController>(
  builder: (controller) => Text('${controller.counter}'),
)
```
- ✅ 性能最好
- ✅ 手动控制更新 (update())
- ❌ 需要手动调用 update()
- ❌ 不支持 .obs 变量

## 架构设计

### 分层设计
```
Presentation Layer (Pages & Widgets)
         ↓
Business Logic Layer (Controllers)
         ↓
Data Layer (Models/Repositories)
```

### 文件组织原则
1. **单一职责** - 每个 Controller 只管理相关状态
2. **关注分离** - UI 与业务逻辑分离
3. **依赖注入** - 使用 Binding 管理 Controller 生命周期
4. **统一导出** - 使用 barrel 文件统一导出

### 依赖关系
```
Page
  ├── Binding (注入 Controller)
  ├── Widgets (UI组件)
  └── Controllers (业务逻辑)
```

## 测试建议

1. ✅ 打开控制台查看生命周期日志
2. ✅ 观察 Controller 的 onInit、onClose 调用时机
3. ✅ 对比 GetX、Obx、GetBuilder 的重建时机
4. ✅ 理解 Get.find 不会建立监听关系
5. ✅ 体验无需 BuildContext 访问状态的便利性
6. ✅ 测试多 Controller 协同工作

## GetX 核心概念

### 1. 响应式变量
```dart
// 使用 .obs 创建响应式变量
final RxInt counter = 0.obs;

// 访问值使用 .value
print(counter.value);

// 更新值会自动通知 UI
counter.value++;
```

### 2. 状态访问
```dart
// 查找已注入的 Controller（不建立监听）
final controller = Get.find<CounterController>();

// 读取值
print(controller.counter);
```

### 3. 依赖注入
```dart
// 立即创建
Get.put(CounterController());

// 懒加载（首次使用时创建）
Get.lazyPut<CounterController>(() => CounterController());

// 单例
Get.put(CounterController(), permanent: true);
```

### 4. 生命周期
```dart
class MyController extends GetxController {
  @override
  void onInit() {
    // 类似于 initState
    super.onInit();
  }

  @override
  void onReady() {
    // 页面加载完成后调用
    super.onReady();
  }

  @override
  void onClose() {
    // 类似于 dispose
    super.onClose();
  }
}
```

## 最佳实践

1. ✅ 使用 Binding 管理依赖注入
2. ✅ 使用 Get.lazyPut 懒加载 Controller
3. ✅ 简单场景使用 Obx，复杂场景使用 GetX
4. ✅ 性能敏感场景使用 GetBuilder
5. ✅ 只在需要监听时使用响应式组件
6. ✅ 合理拆分 Controller，避免过大
7. ✅ 使用 Get.find 只读数据
