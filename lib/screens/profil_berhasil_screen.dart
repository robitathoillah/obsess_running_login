import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'login_screen.dart';

class ProfilBerhasilScreen extends StatelessWidget {
  const ProfilBerhasilScreen({
    super.key,
    required this.targetBeratKg,
    required this.selisihBeratKg,
  });

  /// Target berat badan yang diisi user di halaman sebelumnya.
  final double targetBeratKg;

  /// Selisih berat badan saat ini dikurangi target (dipakai untuk
  /// menentukan level aktivitas & program rekomendasi secara sederhana).
  final double selisihBeratKg;

  /// Logic kecil buat nentuin "Level Aktivitas" berdasarkan seberapa besar
  /// selisih target beratnya -- bukan medis, cuma biar UI-nya terasa hidup
  /// (bukan hardcode teks statis terus).
  String get _levelAktivitas {
    final selisih = selisihBeratKg.abs();
    if (selisih <= 3) return 'Pelari Rekreasi';
    if (selisih <= 10) return 'Pelari Aktif';
    return 'Pelari Intensif';
  }

  String get _programRekomendasi {
    final selisih = selisihBeratKg.abs();
    if (selisih <= 3) return '5K Perdana: Fondasi Kecepatan';
    if (selisih <= 10) return '10K Bertahap: Bangun Stamina';
    return 'Program Transformasi: 12 Minggu';
  }

 void _handleLanjutKeLogin(BuildContext context) {
  print('TOMBOL LOGIN DIKLIK');

  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => const LoginScreen(),
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            children: [
              _buildTopBar(),
              const Spacer(),
              _buildSuccessIcon(),
              const SizedBox(height: 20),
              const Text(
                'Profil berhasil disimpan',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Rencana latihan lari dan target kebugaran personalmu siap dimulai!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  height: 1.4,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              _buildSummaryCard(),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () => _handleLanjutKeLogin(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Lanjut ke Login',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w700),
                      ),
                      SizedBox(width: 6),
                      Icon(Icons.arrow_forward_rounded, size: 18),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.directions_run_rounded,
                  size: 16, color: Colors.white),
            ),
            const SizedBox(width: 8),
            const Text(
              'OBSESS',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.badgeBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Langkah 2/2',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessIcon() {
    return SizedBox(
      width: 150,
      height: 150,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF2E9E5B).withOpacity(0.12),
            ),
          ),
          Positioned(
            top: 10,
            left: 18,
            child: _dot(const Color(0xFFE0A32E)),
          ),
          Positioned(
            top: 20,
            right: 10,
            child: _dot(const Color(0xFF5B8DEF)),
          ),
          Positioned(
            bottom: 15,
            left: 25,
            child: _dot(const Color(0xFF5B8DEF)),
          ),
          Positioned(
            bottom: 5,
            right: 20,
            child: _dot(const Color(0xFFE0A32E)),
          ),
          Container(
            width: 96,
            height: 96,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF2E9E5B),
            ),
            child: const Icon(Icons.check_rounded,
                color: Colors.white, size: 46),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.circle, size: 8, color: Color(0xFF2E9E5B)),
                  SizedBox(width: 6),
                  Text(
                    'RINGKASAN PERSONAL',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCEFDB),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  'Siap Lari',
                  style: TextStyle(
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
            children: [
              Expanded(
                child: _summaryTile(
                  label: 'Target Berat',
                  value: '${targetBeratKg.toStringAsFixed(0)} kg',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _summaryTile(
                  label: 'Level Aktivitas',
                  value: _levelAktivitas,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.fieldFill,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Program Rekomendasi',
                        style: TextStyle(
                            fontSize: 10.5, color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        _programRekomendasi,
                        style: const TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.link,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    color: AppColors.primary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryTile({required String label, required String value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 10.5, color: AppColors.textSecondary),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
