import 'package:flutter/material.dart';
import '../models/line_chart_data.dart';
import '../painters/line_chart_painter.dart';
import 'tooltip.dart';

/// 交互式折线图组件（支持触摸显示详情）
class InteractiveLineChart extends StatefulWidget {
  final List<LineChartData> data;
  final double animationValue;
  final double? maxY;
  final double? minY;
  final Color lineColor;
  final bool showArea;
  final GridType gridType;
  final double pointRadius; // 节点圆点半径
  final double lineWidth; // 折线宽度

  const InteractiveLineChart({
    super.key,
    required this.data,
    required this.animationValue,
    this.maxY,
    this.minY,
    this.lineColor = Colors.blue,
    this.showArea = true,
    this.gridType = GridType.both,
    this.pointRadius = 8.0,
    this.lineWidth = 3.0,
  });

  @override
  State<InteractiveLineChart> createState() => _InteractiveLineChartState();
}

class _InteractiveLineChartState extends State<InteractiveLineChart> {
  int? hoveredIndex; // 当前悬停的数据点索引
  final GlobalKey _chartKey = GlobalKey(); // 图表的 GlobalKey
  Offset? _touchPosition; // 手指在图表中的位置

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
          _touchPosition = null;
        });
      },
      child: Stack(
        children: [
          CustomPaint(
            key: _chartKey,
            size: const Size(double.infinity, double.infinity),
            painter: LineChartPainter(
              data: widget.data,
              animationValue: widget.animationValue,
              maxY: widget.maxY ?? _calculateMaxY(),
              minY: widget.minY ?? _calculateMinY(),
              lineColor: widget.lineColor,
              showArea: widget.showArea,
              hoveredIndex: hoveredIndex,
              gridType: widget.gridType,
              leftPadding: _calculateLeftPadding(),
              pointRadius: widget.pointRadius,
              lineWidth: widget.lineWidth,
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

    final leftPadding = _calculateLeftPadding();
    final padding = EdgeInsets.only(
      left: leftPadding,
      right: 50,
      top: 50,
      bottom: 50,
    );
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
        _touchPosition = localPosition;
      });
    } else {
      setState(() {
        hoveredIndex = null;
        _touchPosition = null;
      });
    }
  }

  // 计算数据的最大值（添加一些顶部padding）
  double _calculateMaxY() {
    if (widget.data.isEmpty) return 100;
    final maxVal = widget.data.map((d) => d.value).reduce((a, b) => a > b ? a : b);
    // 添加 10% 的顶部空间
    return maxVal * 1.1;
  }

  // 计算数据的最小值（添加一些底部padding）
  double _calculateMinY() {
    if (widget.data.isEmpty) return 0;
    final minVal = widget.data.map((d) => d.value).reduce((a, b) => a < b ? a : b);

    // 如果最小值大于0
    if (minVal > 0) {
      // 对于大数值（>= 10），从 minVal * 0.9 开始
      if (minVal >= 10) {
        return minVal * 0.9;
      }
      // 对于小数值，从 minVal * 0.95 开始，留出底部空间
      return minVal * 0.95;
    }
    // 如果有负数，添加 10% 的底部空间
    return minVal * 1.1;
  }

  // 计算左侧边距（基于Y轴标签的最大宽度）
  double _calculateLeftPadding() {
    final maxY = widget.maxY ?? _calculateMaxY();
    final minY = widget.minY ?? _calculateMinY();

    // 计算所有Y轴标签并找出最宽的一个
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

    // 添加额外的间距（标签与Y轴之间）
    return maxWidth + 20;
  }

  // 格式化数值（用于计算宽度）
  String _formatValue(double value) {
    if (value == value.truncateToDouble()) {
      return value.toInt().toString();
    }

    if (value < 1 && value > -1) {
      if (value.abs() >= 0.01) {
        return _trimZeros(value.toStringAsFixed(4));
      } else if (value.abs() >= 0.001) {
        return _trimZeros(value.toStringAsFixed(5));
      } else if (value.abs() >= 0.0001) {
        return _trimZeros(value.toStringAsFixed(6));
      } else {
        return _trimZeros(value.toStringAsFixed(7));
      }
    }

    if (value >= 1000) {
      return value.toStringAsFixed(1);
    } else {
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

  // 构建悬浮在数据点上方的提示框
  Widget _buildFloatingTooltip(int index) {
    final data = widget.data[index];
    final RenderBox? renderBox =
        _chartKey.currentContext?.findRenderObject() as RenderBox?;

    if (renderBox == null) return const SizedBox();

    final size = renderBox.size;

    // 提示框尺寸
    const tooltipWidth = 120.0;
    const boxPadding = 10.0;

    // 根据手指位置决定 tooltip 显示在左上角还是右上角
    // 手指在左半部分 -> tooltip 在右上角
    // 手指在右半部分 -> tooltip 在左上角
    bool showOnRight = _touchPosition != null &&
        _touchPosition!.dx < size.width / 2;

    // 计算提示框位置（固定在顶部）
    double tooltipX = showOnRight
        ? size.width - tooltipWidth - boxPadding  // 右上角
        : boxPadding;  // 左上角
    double tooltipY = boxPadding;  // 固定在顶部

    return Positioned(
      left: tooltipX,
      top: tooltipY,
      child: ChartTooltip(
        data: data,
        lineColor: widget.lineColor,
        showAbove: true,
        showArrow: false, // 固定在角落，不需要箭头
      ),
    );
  }
}
