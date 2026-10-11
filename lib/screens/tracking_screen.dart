import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import '../models/sesi_olahraga.dart';
import '../theme/fit_colors.dart';
import '../theme/track_colors.dart';
import '../widgets/track_circle_button.dart';
import 'ringkasan_screen.dart';

/// Layar 3: sesi berjalan (peta, timer, jarak, pace, kalori, langkah).
///
/// TODO: nilai jarak/langkah/kalori di sini masih SIMULASI berdasarkan
/// kecepatan rata-rata. Untuk data sungguhan pakai `geolocator` (posisi GPS)
/// dan `pedometer` (langkah), lalu ganti peta ilustrasi dengan
/// `flutter_map` / `google_maps_flutter`.
class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key, required this.jenis});

  final JenisOlahraga jenis;

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  Timer? _timer;
  int _detik = 0;
  bool _jeda = false;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_jeda || !mounted) return;
      setState(() => _detik++);
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  HasilSesi _hasil() {
    final j = widget.jenis;
    final jarak = _detik * j.kmPerJam / 3600;
    return HasilSesi(
      jenis: j,
      durasi: Duration(seconds: _detik),
      jarakKm: jarak,
      langkah: (jarak * j.langkahPerKm).round(),
      kalori: (_detik / 60 * j.kkalPerMenit).round(),
      tanggal: DateTime.now(),
    );
  }

  void _toggleJeda() {
    setState(() => _jeda = !_jeda);
    if (_jeda) {
      _pulse.stop();
    } else {
      _pulse.repeat();
    }
  }

  Future<void> _selesai() async {
    final hasil = _hasil();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => _FinishDialog(hasil: hasil),
    );
    if (ok != true || !mounted) return;
    _timer?.cancel();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => RingkasanScreen(hasil: hasil)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasil = _hasil();
    final aksen = _jeda ? TC.amber500 : TC.blue600;

    return Scaffold(
      backgroundColor: FitColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: _MapPainter(jeda: _jeda, pulse: _pulse),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildHud(hasil, aksen),
                        const SizedBox(height: 12),
                        _buildControls(),
                        const SizedBox(height: 16),
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

  // ---------------------------------------------------------------- Top bar

  Widget _buildTopBar() {
    return Container(
      color: const Color(0x66FFFFFF),
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(8, 4, 12, 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: TC.slate100),
              boxShadow: const [
                BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 3,
                    offset: Offset(0, 1)),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(widget.jenis.icon, size: 20, color: TC.blue600),
                const SizedBox(width: 4),
                Text('GERAK',
                    style: fitText(12, FontWeight.w800, TC.blue600,
                        letterSpacing: 0.6)),
              ],
            ),
          ),
          Row(
            children: [
              // TODO: sambungkan ke fitur layar penuh & pusatkan lokasi.
              TrackCircleButton(
                icon: Icons.open_in_full_rounded,
                size: 32,
                iconSize: 16,
                label: 'Layar penuh',
                onTap: () {},
              ),
              const SizedBox(width: 8),
              TrackCircleButton(
                icon: Icons.my_location_rounded,
                size: 32,
                iconSize: 16,
                label: 'Pusatkan lokasi',
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------------- HUD

  Widget _buildHud(HasilSesi h, Color aksen) {
    Widget unitValue(String value, String unit, Color color) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Text(value, style: fitText(20, FontWeight.w700, color)),
          const SizedBox(width: 2),
          Text(unit, style: fitText(10, FontWeight.w600, color)),
        ],
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: TC.slate100),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 30,
            spreadRadius: -5,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: 20,
              color: aksen,
            ),
            if (_jeda)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 6),
                decoration: const BoxDecoration(
                  color: Color(0x1AF59E0B),
                  border:
                      Border(bottom: BorderSide(color: Color(0xCCFDE68A))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                          color: TC.amber500, shape: BoxShape.circle),
                    ),
                    const SizedBox(width: 6),
                    Text('SESI DIJEDA (PAUSED)',
                        style: fitText(
                            11, FontWeight.w800, const Color(0xFF92400E),
                            letterSpacing: 0.5)),
                  ],
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              child: Column(
                children: [
                  Text(
                    h.durasiJam,
                    style: fitText(
                      32,
                      FontWeight.w800,
                      _jeda ? TC.amber600 : TC.slate900,
                      letterSpacing: -0.5,
                    ).copyWith(
                        fontFeatures: const [FontFeature.tabularFigures()]),
                  ),
                  const SizedBox(height: 2),
                  Text('DURASI WAKTU',
                      style: fitText(10, FontWeight.w700, TC.slate500,
                          letterSpacing: 1)),
                  const SizedBox(height: 12),
                  Container(height: 1, color: TC.slate100),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Text('Jarak',
                                style:
                                    fitText(10, FontWeight.w500, TC.slate500)),
                            const SizedBox(height: 2),
                            unitValue(h.jarakText, 'km', TC.blue600),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: const BoxDecoration(
                            border: Border.symmetric(
                              vertical: BorderSide(color: TC.slate100),
                            ),
                          ),
                          child: Column(
                            children: [
                              Text('Pace Rata-rata',
                                  style: fitText(
                                      10, FontWeight.w700, TC.slate700)),
                              const SizedBox(height: 4),
                              Text('${h.paceKoma}/KM',
                                  style: fitText(
                                      14, FontWeight.w800, TC.slate800)),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Text('Kalori',
                                style: fitText(
                                    10, FontWeight.w500, TC.amber600)),
                            const SizedBox(height: 2),
                            unitValue('${h.kalori}', 'kcal', TC.amber600),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(height: 1, color: TC.slate100),
                  const SizedBox(height: 8),
                  Text('Langkah',
                      style: fitText(10, FontWeight.w500, TC.slate500)),
                  const SizedBox(height: 4),
                  Text(h.langkahText,
                      style: fitText(16, FontWeight.w800, TC.slate900)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------- Kontrol

  Widget _buildControls() {
    Widget pill(String text, IconData icon, Color color, VoidCallback onTap) {
      return Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 48,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.28),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: Colors.white),
                const SizedBox(width: 8),
                Text(text,
                    style: fitText(14, FontWeight.w700, Colors.white,
                        letterSpacing: 0.3)),
              ],
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          pill(
            _jeda ? 'Lanjutkan' : 'Jeda',
            _jeda ? Icons.play_arrow_rounded : Icons.pause_rounded,
            _jeda ? TC.emerald600 : const Color(0xFFEF2D38),
            _toggleJeda,
          ),
          const SizedBox(width: 12),
          pill('Selesai', Icons.check_rounded, const Color(0xFF0E3A75),
              _selesai),
        ],
      ),
    );
  }
}

// ------------------------------------------------------------ Dialog selesai

class _FinishDialog extends StatelessWidget {
  const _FinishDialog({required this.hasil});

  final HasilSesi hasil;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 320),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                    color: TC.blue100, shape: BoxShape.circle),
                child: const Icon(Icons.check_rounded,
                    size: 28, color: TC.blue600),
              ),
              const SizedBox(height: 16),
              Text('Selesaikan Sesi ${hasil.jenis.label}?',
                  textAlign: TextAlign.center,
                  style: fitText(18, FontWeight.w700, TC.slate900)),
              const SizedBox(height: 4),
              Text.rich(
                TextSpan(
                  style: fitText(12, FontWeight.w400, TC.slate500),
                  children: [
                    const TextSpan(text: 'Kamu telah menempuh jarak '),
                    TextSpan(
                      text: '${hasil.jarakText} km',
                      style: fitText(12, FontWeight.w700, TC.slate700),
                    ),
                    const TextSpan(text: ' selama '),
                    TextSpan(
                      text: hasil.durasiJam,
                      style: fitText(12, FontWeight.w700, TC.slate700),
                    ),
                    const TextSpan(
                        text:
                            '. Data akan disimpan ke riwayat aktivitas.'),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        decoration: BoxDecoration(
                          color: TC.slate100,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        alignment: Alignment.center,
                        child: Text('Batal',
                            style:
                                fitText(12, FontWeight.w600, TC.slate600)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 11),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0E3A75),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: const [
                            BoxShadow(
                                color: Color(0x330E3A75),
                                blurRadius: 8,
                                offset: Offset(0, 4)),
                          ],
                        ),
                        alignment: Alignment.center,
                        child: Text('Selesaikan',
                            style:
                                fitText(12, FontWeight.w700, Colors.white)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------- Peta

/// Peta ilustrasi (port dari SVG Stitch, viewBox 360x620, mode "cover").
class _MapPainter extends CustomPainter {
  _MapPainter({required this.jeda, required this.pulse})
      : super(repaint: pulse);

  final bool jeda;
  final Animation<double> pulse;

  Paint _fill(Color c) => Paint()..color = c;

  Paint _line(Color c, double w) => Paint()
    ..color = c
    ..style = PaintingStyle.stroke
    ..strokeWidth = w
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  Path _poly(List<double> v, {bool close = false}) {
    final p = Path()..moveTo(v[0], v[1]);
    for (var i = 2; i < v.length; i += 2) {
      p.lineTo(v[i], v[i + 1]);
    }
    if (close) p.close();
    return p;
  }

  void _label(Canvas canvas, String t, double x, double y, double size,
      Color color, FontWeight w,
      {double rotateDeg = 0}) {
    final tp = TextPainter(
      text: TextSpan(
        text: t,
        style: TextStyle(
            fontSize: size, color: color, fontWeight: w, letterSpacing: 0.3),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    canvas.save();
    canvas.translate(x, y);
    if (rotateDeg != 0) canvas.rotate(rotateDeg * math.pi / 180);
    tp.paint(canvas, Offset(0, -size * 0.85));
    canvas.restore();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, _fill(const Color(0xFFE8EDE5)));

    final s = math.max(size.width / 360, size.height / 620);
    canvas.save();
    canvas.clipRect(Offset.zero & size);
    canvas.translate((size.width - 360 * s) / 2, (size.height - 620 * s) / 2);
    canvas.scale(s);
    _drawMap(canvas);
    canvas.restore();
  }

  void _drawMap(Canvas canvas) {
    // Daratan dasar.
    canvas.drawRect(
        const Rect.fromLTWH(0, 0, 360, 620), _fill(const Color(0xFFF4F3F0)));

    // Blok permukiman.
    canvas.drawPath(_poly([20, 30, 110, 30, 105, 110, 15, 100], close: true),
        _fill(const Color(0xFFEBEAE5)));
    canvas.drawPath(_poly([240, 40, 345, 40, 340, 130, 235, 120], close: true),
        _fill(const Color(0xFFECEBE7)));
    canvas.drawPath(_poly([20, 130, 100, 140, 95, 220, 15, 210], close: true),
        _fill(const Color(0xFFEBEAE5)));
    canvas.drawPath(
        _poly([245, 260, 345, 270, 340, 360, 240, 350], close: true),
        _fill(const Color(0xFFECEBE7)));
    canvas.drawPath(_poly([20, 440, 110, 430, 105, 520, 15, 510], close: true),
        _fill(const Color(0xFFEAE9E4)));
    canvas.drawPath(
        _poly([240, 480, 345, 470, 340, 580, 235, 570], close: true),
        _fill(const Color(0xFFEAE9E4)));

    // Taman (GBK dan sekitarnya).
    canvas.drawPath(
      Path()
        ..moveTo(125, 50)
        ..cubicTo(180, 45, 220, 70, 225, 120)
        ..cubicTo(230, 170, 190, 210, 135, 205)
        ..cubicTo(90, 200, 85, 150, 90, 110)
        ..cubicTo(95, 70, 110, 50, 125, 50)
        ..close(),
      _fill(const Color(0xF2D1E7D1)),
    );
    canvas.drawPath(
      Path()
        ..moveTo(140, 85)
        ..cubicTo(175, 85, 195, 105, 195, 135)
        ..cubicTo(195, 165, 170, 185, 140, 185)
        ..cubicTo(110, 185, 105, 160, 105, 135)
        ..cubicTo(105, 105, 115, 85, 140, 85)
        ..close(),
      _fill(const Color(0xFFC3DEC3)),
    );
    canvas.drawPath(
      Path()
        ..moveTo(-10, 270)
        ..cubicTo(40, 260, 70, 285, 75, 340)
        ..cubicTo(80, 395, 30, 420, -10, 410)
        ..close(),
      _fill(const Color(0xCCD9ECD9)),
    );
    canvas.drawPath(
      Path()
        ..moveTo(280, 150)
        ..cubicTo(330, 140, 370, 165, 370, 220)
        ..cubicTo(350, 250, 300, 240, 280, 210)
        ..close(),
      _fill(const Color(0xB3D9ECD9)),
    );

    // Sungai.
    final river = Path()
      ..moveTo(320, 0)
      ..cubicTo(310, 60, 290, 120, 285, 180)
      ..cubicTo(280, 240, 310, 310, 325, 380)
      ..cubicTo(340, 450, 330, 530, 315, 620);
    canvas.drawPath(river, _line(const Color(0xFFC4DBF6), 16));
    canvas.drawPath(river, _line(const Color(0xFFA5CBF3), 10));

    // Jalan sekunder.
    final grid = <List<double>>[
      [-10, 120, 370, 125],
      [-10, 230, 370, 235],
      [-10, 350, 370, 345],
      [-10, 460, 370, 465],
      [70, -10, 65, 630],
      [290, -10, 295, 630],
      [10, 30, 350, 380],
      [350, 70, 20, 400],
    ];
    for (final g in grid) {
      canvas.drawPath(_poly(g), _line(const Color(0xFFDCDAD4), 4.5));
    }
    for (final g in grid) {
      canvas.drawPath(_poly(g), _line(Colors.white, 3));
    }

    // Jalan arteri (Sudirman) dan Gatot Subroto.
    final arteri = _poly([175, -10, 180, 240, 165, 390, 150, 630]);
    canvas.drawPath(arteri, _line(const Color(0xFFE5C378), 8));
    canvas.drawPath(arteri, _line(const Color(0xFFFFE89E), 5.5));
    final gatsu = _poly([-10, 280, 370, 285]);
    canvas.drawPath(gatsu, _line(const Color(0xFFE5C378), 7));
    canvas.drawPath(gatsu, _line(const Color(0xFFFFE89E), 4.5));

    // Label tempat.
    const abu = Color(0xFF64748B);
    _label(canvas, 'Gelora Bung Karno', 88, 132, 9, const Color(0xFF2E7D32),
        FontWeight.w700);
    _label(canvas, 'Hutan Kota GBK', 108, 145, 7.5, const Color(0xFF43A047),
        FontWeight.w600);
    _label(canvas, 'Senayan', 212, 95, 8.5, abu, FontWeight.w600);
    _label(canvas, 'Palmerah', 20, 80, 8.5, abu, FontWeight.w600);
    _label(canvas, 'SCBD Lot 8', 210, 330, 8.5, abu, FontWeight.w600);
    _label(canvas, 'Bendungan Hilir', 20, 325, 8.5, abu, FontWeight.w600);
    _label(canvas, 'Kuningan Barat', 205, 435, 8.5, abu, FontWeight.w600);
    _label(canvas, 'Mampang Prapatan', 30, 500, 8.5, abu, FontWeight.w600);
    const jalan = Color(0xFF94A3B8);
    _label(canvas, 'JL. JEND. SUDIRMAN', 185, 80, 7, jalan, FontWeight.w600,
        rotateDeg: 88);
    _label(canvas, 'JL. P. ANTASARI', 168, 470, 7, jalan, FontWeight.w600,
        rotateDeg: 86);
    _label(canvas, 'JL. GATOT SUBROTO', 35, 275, 7, jalan, FontWeight.w600);

    // Rute lari.
    final route = Path()
      ..moveTo(50, 560)
      ..cubicTo(70, 520, 85, 480, 100, 430)
      ..cubicTo(115, 380, 145, 360, 160, 330)
      ..cubicTo(175, 290, 155, 240, 140, 210)
      ..cubicTo(130, 185, 145, 150, 170, 145)
      ..cubicTo(195, 140, 215, 160, 215, 190)
      ..cubicTo(215, 225, 185, 260, 172, 285);

    canvas.drawPath(
      route,
      _line(const Color(0x663B82F6), 9)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2),
    );
    canvas.drawPath(route, _line(Colors.white, 6.5));
    canvas.drawPath(
      route,
      _line(Colors.white, 4.5)
        ..shader = const LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          stops: [0, 0.7, 1],
          colors: [Color(0xFFEF4444), Color(0xFFF97316), Color(0xFF3B82F6)],
        ).createShader(route.getBounds()),
    );

    // Penanda 1 km.
    canvas.drawCircle(const Offset(142, 206), 6, _fill(const Color(0xFF1E60BE)));
    canvas.drawCircle(const Offset(142, 206), 6, _line(Colors.white, 2));
    final tp = TextPainter(
      text: const TextSpan(
        text: '1',
        style: TextStyle(
            fontSize: 6.5, color: Colors.white, fontWeight: FontWeight.w800),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(142 - tp.width / 2, 206 - tp.height / 2));

    // Titik awal.
    canvas.drawCircle(const Offset(50, 560), 5, _fill(TC.emerald500));
    canvas.drawCircle(const Offset(50, 560), 5, _line(Colors.white, 2));
    canvas.drawCircle(const Offset(50, 560), 2, _fill(Colors.white));

    // Posisi pelari (beacon).
    const pos = Offset(172, 285);
    final warna = jeda ? const Color(0xFFF59E0B) : const Color(0xFF3B82F6);
    final warnaPusat = jeda ? const Color(0xFFD97706) : const Color(0xFF2563EB);

    if (!jeda) {
      final v = pulse.value;
      canvas.drawCircle(
        pos,
        20 * (0.7 + 1.5 * v),
        _fill(warna.withOpacity(0.35 * (1 - v))),
      );
    } else {
      canvas.drawCircle(pos, 20 * 0.7, _fill(warna.withOpacity(0.35)));
    }

    canvas.save();
    canvas.translate(pos.dx, pos.dy);
    Path cone(double x, double y, double r) => Path()
      ..moveTo(0, 0)
      ..lineTo(-x, -y)
      ..arcToPoint(Offset(x, -y), radius: Radius.circular(r), clockwise: true)
      ..close();
    canvas.drawPath(cone(12, 24, 26), _fill(warna.withOpacity(0.22)));
    canvas.drawPath(cone(7, 18, 20), _fill(warnaPusat.withOpacity(0.45)));
    canvas.drawCircle(Offset.zero, 9, _fill(warnaPusat));
    canvas.drawCircle(Offset.zero, 9, _line(Colors.white, 2.5));
    canvas.drawCircle(Offset.zero, 3.5, _fill(Colors.white));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MapPainter old) => old.jeda != jeda;
}