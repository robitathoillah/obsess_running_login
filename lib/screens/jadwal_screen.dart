import 'package:flutter/material.dart';
import '../theme/fit_colors.dart';
import '../utils/id_date.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/square_icon_button.dart';
import 'tugas_baru_screen.dart';

enum _Section { terlambat, hariIni, besok, mingguDepan }

class _Item {
  _Item({
    required this.title,
    required this.when,
    required this.tag,
    required this.icon,
  });

  final String title;
  String when;
  final String tag;
  final IconData icon;
  bool done = false;
}

class JadwalScreen extends StatefulWidget {
  const JadwalScreen({super.key});

  @override
  State<JadwalScreen> createState() => _JadwalScreenState();
}

class _JadwalScreenState extends State<JadwalScreen> {
  // TODO: ganti data contoh ini dengan data dari backend / penyimpanan lokal.
  final List<_Item> _terlambat = [
    _Item(
      title: 'Jalan 20 menit',
      when: 'Hari ini, 07.00',
      tag: 'Pagi',
      icon: Icons.directions_walk_rounded,
    ),
    _Item(
      title: 'Latihan Peregangan',
      when: 'Hari ini, 07.30',
      tag: '10 Menit',
      icon: Icons.self_improvement_rounded,
    ),
  ];
  final List<_Item> _hariIni = [];
  final List<_Item> _besok = [
    _Item(
      title: 'Berlari 30 menit',
      when: 'Besok, 08.00',
      tag: 'Target 4.5 km',
      icon: Icons.directions_run_rounded,
    ),
    _Item(
      title: 'Bersepeda Sore',
      when: 'Besok, 16.30',
      tag: 'Kardio',
      icon: Icons.pedal_bike_rounded,
    ),
  ];
  final List<_Item> _mingguDepan = [
    _Item(
      title: 'Push Up 25 repetisi',
      when: 'Rabu, 08.00',
      tag: 'Upper Body',
      icon: Icons.fitness_center_rounded,
    ),
    _Item(
      title: 'Pull Up 30 Repetisi',
      when: 'Kamis, 08.00',
      tag: 'Kekuatan',
      icon: Icons.fitness_center_rounded,
    ),
  ];

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

  /// "Jadwal Ulang": pindahkan latihan yang terlewat ke besok, jam tetap.
  void _reschedule(_Item item) {
    setState(() {
      _terlambat.remove(item);
      final time =
          item.when.contains(', ') ? item.when.split(', ').last : item.when;
      item.when = 'Besok, $time';
      item.done = false;
      _besok.add(item);
    });
    _toast('"${item.title}" dijadwalkan ulang ke besok');
  }

  Future<void> _openTugasBaru() async {
    final result = await Navigator.of(context).push<List<NewWorkout>>(
      MaterialPageRoute(builder: (_) => const TugasBaruScreen()),
    );
    if (!mounted || result == null || result.isEmpty) return;

    setState(() {
      for (final w in result) {
        _addWorkout(w);
      }
    });
    _toast(result.length == 1
        ? 'Latihan ditambahkan ke jadwal'
        : '${result.length} latihan ditambahkan ke jadwal');
  }

  /// Taruh latihan baru ke bagian yang sesuai berdasarkan tanggalnya.
  void _addWorkout(NewWorkout w) {
    final now = DateTime.now();
    final today = DateTime.utc(now.year, now.month, now.day);
    final target = DateTime.utc(w.date.year, w.date.month, w.date.day);
    final diff = target.difference(today).inDays;
    final time = IdDate.time24(w.hour24, w.minute);

    final lower = w.title.toLowerCase();
    IconData icon = Icons.fitness_center_rounded;
    if (lower.contains('lari')) {
      icon = Icons.directions_run_rounded;
    } else if (lower.contains('jalan')) {
      icon = Icons.directions_walk_rounded;
    } else if (lower.contains('sepeda')) {
      icon = Icons.pedal_bike_rounded;
    }

    String when;
    List<_Item> list;
    if (diff < 0) {
      when = '${target.day} ${IdDate.bulanSingkat[target.month - 1]}, $time';
      list = _terlambat;
    } else if (diff == 0) {
      when = 'Hari ini, $time';
      list = _hariIni;
    } else if (diff == 1) {
      when = 'Besok, $time';
      list = _besok;
    } else {
      when = '${IdDate.hari[target.weekday - 1]}, $time';
      list = _mingguDepan;
    }

    list.add(_Item(
      title: w.title,
      when: when,
      tag: w.repeatLabel ?? 'Latihan',
      icon: icon,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final terlewat = _terlambat.where((e) => !e.done).length;
    final tersisa = [..._hariIni, ..._besok, ..._mingguDepan]
        .where((e) => !e.done)
        .length;
    final kosong = _terlambat.isEmpty &&
        _hariIni.isEmpty &&
        _besok.isEmpty &&
        _mingguDepan.isEmpty;

    return Scaffold(
      backgroundColor: FitColors.bg,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                _buildHeader(now),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 12, 24, 170),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildOverview(terlewat, tersisa),
                        if (kosong) _buildEmpty(),
                        if (_terlambat.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          _buildSection(_Section.terlambat, _terlambat),
                        ],
                        if (_hariIni.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          _buildSection(_Section.hariIni, _hariIni),
                        ],
                        if (_besok.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          _buildSection(_Section.besok, _besok),
                        ],
                        if (_mingguDepan.isNotEmpty) ...[
                          const SizedBox(height: 24),
                          _buildSection(_Section.mingguDepan, _mingguDepan),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              right: 24,
              bottom: 112,
              child: _buildAddButton(),
            ),
            const Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: AppBottomNav(current: AppTab.jadwal),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------- Header

  Widget _buildHeader(DateTime now) {
    final bulan = IdDate.bulanSingkat[now.month - 1].toUpperCase();
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 10, 24, 0),
      child: Row(
        children: [
          SquareIconButton(
            icon: Icons.chevron_left_rounded,
            label: 'Kembali ke Dashboard',
            onTap: () => goToTab(context, AppTab.home, from: AppTab.jadwal),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Buat Jadwalmu',
                  style: fitText(20, FontWeight.w700, FitColors.slate900,
                      letterSpacing: -0.3),
                ),
                Text(
                  'MINGGU INI • $bulan ${now.year}',
                  style: fitText(11, FontWeight.w600, FitColors.slate400,
                      letterSpacing: 0.8),
                ),
              ],
            ),
          ),
          SquareIconButton(
            icon: Icons.calendar_month_outlined,
            iconColor: FitColors.blue600,
            label: 'Kalender',
            onTap: () => _toast('Tampilan kalender belum tersedia'),
          ),
        ],
      ),
    );
  }

  // --------------------------------------------------------- Kartu ringkasan

  Widget _buildOverview(int terlewat, int tersisa) {
    return Row(
      children: [
        Expanded(
          child: _overviewCard(
            label: 'Perlu dikejar',
            labelColor: FitColors.rose600,
            icon: Icons.warning_amber_rounded,
            iconBg: const Color(0xCCFFE4E6),
            top: const Color(0xB3FFF1F2),
            border: const Color(0xE6FFE4E6),
            value: terlewat,
            caption: 'Latihan terlewat',
            captionColor: const Color(0xE6F43F5E),
            accent: FitColors.rose400,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _overviewCard(
            label: 'Tersisa minggu ini',
            labelColor: const Color(0xFF1A4EF5),
            icon: Icons.calendar_month_outlined,
            iconBg: const Color(0xCCDBEAFE),
            top: const Color(0xB3EFF6FF),
            border: const Color(0xE6DBEAFE),
            value: tersisa,
            caption: 'Latihan tersisa',
            captionColor: FitColors.slate500,
            accent: const Color(0xFF2B66FF),
          ),
        ),
      ],
    );
  }

  Widget _overviewCard({
    required String label,
    required Color labelColor,
    required IconData icon,
    required Color iconBg,
    required Color top,
    required Color border,
    required int value,
    required String caption,
    required Color captionColor,
    required Color accent,
  }) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [top, Colors.white],
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
                child: Text(
                  label,
                  overflow: TextOverflow.ellipsis,
                  style: fitText(12, FontWeight.w700, labelColor),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                width: 28,
                height: 28,
                decoration:
                    BoxDecoration(color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, size: 16, color: labelColor),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '$value',
            style: fitText(30, FontWeight.w800, FitColors.slate900,
                letterSpacing: -0.5),
          ),
          Text(caption, style: fitText(11, FontWeight.w600, captionColor)),
          const SizedBox(height: 8),
          Container(
            height: 2,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              color: accent.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmpty() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 32),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: FitColors.slate100),
      ),
      child: Column(
        children: [
          const Icon(Icons.event_available_outlined,
              size: 36, color: FitColors.slate300),
          const SizedBox(height: 10),
          Text('Belum ada jadwal latihan',
              style: fitText(14, FontWeight.w700, FitColors.slate700)),
          const SizedBox(height: 4),
          Text(
            'Tekan "Tambah Latihan" untuk mulai menyusun jadwalmu.',
            textAlign: TextAlign.center,
            style: fitText(12, FontWeight.w500, FitColors.slate400),
          ),
        ],
      ),
    );
  }

  // ----------------------------------------------------------------- Section

  Widget _buildSection(_Section section, List<_Item> items) {
    final isLate = section == _Section.terlambat;
    final isFar = section == _Section.mingguDepan;

    final String label = isLate
        ? 'TERLAMBAT'
        : (section == _Section.hariIni
            ? 'HARI INI'
            : (section == _Section.besok ? 'BESOK' : 'MINGGU DEPAN'));
    final Color dot = isLate
        ? FitColors.rose500
        : (isFar ? FitColors.slate400 : const Color(0xFF2B66FF));
    final Color labelColor = isLate
        ? FitColors.rose600
        : (isFar ? FitColors.slate500 : FitColors.slate600);

    Widget trailing;
    if (isFar) {
      final days = items.map((e) => e.when.split(',').first).toSet().join(' & ');
      trailing = Text(days, style: fitText(11, FontWeight.w600, FitColors.slate400));
    } else {
      trailing = Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: isLate ? FitColors.rose50 : FitColors.blue50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isLate ? const Color(0x80FECDD3) : FitColors.blue100,
          ),
        ),
        child: Text(
          '${items.length} Aktivitas',
          style: fitText(
            11,
            FontWeight.w600,
            isLate ? FitColors.rose500 : FitColors.blue600,
          ),
        ),
      );
    }

    return Column(
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
                  decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(label,
                    style: fitText(12, FontWeight.w700, labelColor,
                        letterSpacing: 0.8)),
              ],
            ),
            Flexible(child: trailing),
          ],
        ),
        const SizedBox(height: 12),
        for (var i = 0; i < items.length; i++) ...[
          _buildItemCard(items[i], section),
          if (i != items.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _checkbox({
    required bool checked,
    required Color border,
    required Color fill,
    required Color checkedColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: checked ? checkedColor : fill,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: checked ? checkedColor : border, width: 2),
        ),
        child: checked
            ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
            : null,
      ),
    );
  }

  Widget _buildItemCard(_Item item, _Section section) {
    final isLate = section == _Section.terlambat;
    final isFar = section == _Section.mingguDepan;

    final Color border = isLate ? FitColors.rose200 : FitColors.slate100;
    final Color boxBorder = isLate ? FitColors.rose300 : FitColors.slate300;
    final Color boxFill = isLate ? const Color(0x80FFF1F2) : FitColors.slate50;
    final Color checkedColor =
        isLate ? FitColors.rose500 : const Color(0xFF2B66FF);
    final Color whenColor = isLate
        ? FitColors.rose500
        : (isFar ? FitColors.slate600 : const Color(0xFF1A4EF5));

    Widget trailing;
    if (isLate) {
      trailing = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _reschedule(item),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: FitColors.rose50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: FitColors.rose200),
          ),
          child: Text('Jadwal Ulang',
              style: fitText(11, FontWeight.w700, FitColors.rose600)),
        ),
      );
    } else {
      trailing = Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: isFar ? FitColors.slate50 : FitColors.blue50,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          item.icon,
          size: 18,
          color: isFar ? FitColors.slate600 : const Color(0xFF1A4EF5),
        ),
      );
    }

    return Opacity(
      opacity: item.done ? 0.5 : 1,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: item.done ? const Color(0xCCF8FAFC) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: border),
          boxShadow: FitColors.softShadow,
        ),
        child: Row(
          children: [
            _checkbox(
              checked: item.done,
              border: boxBorder,
              fill: boxFill,
              checkedColor: checkedColor,
              onTap: () => setState(() => item.done = !item.done),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    overflow: TextOverflow.ellipsis,
                    style: fitText(14, FontWeight.w700, FitColors.slate900),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(item.when,
                          style: fitText(12, FontWeight.w500, whenColor)),
                      const SizedBox(width: 6),
                      Container(
                        width: 4,
                        height: 4,
                        decoration: const BoxDecoration(
                          color: FitColors.slate300,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          item.tag,
                          overflow: TextOverflow.ellipsis,
                          style: fitText(
                              11, FontWeight.w500, FitColors.slate400),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            trailing,
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------- Tombol tambah

  Widget _buildAddButton() {
    return GestureDetector(
      onTap: _openTugasBaru,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [FitColors.blue600, FitColors.blue700],
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: FitColors.glowBlue,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Color(0x33FFFFFF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_rounded,
                  size: 15, color: Colors.white),
            ),
            const SizedBox(width: 8),
            Text('Tambah Latihan',
                style: fitText(12, FontWeight.w700, Colors.white)),
          ],
        ),
      ),
    );
  }
}
