import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/fit_colors.dart';
import '../widgets/app_bottom_nav.dart';

/// Hasil dari sheet Edit Profil.
class _ProfileEdit {
  const _ProfileEdit(this.name, this.location);

  final String name;
  final String location;
}

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // TODO: ganti data contoh ini dengan data profil asli pengguna.
  static const String _photoUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuDH-Rk82q3MbWRNzOIQWQe26jsxwm2L3rhXRt0mr0nJWAUlC2QmVCtWgihcz_rtpdoOEhB0-rVP2IuJa_1H3Ct6Az9ShIOusUWz1Upr0Y3wLQwiDxnd8RKrw7r7-GOz5qbSRyabugyS69k1gKpvIuqOtTYHdRg0u3Z-twc_dH3ovSJyMub_FzSHjNQIgmtEpOm7NCuIoKmaarJvXnc0Qx22vsOjQ--K_r245OCDhjWd';

  static const double _weekDone = 38.5;
  static const double _weekTarget = 45;
  static const int _daysLeft = 3;
  static const int _streakWeeks = 4;

  String _name = 'Fiqih Al Firdaus';
  String _location = 'Jember, Indonesia';

  String _initials(String name) {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts[1][0]).toUpperCase();
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

  Future<void> _editProfile() async {
    final result = await showModalBottomSheet<_ProfileEdit>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _EditProfileSheet(
        initialName: _name,
        initialLocation: _location,
      ),
    );
    if (!mounted || result == null) return;
    setState(() {
      _name = result.name;
      _location = result.location;
    });
    _toast('Profil diperbarui');
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
              // Latar gradasi biru di bagian atas.
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: topInset + 76,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [FitColors.blue600, FitColors.blue500],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0x333B82F6),
                        blurRadius: 6,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  SizedBox(height: topInset + 12),
                  _buildTitleRow(),
                  const SizedBox(height: 16),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 130),
                      child: Column(
                        children: [
                          _buildProfileCard(),
                          const SizedBox(height: 16),
                          _buildStatsRow(),
                          const SizedBox(height: 16),
                          _buildWeeklyGoal(),
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
                child: AppBottomNav(current: AppTab.profile),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        height: 32,
        child: Row(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => goToTab(context, AppTab.home, from: AppTab.profile),
              child: const Padding(
                padding: EdgeInsets.only(right: 12),
                child:
                    Icon(Icons.arrow_back_rounded, size: 24, color: Colors.white),
              ),
            ),
            Text('Profile',
                style: fitText(20, FontWeight.w700, Colors.white,
                    letterSpacing: -0.2)),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------------------------ Kartu profil

  BoxDecoration _cardDecoration(double radius) {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(radius),
      border: Border.all(color: FitColors.slate100),
      boxShadow: const [
        BoxShadow(
          color: Color(0x140D72B9),
          blurRadius: 34,
          spreadRadius: -4,
          offset: Offset(0, 14),
        ),
      ],
    );
  }

  Widget _initialsAvatar() {
    return Container(
      color: FitColors.blue100,
      alignment: Alignment.center,
      child: Text(
        _initials(_name),
        style: fitText(30, FontWeight.w800, FitColors.blue600),
      ),
    );
  }

  Widget _buildAvatar() {
    return SizedBox(
      width: 96,
      height: 96,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 96,
            height: 96,
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [Color(0xFF38BDF8), FitColors.blue600],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0x1A000000),
                  blurRadius: 6,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ClipOval(
                // Kalau foto gagal dimuat (offline / diblokir), tampil inisial.
                child: Image.network(
                  _photoUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stack) => _initialsAvatar(),
                  loadingBuilder: (context, child, progress) =>
                      progress == null ? child : _initialsAvatar(),
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: GestureDetector(
              onTap: () => _toast('Ganti foto profil belum tersedia'),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: FitColors.blue600,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 6,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: const Icon(Icons.photo_camera_outlined,
                    size: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: _cardDecoration(24),
      child: Column(
        children: [
          _buildAvatar(),
          const SizedBox(height: 14),
          Text(
            _name,
            textAlign: TextAlign.center,
            style: fitText(20, FontWeight.w800, FitColors.slate800,
                letterSpacing: -0.3),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.place_rounded,
                  size: 14, color: FitColors.slate400),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  _location,
                  overflow: TextOverflow.ellipsis,
                  style: fitText(12, FontWeight.w500, FitColors.slate500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _editProfile,
            child: Container(
              width: 210,
              padding: const EdgeInsets.symmetric(vertical: 11),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                gradient: const LinearGradient(
                  colors: [FitColors.blue600, FitColors.blue500],
                ),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x403B82F6),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.edit_outlined,
                      size: 16, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Edit Profil',
                      style: fitText(14, FontWeight.w600, Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------ Ringkasan

  Widget _buildStatsRow() {
    // IntrinsicHeight wajib: Row dengan stretch tidak boleh berada langsung
    // di dalam scroll (tinggi tak terbatas), kalau tidak halaman jadi kosong.
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _stat(
              icon: Icons.straighten_rounded,
              fg: const Color(0xFF0284C7),
              bg: const Color(0xFFF0F9FF),
              value: '248.5',
              label: 'TOTAL JARAK',
              sub: 'kilometer',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _stat(
              icon: Icons.schedule_rounded,
              fg: FitColors.blue600,
              bg: FitColors.blue50,
              value: '28j 45m',
              label: 'DURASI',
              sub: 'Bulan Ini',
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _stat(
              icon: Icons.speed_rounded,
              fg: const Color(0xFF4F46E5),
              bg: const Color(0xFFEEF2FF),
              value: '5\'24"',
              label: 'RATA-RATA',
              sub: 'per km',
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat({
    required IconData icon,
    required Color fg,
    required Color bg,
    required String value,
    required String label,
    required String sub,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(16),
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
            child: Icon(icon, size: 16, color: fg),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: fitText(16, FontWeight.w700, FitColors.slate800),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            textAlign: TextAlign.center,
            style: fitText(9, FontWeight.w600, FitColors.slate400,
                letterSpacing: 0.2),
          ),
          Text(
            sub,
            textAlign: TextAlign.center,
            style: fitText(8, FontWeight.w400, FitColors.slate400),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------- Target mingguan

  Widget _buildWeeklyGoal() {
    final ratio = (_weekDone / _weekTarget).clamp(0.0, 1.0).toDouble();
    final percent = (ratio * 100).floor();
    final remaining = (_weekTarget - _weekDone).clamp(0.0, double.infinity);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(16),
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
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFFBEB),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.flag_rounded,
                          size: 16, color: FitColors.amber500),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Target Lari Mingguan',
                              style: fitText(
                                  14, FontWeight.w700, FitColors.slate800,
                                  height: 1.2)),
                          Text('Sisa $_daysLeft hari lagi di minggu ini',
                              style: fitText(
                                  11, FontWeight.w500, FitColors.slate400,
                                  height: 1.3)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFBEB),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0x80FDE68A)),
                ),
                child: Text('$percent%',
                    style: fitText(12, FontWeight.w700, FitColors.amber700)),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text.rich(
                TextSpan(
                  text: _weekDone.toStringAsFixed(1),
                  style: fitText(16, FontWeight.w700, FitColors.slate800),
                  children: [
                    TextSpan(
                      text: ' / ${_weekTarget.toStringAsFixed(0)} km',
                      style:
                          fitText(12, FontWeight.w500, FitColors.slate400),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.bolt_rounded,
                      size: 13, color: Color(0xFFD97706)),
                  const SizedBox(width: 2),
                  Text(
                    'Tinggal ${remaining.toStringAsFixed(1)} km lagi!',
                    style: fitText(11, FontWeight.w600, const Color(0xFFD97706)),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 10,
            decoration: BoxDecoration(
              color: FitColors.slate100,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FractionallySizedBox(
                widthFactor: ratio,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFBBF24), FitColors.amber500],
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: FitColors.slate100),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    const Icon(Icons.emoji_events_rounded,
                        size: 17, color: FitColors.amber500),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Streak lari $_streakWeeks minggu berturut-turut!',
                        style: fitText(
                            11, FontWeight.w500, FitColors.slate600),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('Hebat',
                    style: fitText(
                        10, FontWeight.w700, const Color(0xFF0284C7))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Sheet Edit Profil. Dibuat sebagai widget terpisah supaya controller-nya
/// dibuang dengan aman setelah sheet benar-benar tertutup.
class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet({
    required this.initialName,
    required this.initialLocation,
  });

  final String initialName;
  final String initialLocation;

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _locationController;

  // Pesan error baru muncul setelah user menekan Simpan.
  AutovalidateMode _autoMode = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _locationController = TextEditingController(text: widget.initialLocation);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  OutlineInputBorder _border(Color color, [double width = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  InputDecoration _decoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: fitText(14, FontWeight.w500, FitColors.slate400),
      prefixIcon: Icon(icon, size: 20, color: FitColors.blue500),
      filled: true,
      fillColor: FitColors.slate50,
      contentPadding: const EdgeInsets.symmetric(vertical: 14),
      errorStyle: fitText(11.5, FontWeight.w500, const Color(0xFFD84343)),
      border: _border(FitColors.slate200),
      enabledBorder: _border(FitColors.slate200),
      focusedBorder: _border(FitColors.blue500, 1.5),
      errorBorder: _border(const Color(0xFFD84343)),
      focusedErrorBorder: _border(const Color(0xFFD84343), 1.5),
    );
  }

  void _save() {
    FocusScope.of(context).unfocus();
    setState(() => _autoMode = AutovalidateMode.onUserInteraction);
    if (!(_formKey.currentState?.validate() ?? false)) return;

    Navigator.of(context).pop(
      _ProfileEdit(
        _nameController.text.trim(),
        _locationController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(24, 12, 24, 24 + keyboard),
      child: Form(
        key: _formKey,
        autovalidateMode: _autoMode,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: FitColors.slate200,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text('Edit Profil',
                style: fitText(18, FontWeight.w800, FitColors.slate900)),
            const SizedBox(height: 16),
            Text('Nama Lengkap',
                style: fitText(12, FontWeight.w600, FitColors.slate500)),
            const SizedBox(height: 6),
            TextFormField(
              controller: _nameController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.next,
              inputFormatters: [LengthLimitingTextInputFormatter(40)],
              style: fitText(15, FontWeight.w600, FitColors.slate800),
              decoration: _decoration('Nama lengkap', Icons.person_outline),
              validator: (value) {
                final text = (value ?? '').trim();
                if (text.isEmpty) return 'Nama lengkap wajib diisi';
                if (text.length < 3) return 'Nama lengkap minimal 3 karakter';
                return null;
              },
            ),
            const SizedBox(height: 14),
            Text('Lokasi',
                style: fitText(12, FontWeight.w600, FitColors.slate500)),
            const SizedBox(height: 6),
            TextFormField(
              controller: _locationController,
              textCapitalization: TextCapitalization.words,
              textInputAction: TextInputAction.done,
              inputFormatters: [LengthLimitingTextInputFormatter(40)],
              style: fitText(15, FontWeight.w600, FitColors.slate800),
              decoration: _decoration('Kota, Negara', Icons.place_outlined),
              onFieldSubmitted: (_) => _save(),
              validator: (value) {
                final text = (value ?? '').trim();
                if (text.isEmpty) return 'Lokasi wajib diisi';
                if (text.length < 2) return 'Lokasi minimal 2 karakter';
                return null;
              },
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _save,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                  color: FitColors.blue600,
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: Text('Simpan',
                    style: fitText(15, FontWeight.w700, Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
