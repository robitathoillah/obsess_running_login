import 'package:flutter/material.dart';
import '../models/sesi_olahraga.dart';
import '../theme/fit_colors.dart';
import '../theme/track_colors.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/track_circle_button.dart';
import 'mulai_olahraga_screen.dart';

/// Layar 1: pilih jenis olahraga (Berjalan / Berlari).
class SesiOlahragaScreen extends StatelessWidget {
  const SesiOlahragaScreen({super.key});

  void _mulai(BuildContext context, JenisOlahraga jenis) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => MulaiOlahragaScreen(jenis: jenis)),
    );
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
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 130),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBanner(),
                        const SizedBox(height: 20),
                        _buildSectionTitle(),
                        const SizedBox(height: 14),
                        _buildWalkingCard(context),
                        const SizedBox(height: 14),
                        _buildRunningCard(context),
                        const SizedBox(height: 20),
                        _buildHistory(),
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

  // ---------------------------------------------------------------- Top bar

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          TrackCircleButton(
            icon: Icons.arrow_back_rounded,
            size: 36,
            iconSize: 18,
            label: 'Kembali',
            onTap: () => goToTab(context, AppTab.home),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Sesi Olahraga',
              style: fitText(18, FontWeight.w700, TC.slate900,
                  letterSpacing: -0.2),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(6, 4, 10, 4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: TC.blue100),
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
                Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.bottomLeft,
                      end: Alignment.topRight,
                      colors: [TC.blue600, TC.cyan400],
                    ),
                  ),
                  child: const Icon(Icons.bolt_rounded,
                      size: 10, color: Colors.white),
                ),
                const SizedBox(width: 6),
                Text('GERAK',
                    style: fitText(11, FontWeight.w800, TC.blue600,
                        letterSpacing: 0.8)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------- Banner

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xB3DBEAFE)),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Color(0xFFF5F9FF), Colors.white],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              style: fitText(20, FontWeight.w800, TC.slate900),
              children: [
                const TextSpan(text: 'Hitung '),
                TextSpan(
                  text: 'Kalori',
                  style: fitText(20, FontWeight.w800, TC.blue600).copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: TC.blue100,
                    decorationThickness: 2,
                  ),
                ),
                const TextSpan(text: ' & '),
                TextSpan(
                  text: 'JarakMu',
                  style: fitText(20, FontWeight.w800, TC.amber500),
                ),
                const TextSpan(text: ' disini'),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Pilih target dan jenis aktivitasmu hari ini untuk mulai melangkah dengan presisi.',
            style: fitText(12, FontWeight.w400, TC.slate500),
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: TC.slate100),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                        color: TC.emerald500, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  Text('GPS Siap Terhubung',
                      style: fitText(11, FontWeight.w600, TC.slate500)),
                ],
              ),
              Row(
                children: [
                  Text('Pilihan Terbuka',
                      style: fitText(11, FontWeight.w600, TC.blue600)),
                  const Icon(Icons.chevron_right_rounded,
                      size: 14, color: TC.blue600),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle() {
    return Row(
      children: [
        Text('Pilih Olahraga',
            style: fitText(14, FontWeight.w700, TC.slate800)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          decoration: BoxDecoration(
            color: TC.blue50,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: TC.blue100),
          ),
          child: Text('2 Mode',
              style: fitText(10, FontWeight.w600, TC.blue600)),
        ),
      ],
    );
  }

  // ------------------------------------------------------------ Kartu sport

  Widget _buildWalkingCard(BuildContext context) {
    return _SportCard(
      jenis: JenisOlahraga.berjalan,
      tag: 'Kardio Ringan',
      tagColor: TC.amber600,
      tagBg: TC.amber50,
      iconColor: TC.amber500,
      iconBg: TC.amber50,
      iconBorder: TC.amber100,
      desc:
          'Olahraga ringan dengan berjalan kaki untuk menjaga kebugaran jantung dan membakar lemak stabil.',
      chips: const [
        _InfoChip(
          icon: Icons.speed_rounded,
          text: 'Pace santai 4 - 5 km/jam',
          fg: TC.sky700,
          bg: TC.sky50,
          border: TC.sky100,
          iconColor: TC.sky700,
        ),
        _InfoChip(
          icon: Icons.favorite_rounded,
          text: 'Zona 3-4 Denyut',
          fg: TC.rose700,
          bg: TC.rose50,
          border: TC.rose100,
          iconColor: TC.rose500,
        ),
      ],
      highlight: false,
      onMulai: () => _mulai(context, JenisOlahraga.berjalan),
    );
  }

  Widget _buildRunningCard(BuildContext context) {
    return _SportCard(
      jenis: JenisOlahraga.berlari,
      tag: 'Intensitas Tinggi',
      tagColor: TC.blue600,
      tagBg: TC.blue50,
      iconColor: TC.blue600,
      iconBg: TC.blue50,
      iconBorder: TC.blue100,
      desc:
          'Olahraga lari sesuai kemampuan dan target pembakaran kalori optimal untuk memperkuat stamina tubuh.',
      chips: const [
        _InfoChip(
          icon: Icons.bolt_rounded,
          text: 'Fokus Kekuatan & Daya tahan',
          fg: TC.emerald700,
          bg: TC.emerald50,
          border: TC.emerald100,
          iconColor: TC.emerald500,
        ),
        _InfoChip(
          icon: Icons.favorite_rounded,
          text: 'Zona 3-4 Denyut',
          fg: TC.rose700,
          bg: TC.rose50,
          border: TC.rose100,
          iconColor: TC.rose500,
        ),
      ],
      highlight: true,
      onMulai: () => _mulai(context, JenisOlahraga.berlari),
    );
  }

  // ---------------------------------------------------------------- Riwayat

  Widget _buildHistory() {
    // TODO: ganti data dummy ini dengan riwayat sesi sungguhan.
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Riwayat Sesi',
                style: fitText(14, FontWeight.w700, TC.slate900)),
            Row(
              children: [
                Text('Lihat Semua',
                    style: fitText(12, FontWeight.w600, TC.blue600)),
                const Icon(Icons.chevron_right_rounded,
                    size: 15, color: TC.blue600),
              ],
            ),
          ],
        ),
        const SizedBox(height: 10),
        const _HistoryTile(
          icon: Icons.directions_walk_rounded,
          iconColor: TC.amber500,
          bg: TC.amber50,
          border: TC.amber100,
          title: 'Berjalan - 20 menit',
          subtitle: 'Hari ini 1,8 km • 2.430 langkah',
        ),
        const SizedBox(height: 10),
        const _HistoryTile(
          icon: Icons.directions_run_rounded,
          iconColor: TC.blue600,
          bg: TC.blue50,
          border: TC.blue100,
          title: 'Berlari - 30 menit',
          subtitle: 'Hari ini 3,2 km • 3.910 langkah',
        ),
      ],
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({
    required this.icon,
    required this.text,
    required this.fg,
    required this.bg,
    required this.border,
    required this.iconColor,
  });

  final IconData icon;
  final String text;
  final Color fg;
  final Color bg;
  final Color border;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: iconColor),
          const SizedBox(width: 4),
          Text(text, style: fitText(10, FontWeight.w600, fg)),
        ],
      ),
    );
  }
}

class _SportCard extends StatelessWidget {
  const _SportCard({
    required this.jenis,
    required this.tag,
    required this.tagColor,
    required this.tagBg,
    required this.iconColor,
    required this.iconBg,
    required this.iconBorder,
    required this.desc,
    required this.chips,
    required this.highlight,
    required this.onMulai,
  });

  final JenisOlahraga jenis;
  final String tag;
  final Color tagColor;
  final Color tagBg;
  final Color iconColor;
  final Color iconBg;
  final Color iconBorder;
  final String desc;
  final List<Widget> chips;
  final bool highlight;
  final VoidCallback onMulai;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlight ? const Color(0xCCBFDBFE) : const Color(0xB3E2E8F0),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x141D72FE),
            blurRadius: 24,
            spreadRadius: -4,
            offset: Offset(0, 8),
          ),
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 6,
            spreadRadius: -1,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: iconBorder),
                ),
                child: Icon(jenis.icon, size: 28, color: iconColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(jenis.label,
                            style:
                                fitText(16, FontWeight.w700, TC.slate900)),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: tagBg,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(tag,
                              style: fitText(10, FontWeight.w700, tagColor)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(desc,
                        style: fitText(12, FontWeight.w400, TC.slate500)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 12),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: TC.slate100)),
            ),
            child: Wrap(spacing: 6, runSpacing: 6, children: chips),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('PERKIRAAN KALORI',
                      style: fitText(10, FontWeight.w500, TC.slate400,
                          letterSpacing: 0.8)),
                  const SizedBox(height: 2),
                  Text('Est. ${jenis.estKkal30} Kkal / 30m',
                      style: fitText(12, FontWeight.w800, TC.slate700)),
                ],
              ),
              GestureDetector(
                onTap: onMulai,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                  decoration: BoxDecoration(
                    color: highlight ? null : TC.blue600,
                    gradient: highlight
                        ? const LinearGradient(
                            colors: [TC.blue600, Color(0xFF3B82F6)])
                        : null,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: highlight
                            ? const Color(0x472563EB)
                            : const Color(0x332563EB),
                        blurRadius: highlight ? 20 : 8,
                        spreadRadius: highlight ? -4 : -2,
                        offset: Offset(0, highlight ? 10 : 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Mulai',
                          style: fitText(12, FontWeight.w700, Colors.white)),
                      const SizedBox(width: 6),
                      Icon(
                        highlight
                            ? Icons.play_arrow_rounded
                            : Icons.play_circle_fill_rounded,
                        size: 15,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  const _HistoryTile({
    required this.icon,
    required this.iconColor,
    required this.bg,
    required this.border,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final Color bg;
  final Color border;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xCCE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: border),
            ),
            child: Icon(icon, size: 18, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: fitText(12, FontWeight.w700, TC.slate900)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: fitText(11, FontWeight.w500, TC.slate500)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: TC.emerald50,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text('Selesai',
                style: fitText(10, FontWeight.w700, TC.emerald600)),
          ),
        ],
      ),
    );
  }
}