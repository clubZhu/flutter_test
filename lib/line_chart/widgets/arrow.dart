import 'package:flutter/material.dart';
import 'dart:ui' as ui;

/// 箭头组件 - 用于提示框指向数据点
class ChartTooltipArrow extends StatelessWidget {
  final Color color;
  final bool isTop; // true=箭头在顶部（向下指）, false=箭头在底部（向上指）

  const ChartTooltipArrow({
    super.key,
    required this.color,
    required this.isTop,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(20, 10),
      painter: _ArrowPainter(
        color: color,
        isTop: isTop,
      ),
    );
  }
}

/// 箭头绘制器
class _ArrowPainter extends CustomPainter {
  final Color color;
  final bool isTop;

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
