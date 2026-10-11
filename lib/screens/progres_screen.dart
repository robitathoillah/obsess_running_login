import 'package:flutter/material.dart';
import '../models/riwayat_detail.dart';
import '../theme/fit_colors.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/square_icon_button.dart';
import 'riwayat_detail_screen.dart';

enum _Kind { jalan, lari, sepeda }

enum _Filter { semua, jalan, lari, sepeda }

class _Activity {
  const _Activity({
    required this.kind,
    required this.title,
    required this.date,
    required this.distance,
    required this.calories,
    required this.duration,
    required this.detail,
  });

  final _Kind kind;
  final String title;
  final String date;
  final String distance;
  final String calories;
  final String duration;
  final RiwayatDetail detail;
}

class ProgresScreen extends StatefulWidget {
  const ProgresScreen({super.key});

  @override
  State<ProgresScreen> createState() => _ProgresScreenState();
}

class _ProgresScreenState extends State<ProgresScreen> {
  _Filter _filter = _Filter.semua;

  // TODO: ganti data contoh ini dengan riwayat aktivitas dari backend.
  static const List<_Activity> _activities = [
    _Activity(
      kind: _Kind.jalan,
      title: 'Berjalan',
      date: '20 Sep 2026 • 06:12',
      distance: '3,2 km',
      calories: '421 kal',
      duration: '42 mnt',
      detail: RiwayatDetail(
        isRun: false,
        title: 'Berjalan',
        sessionLabel: 'Jalan Pagi + GPS Aktif',
        dateShort: '20 Sep 2026 • 06:12 WIB',
        dateLong: '20 September 2026, 06:12 WIB',
        targetReached: false,
        distance: '3,2',
        distanceNote: '+0,2 km vs sesi lalu',
        calories: '421',
        caloriesNote: 'Pembakaran lemak ringan',
        duration: '42 mnt',
        durationNote: 'Tanpa jeda panjang',
        steps: '4.480',
        stepsNote: 'Irama santai stabil',
        avgSpeed: '4.57',
        avgPace: "13'07\"",
        bestPace: "11'42\"",
        bestPaceAt: 'KM ke-1',
        zone: 'Zona 2 - Lemak',
        speedTimes: [0.0, 0.2, 0.4, 0.62, 0.82, 0.95],
        speedValues: [3.8, 4.2, 4.6, 4.9, 4.7, 4.6],
        axisMinutes: 40,
        axisKm: 3,
        routeName: 'Rute Taman Kota',
      ),
    ),
    _Activity(
      kind: _Kind.lari,
      title: 'Berlari',
      date: '19 Sep 2026 • 17:30',
      distance: '4,8 km',
      calories: '638 kal',
      duration: '1j 02m',
      detail: RiwayatDetail(
        isRun: true,
        title: 'Berlari',
        sessionLabel: 'Lari Sore + GPS Aktif',
        dateShort: '19 Sep 2026 • 17:30 WIB',
        dateLong: '19 September 2026, 17:30 WIB',
        targetReached: true,
        distance: '4,8',
        distanceNote: '+0,3 km vs sesi lalu',
        calories: '638',
        caloriesNote: 'Lemak terbakar stabil',
        duration: '1j 02m',
        durationNote: 'Tanpa jeda panjang',
        steps: '5.980',
        stepsNote: 'Irama ritmik stabil',
        avgSpeed: '8.45',
        avgPace: "5'28\"",
        bestPace: "5'28\"",
        bestPaceAt: 'KM ke-2',
        zone: 'Zona 3 - Kardio',
        speedTimes: [0.0, 0.25, 0.45, 0.65, 0.83, 0.95],
        speedValues: [5.2, 6.4, 8.1, 8.6, 9.7, 9.4],
        axisMinutes: 40,
        axisKm: 5,
        routeName: 'Rute Gelora Bung Karno',
      ),
    ),
    _Activity(
      kind: _Kind.jalan,
      title: 'Berjalan',
      date: '18 Sep 2026 • 07:15',
      distance: '2,1 km',
      calories: '287 kal',
      duration: '29 mnt',
      detail: RiwayatDetail(
        isRun: false,
        title: 'Berjalan',
        sessionLabel: 'Jalan Pagi + GPS Aktif',
        dateShort: '18 Sep 2026 • 07:15 WIB',
        dateLong: '18 September 2026, 07:15 WIB',
        targetReached: false,
        distance: '2,1',
        distanceNote: '+0,1 km vs sesi lalu',
        calories: '287',
        caloriesNote: 'Pembakaran lemak ringan',
        duration: '29 mnt',
        durationNote: 'Tanpa jeda panjang',
        steps: '2.940',
        stepsNote: 'Irama santai stabil',
        avgSpeed: '4.34',
        avgPace: "13'49\"",
        bestPace: "12'10\"",
        bestPaceAt: 'KM ke-1',
        zone: 'Zona 2 - Lemak',
        speedTimes: [0.0, 0.2, 0.42, 0.62, 0.8, 0.95],
        speedValues: [3.9, 4.3, 4.5, 4.4, 4.3, 4.2],
        axisMinutes: 30,
        axisKm: 3,
        routeName: 'Rute Sekitar Rumah',
      ),
    ),
    _Activity(
      kind: _Kind.lari,
      title: 'Berlari',
      date: '17 Sep 2026 • 15:40',
      distance: '5,6 km',
      calories: '722 kal',
      duration: '1j 12m',
      detail: RiwayatDetail(
        isRun: true,
        title: 'Berlari',
        sessionLabel: 'Lari Sore + GPS Aktif',
        dateShort: '17 Sep 2026 • 15:40 WIB',
        dateLong: '17 September 2026, 15:40 WIB',
        targetReached: true,
        distance: '5,6',
        distanceNote: '+0,8 km vs sesi lalu',
        calories: '722',
        caloriesNote: 'Lemak terbakar stabil',
        duration: '1j 12m',
        durationNote: 'Satu jeda singkat',
        steps: '6.970',
        stepsNote: 'Irama ritmik stabil',
        avgSpeed: '8.12',
        avgPace: "5'35\"",
        bestPace: "5'20\"",
        bestPaceAt: 'KM ke-3',
        zone: 'Zona 3 - Kardio',
        speedTimes: [0.0, 0.22, 0.44, 0.64, 0.82, 0.95],
        speedValues: [5.0, 6.2, 7.9, 8.4, 9.1, 8.8],
        axisMinutes: 70,
        axisKm: 6,
        routeName: 'Rute Senayan',
      ),
    ),
    _Activity(
      kind: _Kind.jalan,
      title: 'Berjalan',
      date: '16 Sep 2026 • 06:50',
      distance: '3,7 km',
      calories: '503 kal',
      duration: '51 mnt',
      detail: RiwayatDetail(
        isRun: false,
        title: 'Berjalan',
        sessionLabel: 'Jalan Pagi + GPS Aktif',
        dateShort: '16 Sep 2026 • 06:50 WIB',
        dateLong: '16 September 2026, 06:50 WIB',
        targetReached: false,
        distance: '3,7',
        distanceNote: '+0,5 km vs sesi lalu',
        calories: '503',
        caloriesNote: 'Pembakaran lemak ringan',
        duration: '51 mnt',
        durationNote: 'Tanpa jeda panjang',
        steps: '5.180',
        stepsNote: 'Irama santai stabil',
        avgSpeed: '4.35',
        avgPace: "13'48\"",
        bestPace: "11'55\"",
        bestPaceAt: 'KM ke-2',
        zone: 'Zona 2 - Lemak',
        speedTimes: [0.0, 0.2, 0.4, 0.6, 0.8, 0.95],
        speedValues: [3.7, 4.1, 4.5, 4.8, 4.6, 4.5],
        axisMinutes: 50,
        axisKm: 4,
        routeName: 'Rute Taman Kota',
      ),
    ),
  ];

  List<_Activity> get _visible {
    if (_filter == _Filter.jalan) {
      return _activities.where((a) => a.kind == _Kind.jalan).toList();
    }
    if (_filter == _Filter.lari) {
      return _activities.where((a) => a.kind == _Kind.lari).toList();
    }
    if (_filter == _Filter.sepeda) {
      return _activities.where((a) => a.kind == _Kind.sepeda).toList();
    }
    return _activities;
  }

  void _toast(String message) {
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

  @override
  Widget build(BuildContext context) {
    final items = _visible;

    return Scaffold(
      backgroundColor: FitColors.bg,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 4, 24, 120),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFilters(),
                        const SizedBox(height: 16),
                        _buildSummaryCard(),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Daftar Aktivitas',
                                  style: fitText(14, FontWeight.w700,
                                      FitColors.slate800,
                                      letterSpacing: -0.2)),
                              Text('September 2026',
                                  style: fitText(12, FontWeight.w500,
                                      FitColors.slate500)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (items.isEmpty)
                          _buildEmpty()
                        else
                          for (var i = 0; i < items.length; i++) ...[
                            _buildActivityCard(items[i]),
                            if (i != items.length - 1)
                              const SizedBox(height: 12),
                          ],
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

  // ---------------------------------------------------------------- Header

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
      child: Row(
        children: [
          SquareIconButton(
            icon: Icons.chevron_left_rounded,
            label: 'Kembali',
            onTap: () => goToTab(context, AppTab.home, from: AppTab.progres),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Riwayat Olahraga',
                  style: fitText(20, FontWeight.w700, FitColors.slate900,
                      letterSpacing: -0.3),
                ),
                Text(
                  'Rekapitulasi progres aktivitas',
                  style: fitText(12, FontWeight.w500, FitColors.slate500),
                ),
              ],
            ),
          ),
          SquareIconButton(
            icon: Icons.calendar_month_outlined,
            label: 'Filter tanggal',
            onTap: () => _toast('Filter tanggal belum tersedia'),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------- Filter

  Widget _buildFilters() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _filterChip('Semua', _Filter.semua),
          const SizedBox(width: 8),
          _filterChip('Berjalan', _Filter.jalan),
          const SizedBox(width: 8),
          _filterChip('Berlari', _Filter.lari),
          const SizedBox(width: 8),
          _filterChip('Bersepeda', _Filter.sepeda),
        ],
      ),
    );
  }

  Widget _filterChip(String label, _Filter value) {
    final active = _filter == value;
    return GestureDetector(
      onTap: () => setState(() => _filter = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: EdgeInsets.symmetric(horizontal: active ? 20 : 16, vertical: 10),
        decoration: BoxDecoration(
          gradient: active
              ? const LinearGradient(
                  colors: [FitColors.blue600, FitColors.blue500],
                )
              : null,
          color: active ? null : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: active ? null : Border.all(color: FitColors.slate200),
          boxShadow: active
              ? const [
                  BoxShadow(
                    color: Color(0x403B82F6),
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: fitText(12, FontWeight.w600,
              active ? Colors.white : FitColors.slate600),
        ),
      ),
    );
  }

  // ------------------------------------------------------------- Ringkasan

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [FitColors.blue600, FitColors.blue500, Color(0xFF4F46E5)],
        ),
        boxShadow: FitColors.cardShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              right: -30,
              top: -30,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(colors: [
                    const Color(0x26FFFFFF),
                    const Color(0x00FFFFFF),
                  ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0x33FFFFFF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text('Minggu Ini',
                                style: fitText(
                                    11, FontWeight.w600, Colors.white)),
                          ),
                          const SizedBox(width: 8),
                          Text('15 - 21 Sep 2026',
                              style: fitText(
                                  11, FontWeight.w500, FitColors.blue100)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0x1AFFFFFF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text('7 Aktivitas',
                            style: fitText(
                                12, FontWeight.w600, FitColors.blue100)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _metric('Total Jarak', '28,4', 'km')),
                        _divider(),
                        Expanded(child: _metric('Kalori', '1.850', 'kkal')),
                        _divider(),
                        Expanded(child: _metric('Durasi', '4j 12m', '')),
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

  Widget _divider() {
    return Container(
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      color: const Color(0x26FFFFFF),
    );
  }

  Widget _metric(String label, String value, String unit) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: fitText(11, FontWeight.w500, FitColors.blue100)),
        const SizedBox(height: 2),
        Text.rich(
          TextSpan(
            text: value,
            style: fitText(20, FontWeight.w700, Colors.white,
                letterSpacing: -0.3),
            children: [
              if (unit.isNotEmpty)
                TextSpan(
                  text: ' $unit',
                  style: fitText(
                      12, FontWeight.w500, const Color(0xFFBFDBFE)),
                ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------- Daftar

  Widget _buildActivityCard(_Activity a) {
    final isWalk = a.kind == _Kind.jalan;
    final isRun = a.kind == _Kind.lari;

    final IconData icon = isWalk
        ? Icons.directions_walk_rounded
        : (isRun ? Icons.directions_run_rounded : Icons.pedal_bike_rounded);
    final Color iconBg = isWalk ? FitColors.emerald50 : FitColors.blue50;
    final Color iconBorder = isWalk ? FitColors.emerald100 : FitColors.blue100;
    final Color iconColor = isWalk ? FitColors.emerald600 : FitColors.blue600;

    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => RiwayatDetailScreen(detail: a.detail),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: const Color(0xCCE2E8F0)),
          boxShadow: FitColors.cardShadow,
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: iconBorder),
              ),
              child: Icon(icon, size: 26, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(a.title,
                      overflow: TextOverflow.ellipsis,
                      style: fitText(14, FontWeight.w700, FitColors.slate900)),
                  const SizedBox(height: 2),
                  Text(a.date,
                      style: fitText(11, FontWeight.w500, FitColors.slate400)),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 10,
                    runSpacing: 2,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      _metricChip(Icons.north_east_rounded, FitColors.blue500,
                          a.distance),
                      _metricChip(Icons.local_fire_department_rounded,
                          const Color(0xFFF97316), a.calories),
                      _metricChip(Icons.timer_outlined, FitColors.slate400,
                          a.duration),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: FitColors.blue50,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.chevron_right_rounded,
                  size: 20, color: FitColors.blue600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _metricChip(IconData icon, Color color, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: color),
        const SizedBox(width: 3),
        Text(text, style: fitText(11, FontWeight.w500, FitColors.slate600)),
      ],
    );
  }

  Widget _buildEmpty() {
    final label = _filter == _Filter.sepeda
        ? 'bersepeda'
        : (_filter == _Filter.jalan ? 'berjalan' : 'berlari');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: FitColors.slate100),
      ),
      child: Column(
        children: [
          const Icon(Icons.history_rounded, size: 36, color: FitColors.slate300),
          const SizedBox(height: 10),
          Text('Belum ada aktivitas $label',
              style: fitText(14, FontWeight.w700, FitColors.slate700)),
          const SizedBox(height: 4),
          Text(
            'Riwayat akan muncul di sini setelah kamu menyelesaikan latihan.',
            textAlign: TextAlign.center,
            style: fitText(12, FontWeight.w500, FitColors.slate400),
          ),
        ],
      ),
    );
  }
}
