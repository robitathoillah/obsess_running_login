import 'package:flutter/material.dart';
import '../theme/fit_colors.dart';

/// Grafik tren berat badan di Dashboard. Bentuk kurvanya sama dengan SVG
/// di desain (3 titik, titik terakhir berwarna coral). Digambar manual
/// dengan CustomPainter, jadi tidak perlu package chart.
class WeightTrendChart extends StatelessWidget {
  const WeightTrendChart({super.key, this.height = 64});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _TrendPainter()),
    );
  }
}

class _TrendPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 320;
    final sy = size.height / 60;

    final line = Path()
      ..moveTo(0, 15 * sy)
      ..quadraticBezierTo(80 * sx, 18 * sy, 160 * sx, 32 * sy)
      ..quadraticBezierTo(240 * sx, 46 * sy, 320 * sx, 48 * sy);

    final fill = Path.from(line)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          FitColors.blue600.withOpacity(0.28),
          FitColors.blue700.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
    canvas.drawPath(fill, fillPaint);

    final linePaint = Paint()
      ..color = FitColors.blue600
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(line, linePaint);

    void dot(double x, double y, double r, double stroke, Color color) {
      final c = Offset(x * sx, y * sy);
      canvas.drawCircle(c, r, Paint()..color = color);
      canvas.drawCircle(
        c,
        r,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = stroke,
      );
    }

    dot(0, 15, 4, 2, FitColors.blue600);
    dot(160, 32, 4, 2, FitColors.blue600);
    dot(320, 48, 5, 2.5, FitColors.coral);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
