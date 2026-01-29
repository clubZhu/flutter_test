# Line Chart 测试模块

## 目录结构

```
lib/line_chart/
├── models/                    # 数据模型层
│   ├── line_chart_data.dart    # 折线图数据模型
│   └── models.dart            # 统一导出
├── painters/                  # 绘制器层
│   ├── line_chart_painter.dart # 折线图绘制器
│   └── painters.dart           # 统一导出
├── widgets/                   # UI组件层
│   ├── arrow.dart             # 箭头组件
│   ├── tooltip.dart           # 提示框组件
│   ├── interactive_line_chart.dart # 交互式折线图组件
│   └── widgets.dart           # 统一导出
├── line_chart_page.dart       # 主页面
└── line_chart.dart            # 统一导出入口

```

## 使用方法

### 导入主页面
```dart
import 'package:flutter_architecture_test/line_chart/line_chart_page.dart';

// 在路由中使用
Navigator.push(
  context,
  MaterialPageRoute(builder: (context) => LineChartPage()),
);
```

### 导入所有内容
```dart
import 'package:flutter_architecture_test/line_chart/line_chart.dart';
```

### 单独导入
```dart
// Models
import 'package:flutter_architecture_test/line_chart/models/models.dart';

// Painters
import 'package:flutter_architecture_test/line_chart/painters/painters.dart';

// Widgets
import 'package:flutter_architecture_test/line_chart/widgets/widgets.dart';
```

## 功能说明

### Models (数据模型)

#### LineChartData
折线图数据点模型
- `label`: 标签（如 "1月"）
- `value`: 数值
- `color`: 颜色（可选）
- `description`: 详细描述（可选，支持多行）

### Painters (绘制器)

#### LineChartPainter
折线图绘制器，负责：
- 绘制网格和坐标轴
- 绘制数据区域（渐变填充）
- 绘制折线
- 绘制数据点
- 绘制垂直指示线
- 绘制X轴和Y轴标签

### Widgets (UI组件)

#### ChartTooltipArrow
箭头组件，用于提示框指向数据点
- 支持向上/向下两种方向
- 使用 CustomPaint 自定义绘制

#### ChartTooltip
提示框组件，显示数据详情
- 标签显示
- 数值显示（带 FittedBox 防溢出）
- 描述信息（最多3行）
- 操作提示
- 支持显示在上方或下方

#### InteractiveLineChart
交互式折线图组件
- 支持手指滑动查看数据
- 自动定位最近的时间点
- 提示框悬浮显示
- 松手后提示框消失
- 三个示例数据集

## 架构设计

### 分层设计
```
Presentation Layer (LineChartPage)
        ↓
Business Logic Layer (State + Animation)
        ↓
UI Components Layer (Widgets)
        ↓
Custom Painting Layer (Painters)
        ↓
Data Model Layer (Models)
```

### 文件组织原则
1. **单一职责** - 每个文件只负责一个功能
2. **高内聚** - 相关功能放在同一模块
3. **低耦合** - 模块之间通过统一导出连接
4. **易维护** - 小文件易于定位和修改
5. **可复用** - 组件可在其他页面复用

### 依赖关系
```
LineChartPage
    ↓
InteractiveLineChart
    ↓
LineChartPainter + ChartTooltip + ChartTooltipArrow
    ↓
LineChartData
```

## 模块说明

### models/line_chart_data.dart
定义折线图的数据结构，包含：
- 基本属性（label, value）
- 可选属性（color, description）
- 支持多行描述文本

### painters/line_chart_painter.dart
核心绘制逻辑，包含：
- 8个绘制方法
- 网格和坐标轴绘制
- 折线和区域填充
- 数据点和标签绘制
- 垂直指示线绘制
- 使用 CustomPainter 和 Canvas API

### widgets/interactive_line_chart.dart
交互式折线图组件，包含：
- 手势处理（onPanStart/Update/End）
- 状态管理（hoveredIndex）
- 提示框定位逻辑
- 与绘制器和数据模型的集成

### widgets/tooltip.dart
提示框组件，包含：
- 箭头和提示框主体
- 响应式布局
- FittedBox 防止数值溢出
- 支持上下两种显示位置

### widgets/arrow.dart
箭头组件，包含：
- 自定义绘制逻辑
- 支持两种方向
- 与提示框配合使用

## 特性

✅ 单一职责 - 每个类一个文件，职责清晰
✅ 易于维护 - 文件更小，更易定位和修改
✅ 可测试性 - 独立的类更容易编写单元测试
✅ 可重用性 - 组件可以在其他地方复用
✅ 清晰分层 - Models/Painters/Widgets 分离
✅ Barrel导出 - 使用统一的导出入口

## 重构优势

### 之前的单一文件问题
- 970+ 行代码在一个文件中
- 难以定位和修改
- 无法复用组件
- 难以编写测试

### 重构后的优势
- 平均每个文件 50-100 行
- 职责清晰，易于理解
- 组件可独立复用
- 易于编写单元测试
- 更好的代码组织

## 测试建议

1. 运行应用查看效果
2. 滑动查看不同时间点数据
3. 测试边界情况（顶部/底部数据点）
4. 验证提示框完整显示
5. 检查三个示例数据集
