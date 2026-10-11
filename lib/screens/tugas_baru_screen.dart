import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/fit_colors.dart';
import '../utils/id_date.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/square_icon_button.dart';

/// Hasil dari form Tugas Baru, dikirim balik ke halaman Jadwal.
class NewWorkout {
  const NewWorkout({
    required this.title,
    required this.date,
    required this.hour24,
    required this.minute,
    this.repeatLabel,
  });

  final String title;
  final DateTime date;
  final int hour24;
  final int minute;
  final String? repeatLabel;
}

class TugasBaruScreen extends StatefulWidget {
  const TugasBaruScreen({super.key});

  @override
  State<TugasBaruScreen> createState() => _TugasBaruScreenState();
}

class _TugasBaruScreenState extends State<TugasBaruScreen> {
  static const List<String> _quickLabels = [
    'Berlari',
    'Jalan santai',
    'Push Up',
    'Bersepeda',
  ];
  static const List<String> _quickEmoji = ['🏃', '🚶', '💪', '🚴'];
  static const List<String> _dayShort = [
    'Sen',
    'Sel',
    'Rab',
    'Kam',
    'Jum',
    'Sab',
    'Min',
  ];
  static const List<String> _repeatOptions = [
    'Sekali seminggu',
    'Setiap hari',
    'Senin - Jumat',
  ];

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();

  // Error merah baru muncul setelah user menekan Simpan sekali.
  AutovalidateMode _autoMode = AutovalidateMode.disabled;

  bool _bulk = false;
  final Set<int> _bulkDays = {};

  late DateTime _date;
  int _hour12 = 12;
  int _minute = 0;
  bool _isPm = true;

  bool _repeat = true;
  String _repeatChoice = _repeatOptions.first;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _date = DateTime(now.year, now.month, now.day);
    _titleController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  int get _hour24 => (_hour12 % 12) + (_isPm ? 12 : 0);

  DateTime get _today {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
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

  Future<void> _pickDate() async {
    FocusScope.of(context).unfocus();
    final today = _today;
    final picked = await showDatePicker(
      context: context,
      initialDate: _date.isBefore(today) ? today : _date,
      firstDate: today,
      lastDate: DateTime(today.year + 1, today.month, today.day),
    );
    if (!mounted) return;
    if (picked != null) {
      setState(() => _date = DateTime(picked.year, picked.month, picked.day));
    }
  }

  Future<void> _pickTime() async {
    FocusScope.of(context).unfocus();
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: _hour24, minute: _minute),
    );
    if (!mounted) return;
    if (picked != null) {
      setState(() {
        _isPm = picked.hour >= 12;
        _hour12 = picked.hour % 12 == 0 ? 12 : picked.hour % 12;
        _minute = picked.minute;
      });
    }
  }

  void _showInfo() {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tips'),
        content: const Text(
          'Isi nama latihan, pilih tanggal dan jam, lalu tekan Simpan Latihan. '
          'Aktifkan "Tambah secara massal" untuk menjadwalkan ke beberapa hari sekaligus.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Mengerti'),
          ),
        ],
      ),
    );
  }

  void _save() {
    FocusScope.of(context).unfocus();
    setState(() => _autoMode = AutovalidateMode.onUserInteraction);

    final valid = _formKey.currentState?.validate() ?? false;
    if (!valid) return;

    if (_bulk && _bulkDays.isEmpty) {
      _toast('Pilih minimal satu hari untuk jadwal massal');
      return;
    }

    final title = _titleController.text.trim();
    final repeatLabel = _repeat ? _repeatChoice : null;
    final results = <NewWorkout>[];

    if (_bulk) {
      final days = _bulkDays.toList()..sort();
      for (final weekday in days) {
        final offset = (weekday - _date.weekday + 7) % 7;
        results.add(NewWorkout(
          title: title,
          date: DateTime(_date.year, _date.month, _date.day + offset),
          hour24: _hour24,
          minute: _minute,
          repeatLabel: repeatLabel,
        ));
      }
    } else {
      results.add(NewWorkout(
        title: title,
        date: _date,
        hour24: _hour24,
        minute: _minute,
        repeatLabel: repeatLabel,
      ));
    }

    Navigator.of(context).pop(results);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FitColors.bg,
      body: SafeArea(
        child: Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                children: [
                  _buildTopBar(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 130),
                      child: Form(
                        key: _formKey,
                        autovalidateMode: _autoMode,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _sectionLabel('APA YANG HARUS DILAKUKAN?'),
                            const SizedBox(height: 10),
                            _buildActivityCard(),
                            const SizedBox(height: 20),
                            _sectionLabel('WAKTU & PENGINGAT'),
                            const SizedBox(height: 10),
                            _buildTimeCard(),
                            const SizedBox(height: 20),
                            _buildSaveButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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

  Widget _buildTopBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SquareIconButton(
            icon: Icons.chevron_left_rounded,
            label: 'Kembali',
            onTap: () => Navigator.of(context).maybePop(),
          ),
          Text('Tugas Baru',
              style: fitText(18, FontWeight.w700, FitColors.slate900,
                  letterSpacing: -0.2)),
          SquareIconButton(
            icon: Icons.info_outline_rounded,
            iconColor: FitColors.slate500,
            label: 'Bantuan',
            onTap: _showInfo,
          ),
        ],
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text,
        style: fitText(12, FontWeight.w700, FitColors.slate500,
            letterSpacing: 0.8),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      border: Border.all(color: const Color(0xB3EFF6FF)),
      boxShadow: const [
        BoxShadow(
          color: Color(0x0F2563EB),
          blurRadius: 25,
          spreadRadius: -4,
          offset: Offset(0, 10),
        ),
      ],
    );
  }

  // ------------------------------------------------------ Kartu nama latihan

  OutlineInputBorder _border(Color color, [double width = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  Widget _buildActivityCard() {
    final current = _titleController.text.trim();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _titleController,
            textInputAction: TextInputAction.done,
            textCapitalization: TextCapitalization.sentences,
            inputFormatters: [LengthLimitingTextInputFormatter(40)],
            style: fitText(15, FontWeight.w600, FitColors.slate800),
            validator: (value) {
              final text = (value ?? '').trim();
              if (text.isEmpty) return 'Nama latihan wajib diisi';
              if (text.length < 3) return 'Nama latihan minimal 3 karakter';
              return null;
            },
            decoration: InputDecoration(
              hintText: 'Contoh: Lari 30 menit',
              hintStyle: fitText(15, FontWeight.w500, FitColors.slate400),
              prefixIcon: const Icon(Icons.edit_outlined,
                  size: 20, color: FitColors.blue500),
              filled: true,
              fillColor: FitColors.slate50,
              contentPadding: const EdgeInsets.symmetric(vertical: 14),
              errorStyle:
                  fitText(11.5, FontWeight.w500, const Color(0xFFD84343)),
              border: _border(FitColors.slate200),
              enabledBorder: _border(FitColors.slate200),
              focusedBorder: _border(FitColors.blue500, 1.5),
              errorBorder: _border(const Color(0xFFD84343)),
              focusedErrorBorder: _border(const Color(0xFFD84343), 1.5),
            ),
          ),
          const SizedBox(height: 14),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (var i = 0; i < _quickLabels.length; i++) ...[
                  _quickChip(i, current == _quickLabels[i]),
                  if (i != _quickLabels.length - 1) const SizedBox(width: 6),
                ],
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(height: 1, color: FitColors.slate100),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tambah secara massal',
                        style: fitText(
                            14, FontWeight.w600, FitColors.slate700)),
                    const SizedBox(height: 2),
                    Text('Jadwalkan ke beberapa hari sekaligus',
                        style: fitText(
                            11, FontWeight.w400, FitColors.slate400)),
                  ],
                ),
              ),
              _PillSwitch(
                value: _bulk,
                onColor: FitColors.blue600,
                offColor: FitColors.slate200,
                onChanged: (v) => setState(() => _bulk = v),
              ),
            ],
          ),
          if (_bulk) ...[
            const SizedBox(height: 14),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (var i = 0; i < _dayShort.length; i++) _dayChip(i + 1),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Pilih hari latihan (minimal satu)',
              style: fitText(11, FontWeight.w500, FitColors.slate400),
            ),
          ],
        ],
      ),
    );
  }

  Widget _quickChip(int index, bool selected) {
    return GestureDetector(
      onTap: () {
        _titleController.text = _quickLabels[index];
        _titleController.selection = TextSelection.collapsed(
          offset: _titleController.text.length,
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? FitColors.blue50 : FitColors.slate50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? FitColors.blue100 : FitColors.slate100),
        ),
        child: Text(
          '${_quickEmoji[index]} ${_quickLabels[index]}',
          style: fitText(12, FontWeight.w600,
              selected ? FitColors.blue600 : FitColors.slate600),
        ),
      ),
    );
  }

  Widget _dayChip(int weekday) {
    final selected = _bulkDays.contains(weekday);
    return GestureDetector(
      onTap: () {
        setState(() {
          if (selected) {
            _bulkDays.remove(weekday);
          } else {
            _bulkDays.add(weekday);
          }
        });
      },
      child: Container(
        width: 42,
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? FitColors.blue600 : FitColors.slate50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: selected ? FitColors.blue600 : FitColors.slate200),
        ),
        child: Text(
          _dayShort[weekday - 1],
          style: fitText(12, FontWeight.w700,
              selected ? Colors.white : FitColors.slate600),
        ),
      ),
    );
  }

  // ------------------------------------------------------ Kartu waktu

  Widget _buildTimeCard() {
    final hh = _hour12.toString().padLeft(2, '0');
    final mm = _minute.toString().padLeft(2, '0');

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Hari & Tanggal',
              style: fitText(12, FontWeight.w600, FitColors.slate500)),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: _pickDate,
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0x66EFF6FF), Color(0x4DEEF2FF)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xB3DBEAFE)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0x1A2563EB),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.calendar_month_outlined,
                        size: 20, color: FitColors.blue600),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          IdDate.full(_date),
                          style: fitText(
                              14, FontWeight.w700, FitColors.slate800),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Pengingat aktif jam latihan',
                          style: fitText(
                              11, FontWeight.w500, FitColors.blue600),
                        ),
                      ],
                    ),
                  ),
                  const Icon(Icons.chevron_right_rounded,
                      size: 22, color: FitColors.blue600),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text('Jam Latihan',
              style: fitText(12, FontWeight.w600, FitColors.slate500)),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: FitColors.slate50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: FitColors.slate100),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _pickTime,
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0x1AF59E0B),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.schedule_rounded,
                              size: 20, color: FitColors.amber500),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '$hh:$mm',
                          style: fitText(16, FontWeight.w800,
                              FitColors.slate800, letterSpacing: 0.4),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _isPm ? 'PM' : 'AM',
                          style: fitText(
                              12, FontWeight.w700, FitColors.slate500),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: const Color(0xCCE2E8F0),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _ampmButton('AM', !_isPm, () {
                        setState(() => _isPm = false);
                      }),
                      _ampmButton('PM', _isPm, () {
                        setState(() => _isPm = true);
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildRepeatCard(),
        ],
      ),
    );
  }

  Widget _ampmButton(String label, bool selected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: selected ? FitColors.softShadow : null,
        ),
        child: Text(
          label,
          style: fitText(12, FontWeight.w700,
              selected ? FitColors.blue600 : FitColors.slate500),
        ),
      ),
    );
  }

  Widget _buildRepeatCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: FitColors.blue600,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0x332563EB),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: const Color(0x33FFFFFF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.repeat_rounded,
                          size: 17, color: Colors.white),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Ulangi Rutinitas',
                              style: fitText(
                                  14, FontWeight.w700, Colors.white)),
                          const SizedBox(height: 2),
                          Text('Otomatis masuk jadwal rutin',
                              style: fitText(
                                  11, FontWeight.w400, FitColors.blue100)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              _PillSwitch(
                value: _repeat,
                onColor: const Color(0x66FFFFFF),
                offColor: const Color(0x4DFFFFFF),
                onChanged: (v) => setState(() => _repeat = v),
              ),
            ],
          ),
          if (_repeat) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final option in _repeatOptions) _repeatChip(option),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _repeatChip(String label) {
    final selected = _repeatChoice == label;
    return GestureDetector(
      onTap: () => setState(() => _repeatChoice = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? Colors.white : const Color(0x33FFFFFF),
          borderRadius: BorderRadius.circular(20),
          boxShadow: selected ? FitColors.softShadow : null,
        ),
        child: Text(
          label,
          style: fitText(
            12,
            selected ? FontWeight.w700 : FontWeight.w500,
            selected ? FitColors.blue600 : Colors.white,
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------ Tombol simpan

  Widget _buildSaveButton() {
    return GestureDetector(
      onTap: _save,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: FitColors.blue600,
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(
              color: Color(0x6B1D4ED8),
              blurRadius: 24,
              spreadRadius: -6,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Simpan Latihan',
                style: fitText(16, FontWeight.w700, Colors.white)),
            const SizedBox(width: 8),
            const Icon(Icons.check_rounded, size: 20, color: Colors.white),
          ],
        ),
      ),
    );
  }
}

/// Saklar bentuk pil sesuai desain (lebih mirip HTML daripada Switch bawaan).
class _PillSwitch extends StatelessWidget {
  const _PillSwitch({
    required this.value,
    required this.onChanged,
    required this.onColor,
    required this.offColor,
  });

  final bool value;
  final ValueChanged<bool> onChanged;
  final Color onColor;
  final Color offColor;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 48,
        height: 26,
        padding: const EdgeInsets.all(3),
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        decoration: BoxDecoration(
          color: value ? onColor : offColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
