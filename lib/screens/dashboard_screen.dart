import 'package:flutter/material.dart';
import '../theme/fit_colors.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/weight_trend_chart.dart';
import 'notifikasi_screen.dart';

enum _TaskState { done, upcoming, later }

class _Task {
  const _Task(this.title, this.time, this.state);

  final String title;
  final String time;
  final _TaskState state;
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // TODO: ganti semua data statis di bawah dengan data dari backend.
  static const String _userName = 'Robit';
  static const int _streakDays = 10;
  static const int _steps = 1000;
  static const int _stepsTarget = 10000;
  static const int _calories = 1000;
  static const int _caloriesTarget = 10000;
  static const double _weightNow = 90.5;
  static const double _weightLastWeek = 92.0;
  static const double _weightTarget = 75;

  static const List<_Task> _tasks = [
    _Task('Jalan 30 menit', 'Hari ini, 07.00', _TaskState.done),
    _Task('Berlari 30 menit', 'Hari ini, 10.00', _TaskState.upcoming),
    _Task('Push up 50 reps', 'Hari ini, 15.00', _TaskState.later),
  ];

  static String _kg(double v) => v.toStringAsFixed(1).replaceAll('.', ',');

  static String _thousands(int value) {
    final s = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final fromEnd = s.length - i;
      buffer.write(s[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buffer.write('.');
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FitColors.bg,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 24),
                  _buildHeroCard(context),
                  const SizedBox(height: 24),
                  _buildWorkoutSection(context),
                  const SizedBox(height: 24),
                  _buildStatsGrid(),
                  const SizedBox(height: 24),
                  _buildWeightCard(),
                ],
              ),
            ),
            const Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: AppBottomNav(current: AppTab.home),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------- Header

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Hai, $_userName',
                    style: fitText(24, FontWeight.w800, FitColors.slate900,
                        letterSpacing: -0.4),
                  ),
                  const SizedBox(width: 6),
                  const Text('👋', style: TextStyle(fontSize: 22)),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                'Semangat jaga kesehatan!',
                style: fitText(12, FontWeight.w500, FitColors.slate500),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(6, 6, 12, 6),
          decoration: BoxDecoration(
            color: const Color(0x1AF59E0B),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: const Color(0x40F59E0B)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.bottomLeft,
                    end: Alignment.topRight,
                    colors: [Color(0xFFF97316), FitColors.amber300],
                  ),
                ),
                child: const Icon(Icons.local_fire_department_rounded,
                    size: 14, color: Colors.white),
              ),
              const SizedBox(width: 6),
              Text(
                '$_streakDays Hari',
                style: fitText(12, FontWeight.w700, FitColors.amber700),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ------------------------------------------------------------- Hero card

  Widget _glow(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(colors: [color, color.withOpacity(0)]),
      ),
    );
  }

  Widget _buildHeroCard(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [FitColors.blue600, FitColors.blue700],
        ),
        boxShadow: FitColors.glowBlue,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Positioned(
              right: -24,
              bottom: -32,
              child: _glow(150, const Color(0x4022D3EE)),
            ),
            Positioned(
              right: 48,
              top: 4,
              child: _glow(84, const Color(0x26FFFFFF)),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(right: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0x33FFFFFF),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: const Color(0x33FFFFFF)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: const BoxDecoration(
                                        color: FitColors.cyan300,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      'FOKUS PAGI',
                                      style: fitText(
                                          10, FontWeight.w700, FitColors.blue100,
                                          letterSpacing: 0.8),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Bersiap capai 5KM Pertamamu!',
                                style: fitText(
                                    18, FontWeight.w800, Colors.white,
                                    height: 1.3, letterSpacing: -0.2),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Lakukan pemanasan 5 menit sebelum start.',
                                style: fitText(
                                    12, FontWeight.w500, const Color(0xE6DBEAFE)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const NotifikasiScreen(),
                            ),
                          );
                        },
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: const Color(0x26FFFFFF),
                                borderRadius: BorderRadius.circular(16),
                                border:
                                    Border.all(color: const Color(0x33FFFFFF)),
                              ),
                              child: const Icon(
                                Icons.notifications_active_rounded,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                            Positioned(
                              top: -4,
                              right: -4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: FitColors.coral,
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: FitColors.blue700, width: 2),
                                ),
                                child: Text(
                                  '+89',
                                  style: fitText(
                                      9, FontWeight.w800, Colors.white),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Container(height: 1, color: const Color(0x26FFFFFF)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.bolt_rounded,
                                size: 16, color: FitColors.amber300),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Ritme Optimal: 6\'20" /km',
                                overflow: TextOverflow.ellipsis,
                                style: fitText(12, FontWeight.w600,
                                    const Color(0xE6FFFFFF)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // TODO: sambungkan "Mulai" ke halaman Tracking.
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Mulai',
                            style: fitText(
                                11, FontWeight.w700, FitColors.cyan200),
                          ),
                          const SizedBox(width: 4),
                          const Icon(Icons.arrow_forward_rounded,
                              size: 13, color: FitColors.cyan200),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------- Latihan hari ini

  Widget _buildWorkoutSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: FitColors.blue100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.fitness_center_rounded,
                      size: 16, color: FitColors.electric),
                ),
                const SizedBox(width: 8),
                Text(
                  'Latihan Hari ini',
                  style: fitText(16, FontWeight.w700, FitColors.slate800,
                      letterSpacing: -0.2),
                ),
              ],
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => goToTab(context, AppTab.jadwal, from: AppTab.home),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  'Semua',
                  style: fitText(12, FontWeight.w600, FitColors.electric),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < _tasks.length; i++) ...[
          _buildTaskCard(_tasks[i]),
          if (i != _tasks.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildTaskCard(_Task t) {
    final isDone = t.state == _TaskState.done;
    final isUpcoming = t.state == _TaskState.upcoming;

    final Color border = isDone ? FitColors.emerald100 : FitColors.slate100;
    final Color iconBg = isDone
        ? const Color(0x1A10B981)
        : (isUpcoming ? FitColors.blue50 : FitColors.slate100);
    final Color iconColor = isDone
        ? FitColors.emerald600
        : (isUpcoming ? FitColors.electric : FitColors.slate500);
    final IconData icon = isDone
        ? Icons.check_circle_rounded
        : (isUpcoming ? Icons.directions_run_rounded : Icons.timer_outlined);
    final Color titleColor = isDone || isUpcoming
        ? FitColors.slate800
        : FitColors.slate700;

    final String pill =
        isDone ? 'Tuntas' : (isUpcoming ? 'Nanti' : 'Besok');
    final Color pillBg = isDone
        ? FitColors.emerald100
        : (isUpcoming ? FitColors.blue50 : FitColors.slate100);
    final Color pillText = isDone
        ? FitColors.emerald700
        : (isUpcoming ? FitColors.electric : FitColors.slate500);
    final Color pillBorder = isDone
        ? FitColors.emerald200
        : (isUpcoming ? FitColors.blue100 : FitColors.slate200);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: t.state == _TaskState.later
            ? Colors.white.withOpacity(0.7)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: border),
        boxShadow: FitColors.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 22, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.title,
                    style: fitText(14, FontWeight.w700, titleColor)),
                const SizedBox(height: 2),
                Text(t.time,
                    style: fitText(12, FontWeight.w500, FitColors.slate400)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: pillBg,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: pillBorder),
            ),
            child: Text(pill, style: fitText(12, FontWeight.w700, pillText)),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------ Langkah/Kalori

  Widget _buildStatsGrid() {
    final stepsPct = (_steps * 100 / _stepsTarget).round();
    final calPct = (_calories * 100 / _caloriesTarget).round();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: _buildStatCard(
            label: 'Langkah',
            icon: Icons.directions_walk_rounded,
            iconColor: FitColors.emerald600,
            iconBg: const Color(0x1A10B981),
            chipText: '$stepsPct%',
            chipColor: FitColors.emerald600,
            chipBg: FitColors.emerald100,
            value: _thousands(_steps),
            target: 'Target ${_thousands(_stepsTarget)}',
            progress: _steps / _stepsTarget,
            track: const Color(0xCCD1FAE5),
            fill: const [FitColors.emerald500, FitColors.emerald500],
            tint: const Color(0xFFF7FEFB),
            border: const Color(0xCCD1FAE5),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildStatCard(
            label: 'Kalori',
            icon: Icons.local_fire_department_rounded,
            iconColor: FitColors.coral,
            iconBg: const Color(0x1AFF5733),
            chipText: '$calPct%',
            chipColor: FitColors.coral,
            chipBg: FitColors.orange100,
            value: _thousands(_calories),
            target: 'Target ${_thousands(_caloriesTarget)} kkal',
            progress: _calories / _caloriesTarget,
            track: const Color(0xCCFFEDD5),
            fill: const [FitColors.coral, FitColors.amber500],
            tint: const Color(0xFFFFFCF8),
            border: const Color(0xCCFFEDD5),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required String label,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String chipText,
    required Color chipColor,
    required Color chipBg,
    required String value,
    required String target,
    required double progress,
    required Color track,
    required List<Color> fill,
    required Color tint,
    required Color border,
  }) {
    final factor = progress.clamp(0.0, 1.0).toDouble();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, tint],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
        boxShadow: FitColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: iconBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, size: 18, color: iconColor),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        label,
                        overflow: TextOverflow.ellipsis,
                        style:
                            fitText(12, FontWeight.w700, FitColors.slate600),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: chipBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(chipText,
                    style: fitText(10, FontWeight.w700, chipColor)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: fitText(24, FontWeight.w900, FitColors.slate900,
                letterSpacing: -0.4),
          ),
          Text(target,
              style: fitText(11, FontWeight.w500, FitColors.slate400)),
          const SizedBox(height: 10),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: track,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: factor,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: fill),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------ Berat badan

  Widget _buildWeightCard() {
    final delta = _weightNow - _weightLastWeek;
    final sign = delta < 0 ? '-' : '+';
    final deltaText = '$sign${_kg(delta.abs())} kg minggu ini';
    final trendIcon =
        delta <= 0 ? Icons.trending_down_rounded : Icons.trending_up_rounded;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: FitColors.slate100),
        boxShadow: FitColors.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                      const SizedBox(width: 6),
                      Text(
                        'BERAT BADAN',
                        style: fitText(12, FontWeight.w700, FitColors.slate500,
                            letterSpacing: 0.8),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        _kg(_weightNow),
                        style: fitText(24, FontWeight.w900, FitColors.slate900,
                            letterSpacing: -0.4),
                      ),
                      const SizedBox(width: 6),
                      Text('kg',
                          style: fitText(
                              12, FontWeight.w700, FitColors.slate400)),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: FitColors.emerald50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0x99A7F3D0)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(trendIcon, size: 13, color: FitColors.emerald600),
                        const SizedBox(width: 4),
                        Text(
                          deltaText,
                          style: fitText(
                              12, FontWeight.w700, FitColors.emerald600),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Target ${_weightTarget.toStringAsFixed(0)} kg',
                    style: fitText(11, FontWeight.w500, FitColors.slate400),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: FitColors.slate50),
          const SizedBox(height: 10),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6),
            child: WeightTrendChart(),
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '1 minggu lalu (${_kg(_weightLastWeek)} kg)',
                  style: fitText(11, FontWeight.w500, FitColors.slate400),
                ),
                Text(
                  'Sekarang',
                  style: fitText(11, FontWeight.w700, FitColors.slate800),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
