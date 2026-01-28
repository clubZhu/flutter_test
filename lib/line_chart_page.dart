import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 折线图数据点
class LineChartData {
  final String label;
  final double value;
  final Color? color;
  final String? description; // 详细描述

  LineChartData({
    required this.label,
    required this.value,
    this.color,
    this.description,
  });
}

/// 折线图页面
class LineChartPage extends StatefulWidget {
  const LineChartPage({super.key});

  @override
  State<LineChartPage> createState() => _LineChartPageState();
}

class _LineChartPageState extends State<LineChartPage>
    with SingleTickerProviderStateMixin {
  // 示例数据
  late List<List<LineChartData>> chartData;
  int selectedChartIndex = 0;

  // 动画控制器
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 初始化数据
    chartData = [
      // 示例 1: 月度销售额
      [
        LineChartData(
          label: '1月',
          value: 65,
          description: '新年促销活动\n同比增长15%',
        ),
        LineChartData(
          label: '2月',
          value: 78,
          description: '春节销售高峰\n环比增长20%',
        ),
        LineChartData(
          label: '3月',
          value: 90,
          description: '春季新品发布\n创历史新高',
        ),
        LineChartData(
          label: '4月',
          value: 85,
          description: '市场调整期\n略有回落',
        ),
        LineChartData(
          label: '5月',
          value: 110,
          description: '五一活动火爆\n恢复增长态势',
        ),
        LineChartData(
          label: '6月',
          value: 125,
          description: '618大促\n半年销售额峰值',
        ),
        LineChartData(
          label: '7月',
          value: 115,
          description: '夏季淡季\n正常回落',
        ),
        LineChartData(
          label: '8月',
          value: 130,
          description: '返校季活动\n突破记录！',
        ),
      ],
      // 示例 2: 温度变化
      [
        LineChartData(
          label: '周一',
          value: 18,
          color: Colors.blue,
          description: '多云转晴\n体感舒适',
        ),
        LineChartData(
          label: '周二',
          value: 22,
          color: Colors.blue,
          description: '晴天\n气温回升',
        ),
        LineChartData(
          label: '周三',
          value: 25,
          color: Colors.orange,
          description: '晴转多云\n气温升高',
        ),
        LineChartData(
          label: '周四',
          value: 28,
          color: Colors.orange,
          description: '多云\n夏季感明显',
        ),
        LineChartData(
          label: '周五',
          value: 32,
          color: Colors.red,
          description: '高温天气\n注意防暑',
        ),
        LineChartData(
          label: '周六',
          value: 35,
          color: Colors.red,
          description: '持续高温\n红色预警',
        ),
        LineChartData(
          label: '周日',
          value: 30,
          color: Colors.orange,
          description: '雷阵雨\n气温下降',
        ),
      ],
      // 示例 3: 股票价格
      [
        LineChartData(
          label: '9:00',
          value: 100,
          description: '开盘价100\n平开',
        ),
        LineChartData(
          label: '10:00',
          value: 105,
          description: '快速拉升\n涨幅5%',
        ),
        LineChartData(
          label: '11:00',
          value: 103,
          description: '小幅回调\n市场调整',
        ),
        LineChartData(
          label: '12:00',
          value: 108,
          description: '午前拉升\n创新高',
        ),
        LineChartData(
          label: '13:00',
          value: 110,
          description: '午后走强\n涨幅10%',
        ),
        LineChartData(
          label: '14:00',
          value: 107,
          description: '尾盘跳水\n获利回吐',
        ),
        LineChartData(
          label: '15:00',
          value: 112,
          description: '收盘价112\n涨幅12%',
        ),
      ],
    ];

    // 初始化动画
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _switchChart(int index) {
    setState(() {
      selectedChartIndex = index;
    });
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('折线图示例'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 图表切换按钮
            _buildChartSelector(),

            // 折线图
            _buildChartCard(
              title: _getChartTitle(selectedChartIndex),
              subtitle: _getChartSubtitle(selectedChartIndex),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return InteractiveLineChart(
                    data: chartData[selectedChartIndex],
                    animationValue: _animation.value,
                    maxY: _getMaxY(selectedChartIndex),
                    lineColor: _getLineColor(selectedChartIndex),
                    showArea: selectedChartIndex != 2,
                  );
                },
              ),
            ),

            // 底部说明
            _buildInfoCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Wrap(
        spacing: 12,
        children: [
          _buildSelectorChip(0, '销售额趋势'),
          _buildSelectorChip(1, '温度变化'),
          _buildSelectorChip(2, '股票价格'),
        ],
      ),
    );
  }

  Widget _buildSelectorChip(int index, String label) {
    final isSelected = selectedChartIndex == index;
    return ElevatedButton(
      onPressed: () => _switchChart(index),
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blue : Colors.grey.shade300,
        foregroundColor: isSelected ? Colors.white : Colors.grey.shade700,
        elevation: isSelected ? 4 : 0,
      ),
      child: Text(label),
    );
  }

  Widget _buildChartCard({
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.indigo.shade400, Colors.purple.shade400],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.info_outline, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                '折线图原理',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '• 使用 CustomPaint 自定义绘制\n'
            '• 绘制坐标轴、网格线、数据点\n'
            '• 使用 Path 绘制平滑折线\n'
            '• 支持渐变填充区域\n'
            '• 流畅的动画效果\n'
            '• 适用于趋势分析、数据对比等场景',
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String _getChartTitle(int index) {
    switch (index) {
      case 0:
        return '示例 1: 月度销售额趋势';
      case 1:
        return '示例 2: 一周温度变化';
      case 2:
        return '示例 3: 股票价格走势';
      default:
        return '折线图';
    }
  }

  String _getChartSubtitle(int index) {
    switch (index) {
      case 0:
        return '展示上半年销售数据变化趋势';
      case 1:
        return '本周气温变化曲线（°C）';
      case 2:
        return '实时股票价格波动';
      default:
        return '';
    }
  }

  double _getMaxY(int index) {
    switch (index) {
      case 0:
        return 150;
      case 1:
        return 40;
      case 2:
        return 120;
      default:
        return 100;
    }
  }

  Color _getLineColor(int index) {
    switch (index) {
      case 0:
        return Colors.blue;
      case 1:
        return Colors.orange;
      case 2:
        return Colors.green;
      default:
        return Colors.blue;
    }
  }
}

/// 交互式折线图组件（支持触摸显示详情）
class InteractiveLineChart extends StatefulWidget {
  final List<LineChartData> data;
  final double animationValue;
  final double maxY;
  final Color lineColor;
  final bool showArea;

  const InteractiveLineChart({
    super.key,
    required this.data,
    required this.animationValue,
    this.maxY = 100,
    this.lineColor = Colors.blue,
    this.showArea = true,
  });

  @override
  State<InteractiveLineChart> createState() => _InteractiveLineChartState();
}

class _InteractiveLineChartState extends State<InteractiveLineChart> {
  int? hoveredIndex; // 当前悬停的数据点索引
  final GlobalKey _chartKey = GlobalKey(); // 图表的 GlobalKey

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanStart: (details) {
        _handlePan(details.globalPosition, context);
      },
      onPanUpdate: (details) {
        _handlePan(details.globalPosition, context);
      },
      onPanEnd: (_) {
        setState(() {
          hoveredIndex = null;
        });
      },
      child: Stack(
        children: [
          CustomPaint(
            key: _chartKey,
            size: const Size(double.infinity, double.infinity),
            painter: _LineChartPainter(
              data: widget.data,
              animationValue: widget.animationValue,
              maxY: widget.maxY,
              lineColor: widget.lineColor,
              showArea: widget.showArea,
              hoveredIndex: hoveredIndex,
            ),
          ),
          // 显示选中点的弹框（悬浮在数据点上方）
          if (hoveredIndex != null)
            _buildFloatingTooltip(hoveredIndex!),
        ],
      ),
    );
  }

  // 处理滑动手势
  void _handlePan(Offset globalPosition, BuildContext context) {
    // 获取 CustomPaint 的 RenderBox
    final RenderBox? box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    // 转换坐标
    final localPosition = box.globalToLocal(globalPosition);
    final size = box.size;

    final padding = const EdgeInsets.all(50);
    final chartWidth = size.width - padding.left - padding.right;
    final chartHeight = size.height - padding.top - padding.bottom;

    // 只考虑X轴位置，找到最近的列
    final stepX = chartWidth / (widget.data.length - 1);
    int closestIndex = 0;
    double closestDistance = double.infinity;

    for (int i = 0; i < widget.data.length; i++) {
      final x = padding.left + stepX * i;
      final distance = (localPosition.dx - x).abs();

      if (distance < closestDistance) {
        closestDistance = distance;
        closestIndex = i;
      }
    }

    // 只有在有效范围内才更新
    if (localPosition.dx >= padding.left &&
        localPosition.dx <= padding.left + chartWidth &&
        localPosition.dy >= padding.top &&
        localPosition.dy <= padding.top + chartHeight) {
      setState(() {
        hoveredIndex = closestIndex;
      });
    } else {
      setState(() {
        hoveredIndex = null;
      });
    }
  }

  // 构建悬浮在数据点上方的提示框
  Widget _buildFloatingTooltip(int index) {
    final data = widget.data[index];
    final RenderBox? renderBox =
        _chartKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) return const SizedBox();

    final size = renderBox.size;
    final padding = const EdgeInsets.all(50);
    final chartWidth = size.width - padding.left - padding.right;
    final chartHeight = size.height - padding.top - padding.bottom;

    // 计算数据点位置
    final stepX = chartWidth / (widget.data.length - 1);
    final x = padding.left + stepX * index;
    final normalizedValue = (data.value / widget.maxY) * widget.animationValue;
    final y = padding.top + chartHeight * (1 - normalizedValue);

    // 提示框尺寸
    const tooltipWidth = 180.0;
    const arrowSize = 10.0;
    const boxPadding = 10.0;

    // 判断提示框应该显示在上方还是下方
    bool showAbove = y > 200; // 距离顶部200px以上才显示在上方

    // 计算提示框X坐标（居中对齐数据点）
    double tooltipX = x - tooltipWidth / 2;

    // 边界处理：左右边界
    if (tooltipX < boxPadding) {
      tooltipX = boxPadding;
    } else if (tooltipX + tooltipWidth > size.width - boxPadding) {
      tooltipX = size.width - tooltipWidth - boxPadding;
    }

    return Positioned(
      left: tooltipX,
      top: showAbove ? null : y + arrowSize + 5, // 如果在下方，设置top
      bottom: showAbove ? size.height - y + arrowSize : null, // 如果在上方，设置bottom
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 箭头（根据位置调整）
          if (!showAbove) _buildArrow(true),
          // 提示框主体
          Material(
            elevation: 12,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: tooltipWidth,
              constraints: const BoxConstraints(
                minWidth: tooltipWidth,
                maxWidth: tooltipWidth,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    widget.lineColor.withOpacity(0.95),
                    widget.lineColor.withOpacity(0.85),
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withOpacity(0.4),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 标签
                  Text(
                    data.label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  // 数值
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${data.value.toInt()}',
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  if (data.description != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      data.description!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                        height: 1.4,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 6),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.touch_app,
                        color: Colors.white.withOpacity(0.9),
                        size: 12,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '松手关闭',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // 箭头
          if (showAbove) _buildArrow(false),
        ],
      ),
    );
  }

  // 构建箭头
  Widget _buildArrow(bool isTop) {
    return CustomPaint(
      size: const Size(20, 10),
      painter: _ArrowPainter(
        color: Colors.white.withOpacity(0.4),
        isTop: isTop,
      ),
    );
  }
}

/// 箭头绘制器
class _ArrowPainter extends CustomPainter {
  final Color color;
  final bool isTop; // true=箭头在顶部（向下指）, false=箭头在底部（向上指）

  _ArrowPainter({
    required this.color,
    required this.isTop,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final path = Path();

    if (isTop) {
      // 向下的箭头
      path.moveTo(size.width / 2, 0);
      path.lineTo(0, size.height);
      path.lineTo(size.width, size.height);
    } else {
      // 向上的箭头
      path.moveTo(0, 0);
      path.lineTo(size.width, 0);
      path.lineTo(size.width / 2, size.height);
    }

    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ArrowPainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.isTop != isTop;
  }
}

/// 折线图绘制器
class _LineChartPainter extends CustomPainter {
  final List<LineChartData> data;
  final double animationValue;
  final double maxY;
  final Color lineColor;
  final bool showArea;
  final int? hoveredIndex;

  _LineChartPainter({
    required this.data,
    required this.animationValue,
    required this.maxY,
    required this.lineColor,
    required this.showArea,
    this.hoveredIndex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final padding = const EdgeInsets.all(50);
    final chartWidth = size.width - padding.left - padding.right;
    final chartHeight = size.height - padding.top - padding.bottom;

    // 绘制网格和坐标轴
    _drawGridAndAxes(canvas, size, padding, chartWidth, chartHeight);

    // 绘制数据区域（渐变填充）
    if (showArea) {
      _drawArea(canvas, padding, chartWidth, chartHeight);
    }

    // 绘制折线
    _drawLine(canvas, padding, chartWidth, chartHeight);

    // 绘制数据点
    _drawPoints(canvas, padding, chartWidth, chartHeight);

    // 绘制垂直指示线（如果有悬停的数据点）
    if (hoveredIndex != null) {
      _drawVerticalIndicatorLine(canvas, padding, chartWidth, chartHeight);
    }

    // 绘制X轴标签
    _drawXLabels(canvas, padding, chartWidth, chartHeight);

    // 绘制Y轴标签
    _drawYLabels(canvas, padding, chartWidth, chartHeight);
  }

  // 绘制垂直指示线
  void _drawVerticalIndicatorLine(
    Canvas canvas,
    EdgeInsets padding,
    double chartWidth,
    double chartHeight,
  ) {
    if (hoveredIndex == null) return;

    final stepX = chartWidth / (data.length - 1);
    final x = padding.left + stepX * hoveredIndex!;

    final linePaint = Paint()
      ..color = (data[hoveredIndex!].color ?? lineColor).withOpacity(0.5)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    // 绘制虚线效果
    final path = Path();
    final dashWidth = 5.0;
    final dashSpace = 5.0;
    double currentY = padding.top;

    while (currentY < padding.top + chartHeight) {
      final segmentEnd = math.min(currentY + dashWidth, padding.top + chartHeight);
      path.moveTo(x, currentY);
      path.lineTo(x, segmentEnd);
      currentY = segmentEnd + dashSpace;
    }

    canvas.drawPath(path, linePaint);

    // 在X轴上绘制一个倒三角形标记
    final trianglePath = Path();
    final triangleSize = 8.0;
    final baseY = padding.top + chartHeight;

    trianglePath.moveTo(x, baseY);
    trianglePath.lineTo(x - triangleSize, baseY + triangleSize);
    trianglePath.lineTo(x + triangleSize, baseY + triangleSize);
    trianglePath.close();

    final trianglePaint = Paint()
      ..color = data[hoveredIndex!].color ?? lineColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    canvas.drawPath(trianglePath, trianglePaint);
  }

  // 绘制网格和坐标轴
  void _drawGridAndAxes(
    Canvas canvas,
    Size size,
    EdgeInsets padding,
    double chartWidth,
    double chartHeight,
  ) {
    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    final axisPaint = Paint()
      ..color = Colors.grey.shade600
      ..strokeWidth = 2.0
      ..isAntiAlias = true;

    // 绘制水平网格线（5条）
    for (int i = 0; i <= 5; i++) {
      final y = padding.top + (chartHeight / 5) * i;
      final startX = padding.left;
      final endX = padding.left + chartWidth;

      canvas.drawLine(
        Offset(startX, y),
        Offset(endX, y),
        // i == 0 时用网格线而不是坐标轴线（去掉顶部黑线）
        // i == 5 是底部X轴，用坐标轴线
        i == 5 ? axisPaint : gridPaint,
      );
    }

    // 绘制垂直网格线
    final stepX = chartWidth / (data.length - 1);
    for (int i = 0; i < data.length; i++) {
      final x = padding.left + stepX * i;
      final startY = padding.top;
      final endY = padding.top + chartHeight;

      canvas.drawLine(
        Offset(x, startY),
        Offset(x, endY),
        gridPaint,
      );
    }

    // 绘制Y轴线（不包括顶部）
    canvas.drawLine(
      Offset(padding.left, padding.top + 1), // 从顶部下方开始
      Offset(padding.left, padding.top + chartHeight),
      axisPaint,
    );

    // 绘制X轴线
    canvas.drawLine(
      Offset(padding.left, padding.top + chartHeight),
      Offset(padding.left + chartWidth, padding.top + chartHeight),
      axisPaint,
    );
  }

  // 绘制数据区域（渐变填充）
  void _drawArea(
    Canvas canvas,
    EdgeInsets padding,
    double chartWidth,
    double chartHeight,
  ) {
    final stepX = chartWidth / (data.length - 1);
    final points = <Offset>[];

    // 计算所有数据点
    for (int i = 0; i < data.length; i++) {
      final x = padding.left + stepX * i;
      final normalizedValue = (data[i].value / maxY) * animationValue;
      final y = padding.top + chartHeight * (1 - normalizedValue);
      points.add(Offset(x, y));
    }

    // 创建路径（闭合区域）
    final path = Path();

    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      // 闭合路径到底部
      path.lineTo(points.last.dx, padding.top + chartHeight);
      path.lineTo(points.first.dx, padding.top + chartHeight);
      path.close();
    }

    // 创建渐变
    final gradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        lineColor.withOpacity(0.4),
        lineColor.withOpacity(0.05),
      ],
    );

    final rect = Rect.fromLTWH(
      padding.left,
      padding.top,
      chartWidth,
      chartHeight,
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.fill;

    canvas.drawPath(path, paint);
  }

  // 绘制折线
  void _drawLine(
    Canvas canvas,
    EdgeInsets padding,
    double chartWidth,
    double chartHeight,
  ) {
    final stepX = chartWidth / (data.length - 1);
    final points = <Offset>[];

    // 计算所有数据点
    for (int i = 0; i < data.length; i++) {
      final x = padding.left + stepX * i;
      final normalizedValue = (data[i].value / maxY) * animationValue;
      final y = padding.top + chartHeight * (1 - normalizedValue);
      points.add(Offset(x, y));
    }

    // 绘制折线
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 3.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    final path = Path();

    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
    }

    canvas.drawPath(path, linePaint);
  }

  // 绘制数据点
  void _drawPoints(
    Canvas canvas,
    EdgeInsets padding,
    double chartWidth,
    double chartHeight,
  ) {
    final stepX = chartWidth / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = padding.left + stepX * i;
      final normalizedValue = (data[i].value / maxY) * animationValue;
      final y = padding.top + chartHeight * (1 - normalizedValue);

      final isHovered = hoveredIndex == i;

      // 如果被悬停，绘制外圈光晕
      if (isHovered) {
        final glowPaint = Paint()
          ..color = (data[i].color ?? lineColor).withOpacity(0.3)
          ..style = PaintingStyle.fill
          ..isAntiAlias = true;

        canvas.drawCircle(Offset(x, y), 18, glowPaint);
      }

      // 绘制外圈（选中的稍微大一点）
      final outerRadius = isHovered ? 10 : 8;
      final outerPaint = Paint()
        ..color = data[i].color ?? lineColor
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;

      canvas.drawCircle(Offset(x, y), outerRadius.toDouble(), outerPaint);

      // 绘制内圈
      final innerRadius = isHovered ? 6 : 5;
      final innerPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;

      canvas.drawCircle(Offset(x, y), innerRadius.toDouble(), innerPaint);

      // 绘制数值标签（被悬停时不显示，因为有弹框了）
      if (!isHovered) {
        _drawValueLabel(canvas, Offset(x, y), data[i].value.toInt());
      }
    }
  }

  // 绘制数值标签
  void _drawValueLabel(Canvas canvas, Offset position, int value) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: '$value',
        style: const TextStyle(
          fontSize: 12,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // 在数据点上方显示
    textPainter.paint(
      canvas,
      Offset(position.dx - textPainter.width / 2, position.dy - textPainter.height - 10),
    );
  }

  // 绘制X轴标签
  void _drawXLabels(
    Canvas canvas,
    EdgeInsets padding,
    double chartWidth,
    double chartHeight,
  ) {
    final stepX = chartWidth / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final x = padding.left + stepX * i;
      final y = padding.top + chartHeight + 20;

      final textPainter = TextPainter(
        text: TextSpan(
          text: data[i].label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y),
      );
    }
  }

  // 绘制Y轴标签
  void _drawYLabels(
    Canvas canvas,
    EdgeInsets padding,
    double chartWidth,
    double chartHeight,
  ) {
    final steps = 5;
    for (int i = 0; i <= steps; i++) {
      final value = (maxY / steps) * i;
      final y = padding.top + chartHeight * (1 - i / steps);
      final x = padding.left - 10;

      final textPainter = TextPainter(
        text: TextSpan(
          text: value.toInt().toString(),
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width, y - textPainter.height / 2),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _LineChartPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.data != data ||
        oldDelegate.hoveredIndex != hoveredIndex;
  }
}
