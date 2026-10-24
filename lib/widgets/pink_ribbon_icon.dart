import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// A subtle, elegant breast cancer awareness ribbon motif for Etmaenan.
class PinkRibbonIcon extends StatelessWidget {
  final double size;
  final Color? color;

  const PinkRibbonIcon({
    super.key,
    this.size = 24.0,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final ribbonColor = color ?? AppColors.pinkOctober;

    return Semantics(
      label: 'شعار الشريط الوردي للتوعية بسرطان الثدي / Pink October Ribbon',
      child: CustomPaint(
        size: Size(size, size * 1.25),
        painter: _RibbonPainter(ribbonColor),
      ),
    );
  }
}

class _RibbonPainter extends CustomPainter {
  final Color color;

  _RibbonPainter(this.color);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.18
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    final w = size.width;
    final h = size.height;

    // Left tail going up into loop and down to right tail
    path.moveTo(w * 0.18, h * 0.95);
    path.cubicTo(w * 0.25, h * 0.65, w * 0.05, h * 0.25, w * 0.5, h * 0.08);
    path.cubicTo(w * 0.95, h * 0.25, w * 0.75, h * 0.65, w * 0.82, h * 0.95);

    canvas.drawPath(path, paint);

    // Subtle inner loop fill for visual polish
    final loopPaint = Paint()
      ..color = color.withValues(alpha: 0.25)
      ..style = PaintingStyle.fill;

    final loopPath = Path();
    loopPath.moveTo(w * 0.5, h * 0.55);
    loopPath.cubicTo(w * 0.28, h * 0.35, w * 0.30, h * 0.18, w * 0.5, h * 0.12);
    loopPath.cubicTo(w * 0.70, h * 0.18, w * 0.72, h * 0.35, w * 0.5, h * 0.55);
    loopPath.close();

    canvas.drawPath(loopPath, loopPaint);
  }

  @override
  bool shouldRepaint(covariant _RibbonPainter oldDelegate) => oldDelegate.color != color;
}
