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
