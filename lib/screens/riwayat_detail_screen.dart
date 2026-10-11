import 'package:flutter/material.dart';
import '../models/riwayat_detail.dart';
import '../theme/fit_colors.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/speed_chart.dart';
import '../widgets/square_icon_button.dart';
import 'unduh_riwayat_screen.dart';

class RiwayatDetailScreen extends StatefulWidget {
  const RiwayatDetailScreen({super.key, required this.detail});

  final RiwayatDetail detail;

  @override
  State<RiwayatDetailScreen> createState() => _RiwayatDetailScreenState();
}

class _RiwayatDetailScreenState extends State<RiwayatDetailScreen> {
  // true = sumbu X berupa durasi (menit), false = jarak (km).
  bool _byDuration = true;

  RiwayatDetail get _d => widget.detail;

  void _openUnduh() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => UnduhRiwayatScreen(detail: _d)),
    );
  }

  List<String> get _xLabels {
    final labels = <String>[];
    if (_byDuration) {
      for (var m = 0; m <= _d.axisMinutes; m += 10) {
        labels.add(m == _d.axisMinutes ? '$m mnt' : '$m');
      }
    } else {
      for (var k = 0; k <= _d.axisKm; k++) {
        labels.add(k == _d.axisKm ? '$k km' : '$k');
      }
    }
    return labels;
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
                _buildTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 8, 24, 130),
                    child: Column(
                      children: [
                        _buildHeaderCard(),
                        const SizedBox(height: 16),
                        _buildStatsGrid(),
                        const SizedBox(height: 16),
                        _buildSpeedCard(),
                        const SizedBox(height: 16),
                        _buildPaceCard(),
                        const SizedBox(height: 16),
                        _buildDownloadButton(),
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

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SquareIconButton(
            icon: Icons.chevron_left_rounded,
            label: 'Kembali',
            onTap: () => Navigator.of(context).maybePop(),
          ),
          Text(
            'Detail Riwayat',
            style: fitText(18, FontWeight.w700, FitColors.slate900,
                letterSpacing: -0.2),
          ),
          SquareIconButton(
            icon: Icons.share_outlined,
            label: 'Bagikan',
            onTap: _openUnduh,
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------ Kartu header

  Widget _buildHeaderCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: FitColors.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [FitColors.blue500, FitColors.blue600],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x402563EB),
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              _d.isRun
                  ? Icons.directions_run_rounded
                  : Icons.directions_walk_rounded,
              size: 28,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      _d.title,
                      style: fitText(18, FontWeight.w800, FitColors.slate900,
                          letterSpacing: -0.3),
                    ),
                    if (_d.targetReached)
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: FitColors.emerald50,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: FitColors.emerald200),
                        ),
                        child: Text(
                          'Target Tercapai 🎯',
                          style: fitText(
                              10, FontWeight.w700, FitColors.emerald700),
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  _d.dateShort,
                  style: fitText(12, FontWeight.w500, FitColors.slate400),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded,
              size: 22, color: FitColors.slate300),
        ],
      ),
    );
  }

  // ------------------------------------------------------- Kartu statistik

  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _statCard(
                label: 'Jarak',
                labelColor: const Color(0xFFBE123C),
                icon: Icons.trending_up_rounded,
                accent: FitColors.rose500,
                iconBg: FitColors.rose100,
                bg: FitColors.rose50,
                border: FitColors.rose100,
                value: _d.distance,
                unit: 'km',
                note: _d.distanceNote,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statCard(
                label: 'Kalori',
                labelColor: const Color(0xFF92400E),
                icon: Icons.local_fire_department_rounded,
                accent: FitColors.amber500,
                iconBg: const Color(0xFFFEF3C7),
                bg: const Color(0xFFFFFBEB),
                border: const Color(0xFFFEF3C7),
                value: _d.calories,
                unit: 'kkal',
                note: _d.caloriesNote,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _statCard(
                label: 'Waktu',
                labelColor: FitColors.emerald700,
                icon: Icons.schedule_rounded,
                accent: FitColors.emerald600,
                iconBg: FitColors.emerald100,
                bg: FitColors.emerald50,
                border: FitColors.emerald100,
                value: _d.duration,
                unit: '',
                note: _d.durationNote,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _statCard(
                label: 'Langkah',
                labelColor: const Color(0xFF075985),
                icon: Icons.directions_walk_rounded,
                accent: const Color(0xFF0284C7),
                iconBg: const Color(0xFFE0F2FE),
                bg: const Color(0xFFF0F9FF),
                border: const Color(0xFFE0F2FE),
                value: _d.steps,
                unit: 'langkah',
                note: _d.stepsNote,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _statCard({
    required String label,
    required Color labelColor,
    required IconData icon,
    required Color accent,
    required Color iconBg,
    required Color bg,
    required Color border,
    required String value,
    required String unit,
    required String note,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: fitText(12, FontWeight.w600, labelColor)),
              Container(
                width: 28,
                height: 28,
                decoration:
                    BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, size: 15, color: accent),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text.rich(
            TextSpan(
              text: value,
              style: fitText(24, FontWeight.w800, FitColors.slate900,
                  letterSpacing: -0.4),
              children: [
                if (unit.isNotEmpty)
                  TextSpan(
                    text: ' $unit',
                    style: fitText(12, FontWeight.w600, accent),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(note, style: fitText(10.5, FontWeight.w500, FitColors.slate400)),
        ],
      ),
    );
  }

  // ----------------------------------------------------------- Grafik kecepatan

  Widget _buildSpeedCard() {
    final labels = _xLabels;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: FitColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: FitColors.electric,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'GRAFIK KECEPATAN',
                    style: fitText(12.5, FontWeight.w800, FitColors.slate900,
                        letterSpacing: 0.3),
                  ),
                ],
              ),
              _buildToggle(),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                _d.avgSpeed,
                style: fitText(28, FontWeight.w800, FitColors.slate900,
                    letterSpacing: -0.5),
              ),
              const SizedBox(width: 6),
              Text('km/jam rata-rata',
                  style: fitText(12, FontWeight.w500, FitColors.slate500)),
            ],
          ),
          const SizedBox(height: 10),
          SpeedChart(
            fractions: _d.speedTimes,
            values: _d.speedValues,
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (final l in labels)
                  Text(l,
                      style: fitText(10.5, FontWeight.w500, FitColors.slate400)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggle() {
    Widget option(String label, bool selected, VoidCallback onTap) {
      return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: selected ? FitColors.softShadow : null,
          ),
          child: Text(
            label,
            style: fitText(11, FontWeight.w700,
                selected ? FitColors.blue600 : FitColors.slate400),
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: FitColors.slate100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          option('Durasi', _byDuration, () => setState(() => _byDuration = true)),
          option('KM', !_byDuration, () => setState(() => _byDuration = false)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------- Pace

  Widget _buildPaceCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F9FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: FitColors.blue100),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: FitColors.softShadow,
            ),
            child: const Icon(Icons.bolt_rounded,
                size: 24, color: FitColors.blue600),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PACE TERCEPAT',
                  style: fitText(10, FontWeight.w700, FitColors.slate500,
                      letterSpacing: 0.6),
                ),
                const SizedBox(height: 2),
                Wrap(
                  spacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(
                      '${_d.bestPace} /km',
                      style: fitText(18, FontWeight.w800, FitColors.slate900,
                          letterSpacing: -0.3),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: FitColors.emerald100,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        _d.bestPaceAt,
                        style: fitText(
                            10, FontWeight.w700, FitColors.emerald700),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('Zona Denyut',
                  style: fitText(10, FontWeight.w500, FitColors.slate400)),
              const SizedBox(height: 4),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _d.zone,
                  style: fitText(
                      11, FontWeight.w700, const Color(0xFF4338CA)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------- Tombol unduh

  Widget _buildDownloadButton() {
    return GestureDetector(
      onTap: _openUnduh,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: const LinearGradient(
            colors: [FitColors.blue600, FitColors.blue500],
          ),
          boxShadow: FitColors.glowBlue,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.download_rounded, size: 22, color: Colors.white),
            const SizedBox(width: 8),
            Text('Unduh Riwayat',
                style: fitText(15, FontWeight.w700, Colors.white)),
          ],
        ),
      ),
    );
  }
}
