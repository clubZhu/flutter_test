import 'dart:math' as math;
import 'package:flutter/material.dart';

/// 雷达图数据模型
class RadarData {
  final String label;
  final double value;
  final Color color;

  RadarData({
    required this.label,
    required this.value,
    this.color = Colors.blue,
  });
}

/// 雷达图页面
class RadarChartPage extends StatefulWidget {
  const RadarChartPage({super.key});

  @override
  State<RadarChartPage> createState() => _RadarChartPageState();
}

class _RadarChartPageState extends State<RadarChartPage>
    with SingleTickerProviderStateMixin {
  // 示例数据：能力评估
  late List<RadarData> abilityData;
  late List<RadarData> performanceData;

  // 动画控制器
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // 初始化数据
    abilityData = [
      RadarData(label: '攻击', value: 85, color: Colors.red),
      RadarData(label: '防御', value: 70, color: Colors.blue),
      RadarData(label: '速度', value: 90, color: Colors.green),
      RadarData(label: '体力', value: 75, color: Colors.orange),
      RadarData(label: '智力', value: 80, color: Colors.purple),
      RadarData(label: '敏捷', value: 88, color: Colors.teal),
    ];

    performanceData = [
      RadarData(label: '工作效率', value: 100),
      RadarData(label: '团队协作', value: 90),
      RadarData(label: '创新能力', value: 75),
      RadarData(label: '沟通能力', value: 88),
      RadarData(label: '执行力', value: 10),
    ];

    // 初始化动画
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutBack,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('雷达图示例'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // 示例 1：能力六边形雷达图
            _buildChartCard(
              title: '示例 1: 能力评估（六边形）',
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return RadarChart(
                    data: abilityData,
                    animationValue: _animation.value,
                    max_value: 100,
                    sides: 6,
                  );
                },
              ),
            ),

            // 示例 2：绩效五边形雷达图
            _buildChartCard(
              title: '示例 2: 绩效评估（五边形）',
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return RadarChart(
                    data: performanceData,
                    animationValue: _animation.value,
                    max_value: 100,
                    sides: 5,
                    color: Colors.purple,
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

  Widget _buildChartCard({required String title, required Widget child}) {
    return Card(
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 350,
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
          colors: [Colors.blue.shade400, Colors.purple.shade400],
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
                '雷达图原理',
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
            '• 通过数学公式计算多边形顶点坐标\n'
            '• 支持任意边数（3-12边）\n'
            '• 支持动画效果\n'
            '• 可自定义颜色、样式\n'
            '• 适用于能力评估、数据分析等场景',
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
}

/// 雷达图组件
class RadarChart extends StatelessWidget {
  final List<RadarData> data;
  final double animationValue;
  final double max_value;
  final int sides;
  final Color? color;

  const RadarChart({
    super.key,
    required this.data,
    required this.animationValue,
    this.max_value = 100,
    this.sides = 6,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(double.infinity, double.infinity),
      painter: _RadarChartPainter(
        data: data,
        animationValue: animationValue,
        max_value: max_value,
        sides: sides,
        color: color ?? Colors.blue,
      ),
    );
  }
}

/// 雷达图绘制器
class _RadarChartPainter extends CustomPainter {
  final List<RadarData> data;
  final double animationValue;
  final double max_value;
  final int sides;
  final Color color;

  _RadarChartPainter({
    required this.data,
    required this.animationValue,
    required this.max_value,
    required this.sides,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = math.min(size.width, size.height) / 2 - 60;

    // 绘制背景网格（同心多边形）
    _drawGrid(canvas, center, radius);

    // 绘制轴线和标签
    _drawAxesAndLabels(canvas, center, radius);

    // 绘制数据区域
    _drawDataArea(canvas, center, radius);

    // 绘制数据点
    _drawDataPoints(canvas, center, radius);
  }

  // 绘制网格
  void _drawGrid(Canvas canvas, Offset center, double radius) {
    final gridLevels = 5;
    final gridPaint = Paint()
      ..color = Colors.grey.shade300
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    for (int i = 1; i <= gridLevels; i++) {
      final levelRadius = radius * i / gridLevels;
      final points = _calculatePolygonPoints(center, levelRadius, sides);

      final path = Path()..addPolygon(points, true);
      canvas.drawPath(path, gridPaint);
    }
  }

  // 绘制轴线和标签
  void _drawAxesAndLabels(Canvas canvas, Offset center, double radius) {
    final axisPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1.0
      ..isAntiAlias = true;

    final points = _calculatePolygonPoints(center, radius, sides);

    // 绘制轴线
    for (final point in points) {
      canvas.drawLine(center, point, axisPaint);
    }

    // 绘制标签
    for (int i = 0; i < data.length && i < points.length; i++) {
      _drawLabel(canvas, center, points[i], data[i].label);
    }
  }

  // 绘制标签
  void _drawLabel(Canvas canvas, Offset center, Offset position, String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // 计算标签位置（根据象限调整）
    double dx = position.dx - textPainter.width / 2;
    double dy = position.dy - textPainter.height / 2;

    // 根据位置调整偏移
    if (position.dx < center.dx) dx -= textPainter.width / 2 + 5;
    if (position.dx > center.dx) dx += textPainter.width / 2 + 5;
    if (position.dy < center.dy) dy -= textPainter.height / 2 + 5;
    if (position.dy > center.dy) dy += textPainter.height / 2 + 5;

    textPainter.paint(canvas, Offset(dx, dy));
  }

  // 绘制数据区域
  void _drawDataArea(Canvas canvas, Offset center, double radius) {
    if (data.isEmpty) return;

    final points = <Offset>[];
    final polygonPoints = _calculatePolygonPoints(center, radius, sides);

    for (int i = 0; i < data.length && i < polygonPoints.length; i++) {
      final value = data[i].value * animationValue; // 应用动画
      final ratio = value / max_value;
      final point = Offset(
        center.dx + (polygonPoints[i].dx - center.dx) * ratio,
        center.dy + (polygonPoints[i].dy - center.dy) * ratio,
      );
      points.add(point);
    }

    // 绘制填充区域
    final fillPaint = Paint()
      ..color = color.withOpacity(0.3)
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    final path = Path()..addPolygon(points, true);
    canvas.drawPath(path, fillPaint);

    // 绘制边框
    final strokePaint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..isAntiAlias = true;

    canvas.drawPath(path, strokePaint);
  }

  // 绘制数据点
  void _drawDataPoints(Canvas canvas, Offset center, double radius) {
    final polygonPoints = _calculatePolygonPoints(center, radius, sides);

    for (int i = 0; i < data.length && i < polygonPoints.length; i++) {
      final value = data[i].value * animationValue;
      final ratio = value / max_value;
      final point = Offset(
        center.dx + (polygonPoints[i].dx - center.dx) * ratio,
        center.dy + (polygonPoints[i].dy - center.dy) * ratio,
      );

      // 绘制外圈
      final outerPaint = Paint()
        ..color = data[i].color
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;

      canvas.drawCircle(point, 8, outerPaint);

      // 绘制内圈
      final innerPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;

      canvas.drawCircle(point, 5, innerPaint);

      // 绘制数值标签
      _drawValueLabel(canvas, point, data[i].value.toInt());
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
    textPainter.paint(
      canvas,
      Offset(position.dx - textPainter.width / 2, position.dy - textPainter.height / 2),
    );
  }

  // 计算多边形顶点
  List<Offset> _calculatePolygonPoints(Offset center, double radius, int sides) {
    final points = <Offset>[];
    final angleStep = 2 * math.pi / sides;

    for (int i = 0; i < sides; i++) {
      // 从 -90度（12点钟方向）开始
      final angle = angleStep * i - math.pi / 2;
      final x = center.dx + radius * math.cos(angle);
      final y = center.dy + radius * math.sin(angle);
      points.add(Offset(x, y));
    }

    return points;
  }

  @override
  bool shouldRepaint(covariant _RadarChartPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.data != data;
  }
}
