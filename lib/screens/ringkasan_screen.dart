import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../models/sesi_olahraga.dart';
import '../theme/fit_colors.dart';
import '../theme/track_colors.dart';
import '../widgets/app_bottom_nav.dart';

/// Layar 4: ringkasan setelah sesi selesai.
class RingkasanScreen extends StatelessWidget {
  const RingkasanScreen({super.key, required this.hasil});

  final HasilSesi hasil;

  // TODO: simpan `hasil` ke riwayat (database/API) sebelum kembali.
  void _kembali(BuildContext context) {
    goToTab(context, AppTab.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF5FC),
      body: SafeArea(
        child: Stack(
          children: [
            LayoutBuilder(
              builder: (context, c) => SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 130),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: c.maxHeight - 142),
                  child: Center(child: _buildCard(context)),
                ),
              ),
            ),
            const Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: AppBottomNav(current: AppTab.tracking),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F0055AA),
            blurRadius: 35,
            spreadRadius: -8,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            width: 56,
            height: 56,
            child: CustomPaint(painter: _LogoPainter()),
          ),
          Text('GERAK',
              style: fitText(24, FontWeight.w800, TC.blue600,
                  letterSpacing: 1.2)),
          Text('ACTIVE & HEALTHY LIFE',
              style: fitText(8, FontWeight.w700, TC.blue600,
                  letterSpacing: 1.6)),
          const SizedBox(height: 8),
          Text(hasil.jenis.label,
              style: fitText(20, FontWeight.w800, TC.slate800)),
          const SizedBox(height: 2),
          Text(hasil.tanggalPanjang,
              style: fitText(12, FontWeight.w600, TC.slate400)),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _bigMetric(
                    'DURASI', hasil.durasiAngka, hasil.durasiSatuan),
              ),
              const SizedBox(width: 12),
              Expanded(child: _bigMetric('JARAK', hasil.jarakText, 'km')),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _smallMetric(
                  icon: Icons.bolt_rounded,
                  iconColor: TC.blue600,
                  iconBg: TC.sky100,
                  value: TextSpan(
                    text: hasil.langkahText,
                    style: fitText(12, FontWeight.w800, TC.slate800),
                  ),
                  label: 'langkah',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _smallMetric(
                  icon: Icons.local_fire_department_rounded,
                  iconColor: TC.amber500,
                  iconBg: TC.amber50,
                  value: TextSpan(
                    text: '${hasil.kalori} ',
                    style: fitText(12, FontWeight.w800, TC.slate800),
                    children: [
                      TextSpan(
                        text: 'kcal',
                        style: fitText(9, FontWeight.w700, TC.amber500),
                      ),
                    ],
                  ),
                  label: 'terbakar',
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              spacing: 12,
              runSpacing: 4,
              children: [
                Text.rich(
                  TextSpan(
                    text: 'Rata-rata Pace: ',
                    style: fitText(11, FontWeight.w700, TC.blue600),
                    children: [
                      TextSpan(
                        text: '${hasil.paceTanda} /km',
                        style: fitText(11, FontWeight.w600, TC.slate800),
                      ),
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    text: 'Detak Jantung: ',
                    style: fitText(11, FontWeight.w700, TC.blue600),
                    children: [
                      TextSpan(
                        text: '${hasil.bpm} bpm',
                        style: fitText(11, FontWeight.w700, TC.rose500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          GestureDetector(
            onTap: () => _kembali(context),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: TC.blue600,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x4D2563EB),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: Text('Kembali Ke Dashboard',
                  style: fitText(14, FontWeight.w700, Colors.white,
                      letterSpacing: 0.3)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bigMetric(String label, String value, String unit) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xB3E0F2FE)),
      ),
      child: Column(
        children: [
          Text(label,
              style: fitText(11, FontWeight.w700, TC.slate400,
                  letterSpacing: 0.8)),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: fitText(24, FontWeight.w800, TC.slate900)),
              const SizedBox(width: 4),
              Text(unit, style: fitText(12, FontWeight.w700, TC.blue600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _smallMetric({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required TextSpan value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FBFE),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xB3E0F2FE)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(value),
              Text(label, style: fitText(10, FontWeight.w600, TC.slate400)),
            ],
          ),
        ],
      ),
    );
  }
}

/// Logo GERAK (pelari warna-warni), port dari SVG Stitch (viewBox 100x100).
class _LogoPainter extends CustomPainter {
  Paint _stroke(Color c, double w) => Paint()
    ..color = c
    ..style = PaintingStyle.stroke
    ..strokeWidth = w
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / 100);

    canvas.drawCircle(
        const Offset(58, 22), 7, Paint()..color = const Color(0xFF0070BA));

    canvas.drawPath(
      Path()
        ..moveTo(42, 42)
        ..cubicTo(38, 34, 45, 28, 53, 30)
        ..lineTo(67, 33)
        ..cubicTo(71, 34, 74, 39, 72, 43)
        ..lineTo(68, 52),
      _stroke(const Color(0xFF00A859), 5),
    );
    canvas.drawPath(
      Path()
        ..moveTo(42, 43)
        ..lineTo(31, 52)
        ..cubicTo(28, 55, 24, 53, 23, 48)
        ..lineTo(22, 41),
      _stroke(const Color(0xFFF97316), 4.5),
    );
    canvas.drawPath(
      Path()
        ..moveTo(50, 45)
        ..lineTo(46, 62)
        ..lineTo(34, 74)
        ..cubicTo(31, 77, 26, 77, 23, 73),
      _stroke(const Color(0xFF0070BA), 5.5),
    );
    canvas.drawPath(
      Path()
        ..moveTo(46, 62)
        ..lineTo(58, 72)
        ..lineTo(69, 82)
        ..cubicTo(72, 85, 78, 84, 80, 80),
      _stroke(const Color(0xFF0284C7), 5.5),
    );

    // Busur putus-putus di atas kepala.
    final arc = Path()
      ..moveTo(25, 30)
      ..cubicTo(35, 15, 65, 15, 78, 28);
    final dash = _stroke(const Color(0xFF38BDF8), 3.5);
    for (final m in arc.computeMetrics()) {
      var d = 0.0;
      while (d < m.length) {
        canvas.drawPath(m.extractPath(d, math.min(d + 3, m.length)), dash);
        d += 7;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}