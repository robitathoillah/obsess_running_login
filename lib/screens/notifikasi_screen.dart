import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/fit_colors.dart';
import '../widgets/app_bottom_nav.dart';

class _BadgeSpec {
  const _BadgeSpec(
    this.text,
    this.bg,
    this.fg, {
    this.border,
    this.pill = true,
  });

  final String text;
  final Color bg;
  final Color fg;
  final Color? border;
  final bool pill;
}

class _Notif {
  _Notif({
    required this.icon,
    required this.accent,
    required this.iconBg,
    required this.iconBorder,
    required this.title,
    required this.lineText,
    this.lineIcon,
    this.lineColor = FitColors.slate400,
    this.lineWeight = FontWeight.w500,
    this.badge,
    this.unread = false,
  });

  final IconData icon;
  final Color accent;
  final Color iconBg;
  final Color iconBorder;
  final String title;
  final String lineText;
  final IconData? lineIcon;
  final Color lineColor;
  final FontWeight lineWeight;
  final _BadgeSpec? badge;
  bool unread;
}

class NotifikasiScreen extends StatefulWidget {
  const NotifikasiScreen({super.key});

  @override
  State<NotifikasiScreen> createState() => _NotifikasiScreenState();
}

class _NotifikasiScreenState extends State<NotifikasiScreen> {
  // TODO: ganti data contoh ini dengan notifikasi asli dari backend.
  final List<_Notif> _today = [
    _Notif(
      icon: Icons.directions_walk_rounded,
      accent: FitColors.blue600,
      iconBg: FitColors.blue50,
      iconBorder: const Color(0xFFBFDBFE),
      title: 'Jalan 20 menit',
      lineText: 'Hari ini, 07.00',
      lineIcon: Icons.access_time_rounded,
      unread: true,
    ),
    _Notif(
      icon: Icons.monitor_weight_outlined,
      accent: FitColors.amber500,
      iconBg: const Color(0xFFFFFBEB),
      iconBorder: const Color(0xFFFEF3C7),
      title: 'Catat berat badan kamu',
      lineText: 'Sudah 3 hari belum diperbaharui',
      lineIcon: Icons.error_outline_rounded,
      lineColor: FitColors.blue600,
      lineWeight: FontWeight.w600,
      unread: true,
    ),
    _Notif(
      icon: Icons.trending_down_rounded,
      accent: FitColors.emerald600,
      iconBg: FitColors.emerald50,
      iconBorder: FitColors.emerald100,
      title: 'Berat badan turun 1,5 kg',
      lineText: 'Progres minggu ini bagus, terus pertahankan',
      lineColor: FitColors.slate500,
      lineWeight: FontWeight.w400,
      badge: const _BadgeSpec(
        'Hebat!',
        FitColors.emerald100,
        FitColors.emerald700,
      ),
    ),
  ];

  final List<_Notif> _yesterday = [
    _Notif(
      icon: Icons.local_fire_department_rounded,
      accent: const Color(0xFFF97316),
      iconBg: const Color(0xFFFFF7ED),
      iconBorder: const Color(0xFFFFEDD5),
      title: 'Konsisten 5 hari',
      lineText: 'Kemarin, 19.45',
      lineIcon: Icons.access_time_rounded,
      badge: const _BadgeSpec(
        '5 Hari Streak',
        Color(0xFFFFF7ED),
        Color(0xFFEA580C),
        border: Color(0xFFFED7AA),
        pill: false,
      ),
    ),
    _Notif(
      icon: Icons.check_circle_rounded,
      accent: FitColors.blue600,
      iconBg: FitColors.blue50,
      iconBorder: const Color(0xFFBFDBFE),
      title: 'Profil berhasil disimpan',
      lineText: 'Kemarin, 09.41',
      lineIcon: Icons.access_time_rounded,
    ),
  ];

  bool get _hasUnread =>
      _today.any((n) => n.unread) || _yesterday.any((n) => n.unread);

  void _markAllRead() {
    setState(() {
      for (final n in [..._today, ..._yesterday]) {
        n.unread = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: FitColors.bg,
        body: SafeArea(
          top: false,
          child: Stack(
            children: [
              Column(
                children: [
                  _buildHeader(topInset),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 130),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildSection(
                            label: 'HARI INI',
                            labelColor: FitColors.blue600,
                            items: _today,
                            recent: true,
                          ),
                          const SizedBox(height: 24),
                          _buildSection(
                            label: 'KEMARIN',
                            labelColor: FitColors.slate400,
                            items: _yesterday,
                            recent: false,
                          ),
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
                // Notifikasi dibuka dari Home, jadi tab Home yang disorot.
                child: AppBottomNav(current: AppTab.home),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------- Header

  Widget _buildHeader(double topInset) {
    final hasUnread = _hasUnread;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, topInset + 12, 20, 20),
      decoration: const BoxDecoration(
        color: FitColors.blue600,
        boxShadow: [
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).maybePop(),
            child: const SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.arrow_back_rounded,
                  size: 22, color: Colors.white),
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              'Notifikasi',
              style: fitText(20, FontWeight.w700, Colors.white,
                  letterSpacing: -0.2),
            ),
          ),
          GestureDetector(
            onTap: hasUnread ? _markAllRead : null,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 150),
              opacity: hasUnread ? 1 : 0.5,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0x26FFFFFF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Tandai Dibaca',
                  style: fitText(12, FontWeight.w500, Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------------- Section

  Widget _buildSection({
    required String label,
    required Color labelColor,
    required List<_Notif> items,
    required bool recent,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: fitText(12, FontWeight.w700, labelColor,
                    letterSpacing: 1),
              ),
              Text(
                '${items.length} Notifikasi',
                style: fitText(11, FontWeight.w500, FitColors.slate400),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < items.length; i++) ...[
          _buildCard(items[i], recent),
          if (i != items.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildBadge(_BadgeSpec b) {
    return Container(
      margin: const EdgeInsets.only(left: 8),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: b.bg,
        borderRadius: BorderRadius.circular(b.pill ? 20 : 4),
        border: b.border == null ? null : Border.all(color: b.border!),
      ),
      child: Text(
        b.text,
        style: fitText(10, b.pill ? FontWeight.w600 : FontWeight.w500, b.fg),
      ),
    );
  }

  Widget _buildCard(_Notif n, bool recent) {
    Widget trailing = const SizedBox.shrink();
    if (n.unread) {
      trailing = Container(
        width: 8,
        height: 8,
        margin: const EdgeInsets.only(left: 8),
        decoration: const BoxDecoration(
          color: FitColors.blue600,
          shape: BoxShape.circle,
        ),
      );
    } else if (n.badge != null) {
      trailing = _buildBadge(n.badge!);
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      // Mengetuk notifikasi menandainya sudah dibaca.
      onTap: n.unread ? () => setState(() => n.unread = false) : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: recent ? Colors.white : Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: recent ? const Color(0xFFE0EFFF) : const Color(0xCCE2E8F0),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x140369A1),
              blurRadius: 14,
              spreadRadius: -2,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: n.iconBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: n.iconBorder),
              ),
              child: Icon(n.icon, size: 20, color: n.accent),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          n.title,
                          style: fitText(
                            14,
                            FontWeight.w600,
                            recent ? FitColors.slate800 : FitColors.slate700,
                            height: 1.2,
                          ),
                        ),
                      ),
                      trailing,
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (n.lineIcon != null) ...[
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child:
                              Icon(n.lineIcon, size: 12, color: n.lineColor),
                        ),
                        const SizedBox(width: 4),
                      ],
                      Expanded(
                        child: Text(
                          n.lineText,
                          style: fitText(12, n.lineWeight, n.lineColor,
                              height: 1.4),
                        ),
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
}
