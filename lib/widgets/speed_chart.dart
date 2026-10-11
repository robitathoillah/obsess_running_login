import 'package:flutter/material.dart';
import '../theme/fit_colors.dart';

/// Grafik kecepatan di halaman Detail Riwayat.
/// [fractions] = posisi titik di sumbu X (0.0 - 1.0), [values] = kecepatan.
/// Titik tertinggi digambar penuh, titik lain berongga.
class SpeedChart extends StatelessWidget {
  const SpeedChart({
    super.key,
    required this.fractions,
    required this.values,
    this.height = 150,
  });

  final List<double> fractions;
  final List<double> values;
  final double height;

  @override
  Widget build(BuildContext context) {
    // Jaga-jaga kalau data tidak lengkap: jangan crash, tampilkan area kosong.
    if (fractions.length < 2 || fractions.length != values.length) {
      return SizedBox(height: height);
    }
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _SpeedPainter(fractions, values)),
    );
  }
}

class _SpeedPainter extends CustomPainter {
  _SpeedPainter(this.fractions, this.values);

  final List<double> fractions;
  final List<double> values;

  @override
  void paint(Canvas canvas, Size size) {
    const padX = 10.0;
    const padTop = 14.0;
    const padBottom = 10.0;

    final usableW = size.width - padX * 2;
    final usableH = size.height - padTop - padBottom;
    final bottom = size.height - padBottom;

    var minV = values.first;
    var maxV = values.first;
    for (final v in values) {
      if (v < minV) minV = v;
      if (v > maxV) maxV = v;
    }
    minV -= 0.8;
    maxV += 0.8;
    final range = maxV - minV;

    final points = <Offset>[];
    var peakIndex = 0;
    for (var i = 0; i < values.length; i++) {
      final x = padX + fractions[i] * usableW;
      final y = padTop + usableH * (1 - (values[i] - minV) / range);
      points.add(Offset(x, y));
      if (values[i] > values[peakIndex]) peakIndex = i;
    }

    // Garis bantu putus-putus.
    final gridPaint = Paint()
      ..color = FitColors.slate200.withOpacity(0.8)
      ..strokeWidth = 1;
    for (final f in [0.1, 0.45, 0.8]) {
      final y = padTop + usableH * f;
      var x = padX;
      while (x < size.width - padX) {
        canvas.drawLine(Offset(x, y), Offset(x + 3, y), gridPaint);
        x += 7;
      }
    }
    canvas.drawLine(
      Offset(padX, bottom),
      Offset(size.width - padX, bottom),
      Paint()
        ..color = FitColors.slate100
        ..strokeWidth = 1.2,
    );

    // Kurva halus antar titik.
    final line = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final a = points[i - 1];
      final b = points[i];
      final midX = (a.dx + b.dx) / 2;
      line.cubicTo(midX, a.dy, midX, b.dy, b.dx, b.dy);
    }

    final area = Path.from(line)
      ..lineTo(points.last.dx, bottom)
      ..lineTo(points.first.dx, bottom)
      ..close();

    canvas.drawPath(
      area,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            FitColors.blue500.withOpacity(0.35),
            FitColors.blue500.withOpacity(0.02),
          ],
        ).createShader(Rect.fromLTWH(0, padTop, size.width, usableH)),
    );

    canvas.drawPath(
      line,
      Paint()
        ..color = FitColors.blue600
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    for (var i = 0; i < points.length; i++) {
      final p = points[i];
      if (i == peakIndex) {
        canvas.drawCircle(p, 5, Paint()..color = FitColors.blue600);
      } else {
        canvas.drawCircle(p, 5, Paint()..color = Colors.white);
        canvas.drawCircle(
          p,
          5,
          Paint()
            ..color = FitColors.blue600
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.6,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _SpeedPainter oldDelegate) {
    return oldDelegate.values != values || oldDelegate.fractions != fractions;
  }
}
