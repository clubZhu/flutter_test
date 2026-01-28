# Provider 测试模块

## 目录结构

```
lib/provider_test/
├── models/                    # 数据模型
│   ├── counter_model.dart    # 计数器模型
│   ├── cart_model.dart       # 购物车模型
│   ├── user_model.dart       # 用户信息模型
│   └── models.dart           # 模型统一导出
├── widgets/                   # UI 组件
│   ├── provider_explanation.dart    # Provider 原理说明卡片
│   ├── control_button.dart          # 控制按钮组件
│   ├── watch_counter_display.dart   # 使用 context.watch 的计数器显示
│   ├── counter_section.dart         # 计数器示例区域
│   ├── cart_section.dart            # 购物车示例区域
│   ├── static_widget.dart           # 静态 Widget（不监听状态）
│   ├── performance_section.dart     # 性能优化示例区域
│   ├── bottom_info.dart             # 底部信息卡片
│   └── widgets.dart                 # 组件统一导出
├── provider_test_page.dart   # 主页面
└── provider_test.dart        # 统一导出入口

```

## 使用方法

### 导入主页面
```dart
import 'package:flutter_architecture_test/provider_test/provider_test_page.dart';

// 在路由中使用
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => ProviderTestPage()),
);
```

### 导入所有内容
```dart
import 'package:flutter_architecture_test/provider_test/provider_test.dart';
```

### 单独导入模型
```dart
import 'package:flutter_architecture_test/provider_test/models/models.dart';
```

### 单独导入组件
```dart
import 'package:flutter_architecture_test/provider_test/widgets/widgets.dart';
```

## 功能说明

### 模型 (Models)

#### CounterModel
计数器模型，演示基础的 ChangeNotifier 用法

#### CartModel
购物车模型，演示列表状态管理

#### UserModel
用户信息模型，演示只读状态

### 组件 (Widgets)

#### ProviderExplanation
显示 Provider 的核心原理说明

#### CounterSection
示例 1：基础计数器
- 使用 Consumer 监听变化
- 使用 context.watch 监听变化
- 展示两种方式的区别

#### CartSection
示例 2：多 Provider 协同
- 使用 Consumer2 同时监听多个 Provider
- 展示购物车和用户信息的交互

#### PerformanceSection
示例 3：性能优化
- 使用 Selector 精确监听特定字段
- 对比 context.read 和 context.watch 的区别
- 展示不监听状态的 Widget

## 架构设计

### 分层设计
- **Models Layer**: 纯业务逻辑，不依赖 Flutter 框架
- **Widgets Layer**: UI 组件，每个组件职责单一
- **Page Layer**: 页面组装，负责 Provider 的注入和组件的组合

### 文件组织原则
1. 一个类一个文件
2. 使用 barrel 文件统一导出
3. 私有类以下划线开头改为公共类便于测试
4. 相关文件放在同一目录

### 依赖关系
```
Page
  ├── Models (业务逻辑)
  └── Widgets (UI组件)
        └── Models (通过 Provider 访问)
```

## 测试建议

1. 打开控制台查看重建日志
2. 观察不同操作的组件重建时机
3. 对比 Consumer 和 context.watch 的区别
4. 理解 Selector 的性能优化作用
