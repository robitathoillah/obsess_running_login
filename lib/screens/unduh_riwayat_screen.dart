import 'dart:math' as math;
import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/riwayat_detail.dart';
import '../theme/fit_colors.dart';
import '../widgets/app_bottom_nav.dart';
// ignore: unused_import
import '../widgets/square_icon_button.dart';

/// Foto latar kartu bagikan. Kalau gagal dimuat (offline), otomatis
/// jatuh ke gradasi gelap di bawahnya. Nanti sebaiknya diganti aset lokal,
/// misalnya Image.asset('assets/images/bg_gunung.jpg').
const String _bgUrl =
    'https://images.unsplash.com/photo-1464822759023-fed622ff2c3b?auto=format&fit=crop&w=800&q=80';

const Color _slate100 = Color(0xFFF1F5F9);
const Color _slate200 = Color(0xFFE2E8F0);
const Color _slate300 = Color(0xFFCBD5E1);
const Color _emerald400 = Color(0xFF34D399);
const Color _amber400 = Color(0xFFFBBF24);
const Color _kmBlue = Color(0xFF2563EB);

class UnduhRiwayatScreen extends StatelessWidget {
  const UnduhRiwayatScreen({super.key, required this.detail});

  final RiwayatDetail detail;

  void _toast(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: FitColors.slate800,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 120),
        ),
      );
  }

  Future<void> _copySummary(BuildContext context, String message) async {
    await Clipboard.setData(ClipboardData(text: detail.summaryText));
    if (!context.mounted) return;
    _toast(context, message);
  }

  void _download(BuildContext context) {
    // TODO: render kartu jadi gambar (RepaintBoundary) lalu simpan ke galeri.
    // Butuh package tambahan (misalnya `gal`) dan izin penyimpanan.
    _toast(context, 'Simpan gambar ke galeri belum aktif');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FitColors.bg,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildTopBar(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 130),
                    child: Column(
                      children: [
                        _buildShareCard(),
                        const SizedBox(height: 18),
                        _buildDownloadButton(context),
                        const SizedBox(height: 14),
                        _buildShareRow(context),
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
              child: AppBottomNav(current: AppTab.progres),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------- Top bar

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _CircleButton(
            icon: Icons.chevron_left_rounded,
            iconSize: 24,
            iconColor: FitColors.slate700,
            label: 'Kembali',
            onTap: () => Navigator.of(context).maybePop(),
          ),
          Column(
            children: [
              Text(
                'Unduh Riwayat',
                style: fitText(16, FontWeight.w700, FitColors.slate900),
              ),
              Text(
                'Bagikan Hasil Olahraga',
                style: fitText(12, FontWeight.w500, FitColors.slate400),
              ),
            ],
          ),
          _CircleButton(
            icon: Icons.share,
            iconSize: 18,
            iconColor: _kmBlue,
            label: 'Salin ringkasan',
            onTap: () => _copySummary(context, 'Ringkasan latihan disalin'),
          ),
        ],
      ),
    );
  }

  // -------------------------------------------------------- Kartu bagikan

  Widget _buildShareCard() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x400F172A),
            blurRadius: 35,
            spreadRadius: -10,
            offset: Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: SizedBox(
          height: 510,
          width: double.infinity,
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Lapisan dasar (tampil saat foto belum termuat / gagal).
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.35, 0.62, 1.0],
                    colors: [
                      Color(0xFF4A6785),
                      Color(0xFF2B3D55),
                      Color(0xFF141C2B),
                      Color(0xFF080C14),
                    ],
                  ),
                ),
              ),
              // Foto latar.
              Image.network(
                _bgUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
              // Overlay gelap supaya teks terbaca.
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.0, 0.55, 1.0],
                    colors: [
                      Color(0x730F172A),
                      Color(0xBF0F172A),
                      Color(0xF00B0F19),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildHeader(),
                    Expanded(child: Center(child: _buildDistance())),
                    _buildRouteMinimap(),
                    _buildFooter(),
                  ],
                ),
              ),
              // Border tipis di atas semuanya.
              IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0x33FFFFFF)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        _Glass(
          radius: 20,
          color: const Color(0x8C0F172A),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: _emerald400,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                detail.sessionLabel,
                style: fitText(11, FontWeight.w600, _slate100,
                    letterSpacing: 0.3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          detail.dateLong,
          style: fitText(10, FontWeight.w500, _slate300),
        ),
      ],
    );
  }

  Widget _buildDistance() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'JARAK',
          style: fitText(11, FontWeight.w800, const Color(0xE6CBD5E1),
              letterSpacing: 1.6),
        ),
        const SizedBox(height: 4),
        Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic,
          children: [
            Text(
              detail.distance,
              style: fitText(48, FontWeight.w800, Colors.white,
                  letterSpacing: -1.2),
            ),
            const SizedBox(width: 6),
            Text(
              'KM',
              style: fitText(20, FontWeight.w800, _kmBlue),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildRouteMinimap() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: _Glass(
        radius: 16,
        sigma: 6,
        color: const Color(0x4D000000),
        borderColor: const Color(0x1AFFFFFF),
        child: SizedBox(
          height: 128,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: CustomPaint(painter: _RoutePainter()),
                ),
              ),
              Positioned(
                left: 12,
                bottom: 6,
                child: Opacity(
                  opacity: 0.8,
                  child: Row(
                    children: [
                      const Icon(Icons.directions_run_rounded,
                          size: 11, color: _kmBlue),
                      const SizedBox(width: 6),
                      Text(
                        detail.routeName,
                        style: fitText(9, FontWeight.w600, _slate300),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 12,
                top: 6,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0x3310B981),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0x4D34D399)),
                  ),
                  child: Text(
                    '+28m Elev',
                    style: fitText(9, FontWeight.w700, _emerald400),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildStatsPanel(),
          const SizedBox(height: 14),
          _buildPacePill(),
          const SizedBox(height: 14),
          _buildBrandPill(),
        ],
      ),
    );
  }

  Widget _buildStatsPanel() {
    Widget cell(String label, Widget value) {
      return Expanded(
        child: Column(
          children: [
            Text(
              label,
              style: fitText(9, FontWeight.w700, _slate300, letterSpacing: 0.5),
            ),
            const SizedBox(height: 2),
            value,
          ],
        ),
      );
    }

    Widget divider() => Container(
          width: 1,
          height: 30,
          color: const Color(0x1AFFFFFF),
        );

    return _Glass(
      radius: 16,
      color: const Color(0x40000000),
      borderColor: const Color(0x1AFFFFFF),
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: Row(
        children: [
          cell(
            'WAKTU',
            Text(detail.duration,
                style: fitText(14, FontWeight.w800, Colors.white)),
          ),
          divider(),
          cell(
            'LANGKAH',
            Text(detail.steps,
                style: fitText(14, FontWeight.w800, Colors.white)),
          ),
          divider(),
          cell(
            'KALORI',
            Text.rich(
              TextSpan(
                text: detail.calories,
                style: fitText(14, FontWeight.w800, _amber400),
                children: [
                  TextSpan(
                    text: ' kkal',
                    style: fitText(10, FontWeight.w400, _slate200),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPacePill() {
    return _Glass(
      radius: 20,
      color: const Color(0x8C0F172A),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.bolt_rounded, size: 15, color: _amber400),
          const SizedBox(width: 6),
          Text(
            'Pace Rata-rata: ${detail.avgPace} /km',
            style: fitText(12, FontWeight.w600, _slate100),
          ),
        ],
      ),
    );
  }

  Widget _buildBrandPill() {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 4, 16, 4),
      decoration: BoxDecoration(
        color: const Color(0xF2FFFFFF),
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1A000000),
            blurRadius: 6,
            offset: Offset(0, 4),
            spreadRadius: -1,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: _kmBlue,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.directions_run_rounded,
                size: 14, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'GERAK',
                style: fitText(10, FontWeight.w800, FitColors.slate900,
                    letterSpacing: 0.5),
              ),
              Text(
                'Running Tracker',
                style: fitText(8, FontWeight.w500, FitColors.slate500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------- Tombol di bawah kartu

  Widget _buildDownloadButton(BuildContext context) {
    return GestureDetector(
      onTap: () => _download(context),
      child: Container(
        width: double.infinity,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [FitColors.blue600, FitColors.blue700],
          ),
          boxShadow: FitColors.glowBlue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.download_rounded, size: 20, color: Colors.white),
            const SizedBox(width: 10),
            Text('Download Gambar',
                style: fitText(14, FontWeight.w700, Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _buildShareRow(BuildContext context) {
    Widget circle(IconData icon, double iconSize, Color bg, Color border,
        Color color, String label, VoidCallback onTap) {
      return Semantics(
        button: true,
        label: label,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              border: Border.all(color: border),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x0D000000),
                  blurRadius: 2,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            child: Icon(icon, size: iconSize, color: color),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Bagi langsung ke:',
              style: fitText(14, FontWeight.w700, FitColors.slate700)),
          Row(
            children: [
              // TODO: buka WhatsApp langsung (butuh package url_launcher).
              circle(
                Icons.chat_rounded,
                24,
                FitColors.emerald50,
                FitColors.emerald100,
                FitColors.emerald600,
                'WhatsApp',
                () => _copySummary(
                  context,
                  'Ringkasan disalin, tempel di chat WhatsApp',
                ),
              ),
              const SizedBox(width: 12),
              circle(
                Icons.link_rounded,
                20,
                FitColors.slate100,
                FitColors.slate200,
                FitColors.slate600,
                'Salin tautan',
                () => _copySummary(context, 'Ringkasan latihan disalin'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------ Widget bantu

/// Tombol bulat putih di top bar (sesuai desain Stitch).
class _CircleButton extends StatelessWidget {
  const _CircleButton({
    required this.icon,
    required this.iconSize,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final double iconSize;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: _slate100),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 2,
                offset: Offset(0, 1),
              ),
            ],
          ),
          child: Icon(icon, size: iconSize, color: iconColor),
        ),
      ),
    );
  }
}

/// Panel kaca buram (frosted glass) di atas foto latar.
class _Glass extends StatelessWidget {
  const _Glass({
    required this.child,
    required this.radius,
    required this.color,
    this.borderColor = const Color(0x29FFFFFF),
    this.padding,
    this.sigma = 5,
  });

  final Widget child;
  final double radius;
  final Color color;
  final Color borderColor;
  final EdgeInsetsGeometry? padding;
  final double sigma;

  @override
  Widget build(BuildContext context) {
    final r = BorderRadius.circular(radius);
    return ClipRRect(
      borderRadius: r,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: color,
            borderRadius: r,
            border: Border.all(color: borderColor),
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Rute lari bercahaya neon, mengikuti SVG di desain Stitch (viewBox 320x120).
class _RoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Skala seragam + tengahkan, sama seperti perilaku SVG viewBox.
    final s = math.min(size.width / 320, size.height / 120);
    final dx = (size.width - 320 * s) / 2;
    final dy = (size.height - 120 * s) / 2;
    Offset p(double x, double y) => Offset(dx + x * s, dy + y * s);

    // M 35,95 Q 55,60 85,75 T 140,50 T 195,70 T 245,35 T 285,42
    // (titik kontrol "T" sudah dihitung manual; kontrol terakhir sedikit
    // diturunkan supaya puncak kurva tidak terpotong).
    final path = Path()..moveTo(p(35, 95).dx, p(35, 95).dy);
    void q(double cx, double cy, double x, double y) {
      final c = p(cx, cy);
      final e = p(x, y);
      path.quadraticBezierTo(c.dx, c.dy, e.dx, e.dy);
    }

    q(55, 60, 85, 75);
    q(115, 90, 140, 50);
    q(165, 10, 195, 70);
    q(225, 130, 245, 35);
    q(265, -20, 285, 42);

    final rect = Rect.fromLTWH(dx, dy, 320 * s, 120 * s);
    const gradient = LinearGradient(
      begin: Alignment.bottomLeft,
      end: Alignment.topRight,
      colors: [Color(0xE638BDF8), Color(0xFF00F5D4), Color(0xE660A5FA)],
    );

    // Lapisan glow.
    canvas.drawPath(
      path,
      Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4 * s
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, 3 * s),
    );

    // Garis utama.
    canvas.drawPath(
      path,
      Paint()
        ..shader = gradient.createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4 * s
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    // Garis putus-putus putih tipis di atasnya.
    final dotPaint = Paint()..color = const Color(0x99FFFFFF);
    for (final metric in path.computeMetrics()) {
      double d = 0;
      while (d < metric.length) {
        final t = metric.getTangentForOffset(d);
        if (t != null) canvas.drawCircle(t.position, 0.75 * s, dotPaint);
        d += 5 * s;
      }
    }

    // Titik awal (hijau) dan akhir (biru, dengan cincin).
    final start = p(35, 95);
    canvas.drawCircle(start, 6.5 * s, Paint()..color = Colors.white);
    canvas.drawCircle(start, 4.5 * s, Paint()..color = const Color(0xFF10B981));

    final end = p(285, 42);
    canvas.drawCircle(
      end,
      9 * s,
      Paint()
        ..color = const Color(0x9938BDF8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5 * s,
    );
    canvas.drawCircle(end, 7 * s, Paint()..color = Colors.white);
    canvas.drawCircle(end, 5 * s, Paint()..color = const Color(0xFF38BDF8));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}