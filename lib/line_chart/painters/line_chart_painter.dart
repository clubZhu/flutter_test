import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../models/line_chart_data.dart';

/// 网格显示类型
enum GridType {
  both,   // 显示横线和竖线
  horizontal, // 只显示横线
  vertical,   // 只显示竖线
  none,       // 不显示网格
}

/// 折线图绘制器
class LineChartPainter extends CustomPainter {
  final List<LineChartData> data;
  final double animationValue;
  final double maxY;
  final double minY;
  final Color lineColor;
  final bool showArea;
  final int? hoveredIndex;
  final GridType gridType;
  final double? leftPadding; // 动态计算的左侧边距
  final double pointRadius; // 节点圆点半径
  final double lineWidth; // 折线宽度

  LineChartPainter({
    required this.data,
    required this.animationValue,
    required this.maxY,
    this.minY = 0,
    required this.lineColor,
    required this.showArea,
    this.hoveredIndex,
    this.gridType = GridType.both,
    this.leftPadding,
    this.pointRadius = 8.0,
    this.lineWidth = 3.0,
  });

  // 计算Y轴标签的最大宽度
  double _calculateMaxLabelWidth() {
    final steps = 5;
    final range = maxY - minY;
    double maxWidth = 0;

    for (int i = 0; i <= steps; i++) {
      final value = minY + (range / steps) * i;
      final valueStr = _formatValue(value);

      final textPainter = TextPainter(
        text: TextSpan(
          text: valueStr,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      if (textPainter.width > maxWidth) {
        maxWidth = textPainter.width;
      }
    }

    return maxWidth;
  }

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // 使用动态计算的左侧边距，如果没有提供则使用默认值
    final left = leftPadding ?? _calculateMaxLabelWidth() + 20;
    final padding = EdgeInsets.only(
      left: left,
      right: 50,
      top: 50,
      bottom: 50,
    );
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
    if (gridType == GridType.both || gridType == GridType.horizontal) {
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
    }

    // 绘制垂直网格线
    if (gridType == GridType.both || gridType == GridType.vertical) {
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
    }

    // 绘制Y轴线（不包括顶部）
    if (gridType != GridType.none) {
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
    final range = maxY - minY;

    // 计算所有数据点
    for (int i = 0; i < data.length; i++) {
      final x = padding.left + stepX * i;
      final normalizedValue = ((data[i].value - minY) / range) * animationValue;
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
    final range = maxY - minY;

    // 计算所有数据点
    for (int i = 0; i < data.length; i++) {
      final x = padding.left + stepX * i;
      final normalizedValue = ((data[i].value - minY) / range) * animationValue;
      final y = padding.top + chartHeight * (1 - normalizedValue);
      points.add(Offset(x, y));
    }

    // 绘制折线
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = lineWidth
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
    final range = maxY - minY;

    for (int i = 0; i < data.length; i++) {
      final x = padding.left + stepX * i;
      final normalizedValue = ((data[i].value - minY) / range) * animationValue;
      final y = padding.top + chartHeight * (1 - normalizedValue);

      final isHovered = hoveredIndex == i;

      // 如果被悬停，绘制外圈光晕
      if (isHovered) {
        final glowPaint = Paint()
          ..color = (data[i].color ?? lineColor).withOpacity(0.3)
          ..style = PaintingStyle.fill
          ..isAntiAlias = true;

        canvas.drawCircle(Offset(x, y), pointRadius * 2.25, glowPaint);
      }

      // 绘制外圈（选中的稍微大一点）
      final outerRadius = isHovered ? pointRadius * 1.25 : pointRadius;
      final outerPaint = Paint()
        ..color = data[i].color ?? lineColor
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;

      canvas.drawCircle(Offset(x, y), outerRadius, outerPaint);

      // 绘制内圈
      final innerRadius = isHovered ? pointRadius * 0.75 : pointRadius * 0.625;
      final innerPaint = Paint()
        ..color = Colors.white
        ..style = PaintingStyle.fill
        ..isAntiAlias = true;

      canvas.drawCircle(Offset(x, y), innerRadius, innerPaint);
    }
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
    final range = maxY - minY;
    for (int i = 0; i <= steps; i++) {
      final value = minY + (range / steps) * i;
      final y = padding.top + chartHeight * (1 - i / steps);
      final x = padding.left - 10;

      // 格式化数值，智能显示小数
      String valueStr = _formatValue(value);

      final textPainter = TextPainter(
        text: TextSpan(
          text: valueStr,
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

  // 格式化数值，智能显示小数位数
  String _formatValue(double value) {
    // 如果是整数，直接显示
    if (value == value.truncateToDouble()) {
      return value.toInt().toString();
    }

    // 对于小于 1 的数值，智能显示小数位数
    if (value < 1 && value > -1) {
      // 根据数值大小决定小数位数
      if (value.abs() >= 0.01) {
        // 0.01 到 1：最多显示 4 位小数
        return _trimZeros(value.toStringAsFixed(4));
      } else if (value.abs() >= 0.001) {
        // 0.001 到 0.01：显示 5 位小数
        return _trimZeros(value.toStringAsFixed(5));
      } else if (value.abs() >= 0.0001) {
        // 0.0001 到 0.001：显示 6 位小数
        return _trimZeros(value.toStringAsFixed(6));
      } else {
        // 更小的数值：显示 7 位小数
        return _trimZeros(value.toStringAsFixed(7));
      }
    }

    // 计算合适的小数位数
    if (value >= 1000) {
      // 大数值：显示1位小数
      return value.toStringAsFixed(1);
    } else {
      // 中等数值：显示1位小数
      return value.toStringAsFixed(1);
    }
  }

  // 去除小数点后多余的零
  String _trimZeros(String value) {
    if (value.contains('.')) {
      return value.replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
    }
    return value;
  }

  @override
  bool shouldRepaint(covariant LineChartPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue ||
        oldDelegate.data != data ||
        oldDelegate.hoveredIndex != hoveredIndex ||
        oldDelegate.gridType != gridType ||
        oldDelegate.minY != minY ||
        oldDelegate.leftPadding != leftPadding ||
        oldDelegate.pointRadius != pointRadius ||
        oldDelegate.lineWidth != lineWidth;
  }
}
