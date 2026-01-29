import 'package:flutter/material.dart';
import '../models/line_chart_data.dart';
import 'arrow.dart';

/// 提示框组件 - 显示数据点详细信息
class ChartTooltip extends StatelessWidget {
  final LineChartData data;
  final Color lineColor;
  final bool showAbove; // true=在数据点上方, false=在下方
  final bool showArrow; // 是否显示箭头

  const ChartTooltip({
    super.key,
    required this.data,
    required this.lineColor,
    required this.showAbove,
    this.showArrow = true,
  });

  @override
  Widget build(BuildContext context) {
    const tooltipWidth = 120.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // 箭头（根据位置调整）
        if (showArrow && !showAbove)
          ChartTooltipArrow(
            color: Colors.white.withOpacity(0.4),
            isTop: true,
          ),
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
                  lineColor.withOpacity(0.95),
                  lineColor.withOpacity(0.85),
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
                      _formatValue(data.value),
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

              ],
            ),
          ),
        ),
        // 箭头
        if (showArrow && showAbove)
          ChartTooltipArrow(
            color: Colors.white.withOpacity(0.4),
            isTop: false,
          ),
      ],
    );
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
}
