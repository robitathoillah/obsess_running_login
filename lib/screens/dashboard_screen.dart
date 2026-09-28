import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Placeholder Dashboard. Belum ada desain Figma-nya, jadi ini cuma
/// halaman sementara supaya alur Login -> Splash -> Dashboard bisa
/// dites end-to-end. Ganti isi build() ini kalau desain Dashboard
/// sudah ada.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 72,
                  height: 72,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.dashboard_rounded,
                      color: Colors.white, size: 32),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Dashboard',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Halaman ini belum didesain di Figma.\nGanti isi DashboardScreen kalau desainnya sudah ada.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
                ),
                const SizedBox(height: 24),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil('/login', (route) => false);
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                  ),
                  child: const Text('Logout (kembali ke Login)'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
