import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../models/sesi_olahraga.dart';
import '../theme/fit_colors.dart';
import '../theme/track_colors.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/track_circle_button.dart';
import 'tracking_screen.dart';

/// Layar 2: hitung mundur 3 detik sebelum sesi dimulai.
class MulaiOlahragaScreen extends StatefulWidget {
  const MulaiOlahragaScreen({super.key, required this.jenis});

  final JenisOlahraga jenis;

  @override
  State<MulaiOlahragaScreen> createState() => _MulaiOlahragaScreenState();
}

class _MulaiOlahragaScreenState extends State<MulaiOlahragaScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c;
  bool _berangkat = false;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..addStatusListener((s) {
        if (s == AnimationStatus.completed) _mulai();
      })
      ..forward();
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _mulai() {
    if (_berangkat || !mounted) return;
    _berangkat = true;
    _c.stop();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => TrackingScreen(jenis: widget.jenis)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FitColors.bg,
      body: SafeArea(
        child: Stack(
          children: [
            // Cahaya lembut di latar.
            Positioned(
              left: -90,
              top: -70,
              child: _blob(260, const Color(0x66BFDBFE)),
            ),
            Positioned(
              right: -80,
              top: 150,
              child: _blob(230, const Color(0x4DBAE6FD)),
            ),
            Column(
              children: [
                _buildTopBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 130),
                    child: Column(
                      children: [
                        _buildProfileCard(context),
                        const SizedBox(height: 12),
                        _buildCountdown(),
                        const SizedBox(height: 12),
                        _buildChecklist(),
                        const SizedBox(height: 16),
                        _buildCta(),
                      ],
                    ),
                  ),
                ),
              ],
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

  Widget _blob(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [color, color.withAlpha(0)],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------- Top bar

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TrackCircleButton(
            icon: Icons.chevron_left_rounded,
            label: 'Kembali',
            onTap: () => Navigator.of(context).maybePop(),
          ),
          Column(
            children: [
              Text('GERAK SPORT',
                  style: fitText(11, FontWeight.w800, TC.blue600,
                      letterSpacing: 1.6)),
              Text('Mulai Olahraga',
                  style: fitText(18, FontWeight.w800, TC.slate900)),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: TC.emerald50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFA7F3D0)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                      color: TC.emerald500, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text('GPS Siap',
                    style: fitText(10, FontWeight.w700, TC.emerald700,
                        letterSpacing: 0.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------ Kartu profil

  Widget _buildProfileCard(BuildContext context) {
    final j = widget.jenis;

    Widget stat(String label, String value, String unit) {
      return Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
          decoration: BoxDecoration(
            color: const Color(0xCCF8FAFC),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(label,
                  style: fitText(9, FontWeight.w600, TC.slate400,
                      letterSpacing: 0.5)),
              const SizedBox(height: 2),
              Text.rich(
                TextSpan(
                  text: value,
                  style: fitText(14, FontWeight.w800, TC.slate800),
                  children: [
                    TextSpan(
                      text: ' $unit',
                      style: fitText(11, FontWeight.w500, TC.slate500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xCCE2E8F0)),
        boxShadow: const [
          BoxShadow(
              color: Color(0x0D000000), blurRadius: 14, offset: Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          children: [
            Container(
              height: 4,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    TC.blue600,
                    Color(0xFF0EA5E9),
                    Color(0xFF4F46E5),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: TC.blue50,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: TC.blue100),
                        ),
                        child: Icon(j.icon, size: 26, color: TC.blue600),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(j.label,
                                    style: fitText(
                                        16, FontWeight.w700, TC.slate900)),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xCCDBEAFE),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text('Outdoor',
                                      style: fitText(
                                          10, FontWeight.w700, TC.blue700)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text('Target Split: ${j.targetPace} / km',
                                style:
                                    fitText(12, FontWeight.w500, TC.slate500)),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.of(context).maybePop(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: TC.blue50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('Ganti Mode',
                              style:
                                  fitText(12, FontWeight.w600, TC.blue600)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.only(top: 12),
                    decoration: const BoxDecoration(
                      border: Border(top: BorderSide(color: TC.slate100)),
                    ),
                    child: Row(
                      children: [
                        stat('JARAK TARGET',
                            j.targetKm.toStringAsFixed(1), 'KM'),
                        const SizedBox(width: 8),
                        stat('EST. KALORI', '${j.estKkal30}', 'kcal'),
                        const SizedBox(width: 8),
                        stat('EST. DURASI', '30', 'mnt'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------- Countdown

  Widget _buildCountdown() {
    return AnimatedBuilder(
      animation: _c,
      builder: (context, _) {
        var sisa = 3 - (_c.value * 3).floor();
        if (sisa < 1) sisa = 1;
        return Column(
          children: [
            SizedBox(
              width: 224,
              height: 224,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 224,
                    height: 224,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0x1F60A5FA),
                    ),
                  ),
                  SizedBox(
                    width: 192,
                    height: 192,
                    child: CustomPaint(
                      painter: _RingPainter(progress: 1 - _c.value),
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('SIAP MULAI',
                          style: fitText(12, FontWeight.w800,
                              const Color(0xFF3B82F6),
                              letterSpacing: 1.5)),
                      Text('$sisa',
                          style: fitText(52, FontWeight.w800, TC.slate900,
                              letterSpacing: -1)),
                      Text('Detik Persiapan',
                          style: fitText(11, FontWeight.w500, TC.slate400)),
                    ],
                  ),
                  Positioned(
                    top: 8,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: TC.blue100),
                        boxShadow: const [
                          BoxShadow(
                              color: Color(0x1A000000),
                              blurRadius: 6,
                              offset: Offset(0, 3)),
                        ],
                      ),
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                            color: Color(0xFF155DFC), shape: BoxShape.circle),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 6),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 270),
              child: Text(
                '“Kenakan sepatumu dan mulai langkah pertamamu sekarang juga!”',
                textAlign: TextAlign.center,
                style: fitText(12, FontWeight.w600, TC.slate600),
              ),
            ),
          ],
        );
      },
    );
  }

  // --------------------------------------------------------------- Checklist

  Widget _buildChecklist() {
    Widget row(String text, String trailing, Color trailingColor) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: const BoxDecoration(
                      color: TC.emerald100, shape: BoxShape.circle),
                  child: const Icon(Icons.check_rounded,
                      size: 13, color: TC.emerald600),
                ),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(text,
                      style: fitText(12, FontWeight.w500, TC.slate700)),
                ),
              ],
            ),
          ),
          Text(trailing, style: fitText(11, FontWeight.w600, trailingColor)),
        ],
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xB3E2E8F0)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('PEMERIKSAAN SISTEM',
                  style: fitText(11, FontWeight.w800, TC.slate400,
                      letterSpacing: 0.8)),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: TC.emerald50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Semua Normal',
                    style: fitText(10, FontWeight.w600, TC.emerald600)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          row('GPS Sinyal Kuat & Akurat', 'Akurasi 3m', TC.emerald600),
          const SizedBox(height: 10),
          row('Pelacakan Rute & Elevasi', 'Aktif', TC.slate500),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------- CTA

  Widget _buildCta() {
    return Column(
      children: [
        GestureDetector(
          onTap: _mulai,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                colors: [Color(0xFF1D61E7), TC.blue600, TC.sky600],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x73155DFC),
                  blurRadius: 25,
                  spreadRadius: -5,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                      color: Color(0x33FFFFFF), shape: BoxShape.circle),
                  child: const Icon(Icons.play_arrow_rounded,
                      size: 18, color: Colors.white),
                ),
                const SizedBox(width: 12),
                Text('MULAI SEKARANG',
                    style: fitText(16, FontWeight.w800, Colors.white,
                        letterSpacing: 0.5)),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AnimatedBuilder(
                animation: _c,
                builder: (_, __) {
                  var sisa = 3 - (_c.value * 3).floor();
                  if (sisa < 1) sisa = 1;
                  return Row(
                    children: [
                      const Icon(Icons.schedule_rounded,
                          size: 14, color: TC.slate500),
                      const SizedBox(width: 4),
                      Text('Mulai otomatis (${sisa}s)',
                          style: fitText(12, FontWeight.w600, TC.slate500)),
                    ],
                  );
                },
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Text('Batal',
                    style: fitText(12, FontWeight.w600, TC.rose500)),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Cincin hitung mundur bergradasi biru → cyan.
class _RingPainter extends CustomPainter {
  _RingPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width / 2 - 8;
    final rect = Rect.fromCircle(center: center, radius: radius);

    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = TC.slate200
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9.6,
    );

    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress.clamp(0.0, 1.0),
      false,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF155DFC), Color(0xFF06B6D4)],
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 9.6
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => old.progress != progress;
}