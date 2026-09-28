import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/weight_sparkline.dart';

enum _WorkoutStatus { done, next, later }

class _WorkoutItem {
  const _WorkoutItem({
    required this.title,
    required this.time,
    required this.status,
  });

  final String title;
  final String time;
  final _WorkoutStatus status;
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  // TODO: ganti semua data statis di bawah ini dengan data asli dari
  // backend/local storage (nama user, progress latihan, berat badan, dll).
  static const _userName = 'Robit';
  static const _streakDays = 5;
  static const _stepsNow = 1000;
  static const _stepsTarget = 10000;
  static const _caloriesNow = 1000;
  static const _caloriesTarget = 10000;
  static const _weightNow = 90.5;
  static const _weightTarget = 75.0;
  static const _weightHistory = [92.0, 91.2, 90.5];

  static const _workouts = [
    _WorkoutItem(
      title: 'Jalan 20 menit',
      time: 'Hari ini, 07.00',
      status: _WorkoutStatus.done,
    ),
    _WorkoutItem(
      title: 'Berlari 30 menit',
      time: 'Hari ini, 09.00',
      status: _WorkoutStatus.next,
    ),
    _WorkoutItem(
      title: 'Pull Up 15 repetisi',
      time: 'Hari ini, 15.00',
      status: _WorkoutStatus.later,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final selesai =
        _workouts.where((w) => w.status == _WorkoutStatus.done).length;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildFocusCard(),
                  const SizedBox(height: 16),
                  _buildWorkoutCard(selesai),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatCard(
                          label: 'Langkah',
                          icon: Icons.directions_walk_rounded,
                          iconColor: AppColors.primary,
                          iconBg: AppColors.badgeBg,
                          value: _stepsNow.toString(),
                          target: 'Target ${_formatNumber(_stepsTarget)}',
                          progress: _stepsNow / _stepsTarget,
                          progressColor: AppColors.primary,
                          footerText:
                              '${((_stepsNow / _stepsTarget) * 100).round()}% tercapai',
                          footerIcon: Icons.trending_up_rounded,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildStatCard(
                          label: 'Kalori',
                          icon: Icons.local_fire_department_rounded,
                          iconColor: const Color(0xFFE0A32E),
                          iconBg: const Color(0xFFFCEFDB),
                          value: _caloriesNow.toString(),
                          target:
                              'Target ${_formatNumber(_caloriesTarget)} kkal',
                          progress: _caloriesNow / _caloriesTarget,
                          progressColor: const Color(0xFFE0A32E),
                          footerText:
                              '${((_caloriesNow / _caloriesTarget) * 100).round()}% terbakar',
                          footerIcon: Icons.bolt_rounded,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildWeightCard(),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildBottomNav(),
            ),
          ],
        ),
      ),
    );
  }

  static String _formatNumber(int value) {
    final s = value.toString();
    final buffer = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      final posFromEnd = s.length - i;
      buffer.write(s[i]);
      if (posFromEnd > 1 && posFromEnd % 3 == 1) buffer.write('.');
    }
    return buffer.toString();
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Hai, $_userName',
                    style: const TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Text('👋', style: TextStyle(fontSize: 16)),
                ],
              ),
              const SizedBox(height: 2),
              const Text(
                'Semangat jaga kesehatan hari ini!',
                style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: const Color(0xFFFCEFDB),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.local_fire_department_rounded,
                  size: 14, color: Color(0xFFE0A32E)),
              const SizedBox(width: 3),
              Text(
                '$_streakDays Hari',
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFB9791C),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFocusCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF0B5A9E), Color(0xFF1E7FCC)],
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.25),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 5,
                height: 5,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'FOKUS PAGI',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.6,
                  color: Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Siap capai 5 km pertamamu?',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorkoutCard(int selesai) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
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
                    decoration: const BoxDecoration(
                      color: AppColors.badgeBg,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.insights_rounded,
                        size: 15, color: AppColors.primary),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Latihan Hari Ini',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.badgeBg,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Text(
                  '$selesai/${_workouts.length} Selesai',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          for (var i = 0; i < _workouts.length; i++) ...[
            _buildWorkoutTile(_workouts[i]),
            if (i != _workouts.length - 1) const SizedBox(height: 10),
          ],
        ],
      ),
    );
  }

  Widget _buildWorkoutTile(_WorkoutItem item) {
    final isDone = item.status == _WorkoutStatus.done;
    final isNext = item.status == _WorkoutStatus.next;

    String badgeText;
    Color badgeBg;
    Color badgeColor;
    switch (item.status) {
      case _WorkoutStatus.done:
        badgeText = 'Tuntas';
        badgeBg = AppColors.badgeBg;
        badgeColor = AppColors.primary;
        break;
      case _WorkoutStatus.next:
        badgeText = 'Berikutnya';
        badgeBg = AppColors.badgeBg;
        badgeColor = AppColors.primary;
        break;
      case _WorkoutStatus.later:
        badgeText = 'Nanti';
        badgeBg = const Color(0xFFF1F2F6);
        badgeColor = AppColors.textSecondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.fieldFill.withOpacity(0.6),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 26,
            height: 26,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isDone ? AppColors.primary : Colors.white,
              border: Border.all(
                color: isDone ? AppColors.primary : AppColors.divider,
                width: 1.4,
              ),
            ),
            child: isDone
                ? const Icon(Icons.check_rounded, size: 15, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isNext || isDone
                        ? AppColors.textPrimary
                        : AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.time,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: badgeBg,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              badgeText,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: badgeColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String label,
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String value,
    required String target,
    required double progress,
    required Color progressColor,
    required String footerText,
    required IconData footerIcon,
  }) {
    final clampedProgress = progress.clamp(0.0, 1.0);
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                    fontSize: 12.5, color: AppColors.textSecondary),
              ),
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, size: 14, color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            target,
            style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: clampedProgress,
              minHeight: 6,
              backgroundColor: AppColors.divider,
              color: progressColor,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                footerText,
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                  color: progressColor,
                ),
              ),
              const SizedBox(width: 3),
              Icon(footerIcon, size: 11, color: progressColor),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeightCard() {
    final selisih = _weightHistory.length >= 2
        ? _weightHistory.last - _weightHistory[_weightHistory.length - 2]
        : 0.0;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: AppColors.badgeBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.monitor_weight_outlined,
                    size: 16, color: AppColors.primary),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Berat Badan',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Pantauan mingguan',
                      style: TextStyle(
                          fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCEFDB),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Target ${_weightTarget.toStringAsFixed(0)} kg',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFB9791C),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _weightNow.toStringAsFixed(1).replaceAll('.', ','),
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(bottom: 4, left: 3),
                child: Text('kg',
                    style: TextStyle(
                        fontSize: 13, color: AppColors.textSecondary)),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.badgeBg,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${selisih <= 0 ? '↘' : '↗'} ${selisih.abs().toStringAsFixed(1).replaceAll('.', ',')} kg minggu ini',
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          WeightSparkline(values: _weightHistory),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '1 minggu lalu (${_weightHistory.first.toStringAsFixed(1).replaceAll('.', ',')} kg)',
                style: const TextStyle(
                    fontSize: 9.5, color: AppColors.textSecondary),
              ),
              const Text(
                '3 hari lalu',
                style: TextStyle(fontSize: 9.5, color: AppColors.textSecondary),
              ),
              Text(
                'Sekarang (${_weightHistory.last.toStringAsFixed(1).replaceAll('.', ',')} kg)',
                style: const TextStyle(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: SizedBox(
        height: 66,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _navIcon(Icons.calendar_today_outlined),
                    _navIcon(Icons.bar_chart_rounded),
                    const SizedBox(width: 46),
                    _navIcon(Icons.notifications_none_rounded),
                    _navIcon(Icons.person_outline_rounded),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -6,
              child: Container(
                width: 52,
                height: 52,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.background, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(Icons.directions_run_rounded,
                    color: Colors.white, size: 24),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navIcon(IconData icon) {
    // TODO: sambungkan tiap icon ini ke halaman/tab masing-masing
    // (Jadwal, Statistik, Notifikasi, Profil) begitu halamannya ada.
    return Icon(icon, size: 22, color: AppColors.textSecondary);
  }
}
