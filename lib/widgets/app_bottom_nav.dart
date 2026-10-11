import 'package:flutter/material.dart';
import '../screens/dashboard_screen.dart';
import '../screens/jadwal_screen.dart';
import '../screens/profile_screen.dart';
import '../screens/progres_screen.dart';
import '../screens/sesi_olahraga_screen.dart';
import '../theme/fit_colors.dart';

enum AppTab { home, jadwal, tracking, progres, profile }

/// Pindah ke halaman tab tertentu. Dipakai oleh footer dan oleh tombol lain
/// yang perlu lompat tab (misalnya "Semua" di Dashboard).
///
/// Semua tab sudah terhubung ke halamannya masing-masing.
void goToTab(BuildContext context, AppTab tab, {AppTab? from}) {
  if (tab == from) {
    // Di halaman turunan (misalnya Tugas Baru atau Detail Riwayat), menekan
    // tab yang sedang aktif membawa kembali ke halaman utama tab itu.
    final nav = Navigator.of(context);
    if (nav.canPop()) nav.popUntil((route) => route.isFirst);
    return;
  }

  Widget page = const DashboardScreen();
  switch (tab) {
    case AppTab.home:
      page = const DashboardScreen();
      break;
    case AppTab.jadwal:
      page = const JadwalScreen();
      break;
    case AppTab.progres:
      page = const ProgresScreen();
      break;
    case AppTab.profile:
      page = const ProfileScreen();
      break;
    case AppTab.tracking:
      page = const SesiOlahragaScreen();
      break;
  }

  // Ganti seluruh stack tanpa animasi supaya terasa seperti pindah tab.
  Navigator.of(context).pushAndRemoveUntil(
    PageRouteBuilder<void>(
      pageBuilder: (_, __, ___) => page,
      transitionDuration: Duration.zero,
      reverseTransitionDuration: Duration.zero,
    ),
    (route) => false,
  );
}

/// Footer melayang dengan tombol Tracking bulat di tengah.
/// Pasang di dalam Stack: Positioned(left: 16, right: 16, bottom: 16, ...).
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({super.key, required this.current});

  final AppTab current;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 70,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.94),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.7)),
                boxShadow: FitColors.navShadow,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _item(context, AppTab.home, Icons.home_outlined,
                      Icons.home_rounded, 'Home'),
                  _item(context, AppTab.jadwal, Icons.event_available_outlined,
                      Icons.event_available_rounded, 'Jadwal'),
                  const SizedBox(width: 64),
                  _item(context, AppTab.progres, Icons.bar_chart_rounded,
                      Icons.bar_chart_rounded, 'Progres'),
                  _item(context, AppTab.profile, Icons.person_outline_rounded,
                      Icons.person_rounded, 'Profile'),
                ],
              ),
            ),
          ),
          Positioned(
            top: 4,
            left: 0,
            right: 0,
            child: Center(child: _trackingButton(context)),
          ),
        ],
      ),
    );
  }

  Widget _item(
    BuildContext context,
    AppTab tab,
    IconData icon,
    IconData activeIcon,
    String label,
  ) {
    final active = current == tab;
    final color = active ? FitColors.electric : FitColors.slate400;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => goToTab(context, tab, from: current),
      child: SizedBox(
        width: 56,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: active
                    ? FitColors.blue100.withOpacity(0.7)
                    : Colors.transparent,
              ),
              child: Icon(active ? activeIcon : icon, size: 20, color: color),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: fitText(
                10,
                active ? FontWeight.w800 : FontWeight.w600,
                color,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _trackingButton(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => goToTab(context, AppTab.tracking, from: current),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [FitColors.blue600, FitColors.blue700],
              ),
              border: Border.all(color: FitColors.bg, width: 4),
              boxShadow: FitColors.glowBlue,
            ),
            child: const Icon(
              Icons.directions_run_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Tracking',
            style: fitText(10, FontWeight.w700, FitColors.slate700),
          ),
        ],
      ),
    );
  }
}
