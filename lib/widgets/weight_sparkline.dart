import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Mini line chart buat nampilin tren beberapa titik data (misal berat
/// badan mingguan). Sengaja ditulis manual pakai CustomPainter (bukan
/// pakai package chart pihak ketiga) supaya project ini nggak nambah
/// dependency baru di pubspec.yaml.
class WeightSparkline extends StatelessWidget {
  const WeightSparkline({
    super.key,
    required this.values,
    this.height = 90,
  });

  /// Data mentah, urut dari titik paling lama ke paling baru.
  /// Minimal butuh 2 titik supaya ada garis yang bisa digambar.
  final List<double> values;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (values.length < 2) {
      // Human error guard: kalau data belum cukup, jangan crash,
      // cukup tampilkan area kosong.
      return SizedBox(height: height);
    }
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(
        painter: _SparklinePainter(values: values),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter({required this.values});
  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    final maxV = values.reduce(max);
    final minV = values.reduce(min);
    final range = (maxV - minV).abs() < 0.001 ? 1.0 : (maxV - minV);

    const verticalPadding = 10.0;
    final usableHeight = size.height - verticalPadding * 2;

    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final x = values.length == 1
          ? 0.0
          : size.width * i / (values.length - 1);
      final normalized = (values[i] - minV) / range; // 0..1
      final y = verticalPadding + usableHeight * (1 - normalized);
      points.add(Offset(x, y));
    }

    // Garis halus (smoothed) yang menghubungkan tiap titik.
    final path = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final curr = points[i];
      final mid = Offset((prev.dx + curr.dx) / 2, (prev.dy + curr.dy) / 2);
      path.quadraticBezierTo(prev.dx, prev.dy, mid.dx, mid.dy);
    }
    path.lineTo(points.last.dx, points.last.dy);

    // Area gradasi tipis di bawah garis.
    final fillPath = Path.from(path)
      ..lineTo(points.last.dx, size.height)
      ..lineTo(points.first.dx, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primary.withOpacity(0.18),
          AppColors.primary.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = 2.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, linePaint);

    // Titik bulat di tiap data point.
    for (final p in points) {
      canvas.drawCircle(p, 4.5, Paint()..color = Colors.white);
      canvas.drawCircle(
        p,
        4.5,
        Paint()
          ..color = AppColors.primary
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.values != values;
  }
}
