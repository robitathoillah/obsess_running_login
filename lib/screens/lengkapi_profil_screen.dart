import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/bmi_calculator.dart';
import '../utils/validators.dart';
import 'profil_berhasil_screen.dart';

class LengkapiProfilScreen extends StatefulWidget {
  const LengkapiProfilScreen({super.key});

  @override
  State<LengkapiProfilScreen> createState() => _LengkapiProfilScreenState();
}

class _LengkapiProfilScreenState extends State<LengkapiProfilScreen> {
  final _formKey = GlobalKey<FormState>();

final _usiaController = TextEditingController();
final _tinggiController = TextEditingController();
final _beratController = TextEditingController();
final _targetBeratController = TextEditingController();

String _jenisKelamin = '';
  bool _isSubmitting = false;

  BmiResult _bmi = const BmiResult(value: 0, category: '-', color: Colors.grey);

  @override
  void initState() {
    super.initState();
    _recalculateBmi();
    // Setiap tinggi/berat berubah, BMI ikut di-refresh live.
    _tinggiController.addListener(_recalculateBmi);
    _beratController.addListener(_recalculateBmi);
  }

  void _recalculateBmi() {
    final tinggi = double.tryParse(_tinggiController.text.trim());
    final berat = double.tryParse(_beratController.text.trim());
    if (tinggi == null || berat == null) return;
    setState(() {
      _bmi = BmiCalculator.calculate(heightCm: tinggi, weightKg: berat);
    });
  }

  @override
  void dispose() {
    _usiaController.dispose();
    _tinggiController.dispose();
    _beratController.dispose();
    _targetBeratController.dispose();
    super.dispose();
  }

  Future<void> _handleSimpan() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;
    if (!isValid) return;
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);
    try {
      // TODO: simpan data profil ke backend/local storage di sini.
      await Future.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;

      final beratSaatIni = double.tryParse(_beratController.text.trim()) ?? 0;
      final targetBerat =
          double.tryParse(_targetBeratController.text.trim()) ?? 0;

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProfilBerhasilScreen(
            targetBeratKg: targetBerat,
            selisihBeratKg: beratSaatIni - targetBerat,
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  void _handleLewati() {
    // "Lewati" = skip lengkapi profil, langsung balik ke Login. Stack
    // dibersihkan total supaya tombol back nggak nyasar ke form registrasi.
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTopBar(),
                  const SizedBox(height: 18),
                  const Text(
                    'Lengkapi Profil Anda',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Agar kami bisa membuat rencana latihan & target lari yang sesuai untuk Anda.',
                    style: TextStyle(
                      fontSize: 12.5,
                      height: 1.4,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(child: _buildUsiaField()),
                      const SizedBox(width: 12),
                      Expanded(child: _buildJenisKelaminField()),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildNumberCard(
                          label: 'TINGGI BADAN',
                          controller: _tinggiController,
                          unit: 'cm',
                          validator: Validators.numberInRange(
                              label: 'Tinggi badan', min: 100, max: 250),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildNumberCard(
                          label: 'BERAT BADAN',
                          controller: _beratController,
                          unit: 'kg',
                          validator: Validators.numberInRange(
                              label: 'Berat badan', min: 20, max: 300),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTargetBeratCard(),
                  const SizedBox(height: 12),
                  _buildBmiCard(),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : _handleSimpan,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor:
                            AppColors.primary.withOpacity(0.6),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                                color: Colors.white,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Simpan & Lanjut',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700),
                                ),
                                SizedBox(width: 6),
                                Icon(Icons.arrow_forward_rounded, size: 18),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Center(
                    child: Text(
                      'Data ini dapat Anda perbarui kapan saja di menu profil.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 11, color: AppColors.textSecondary),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => Navigator.of(context).maybePop(),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: AppColors.badgeBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.arrow_back_rounded,
                size: 18, color: AppColors.primary),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: AppColors.badgeBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            'Langkah 2 dari 2',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.primary,
            ),
          ),
        ),
        GestureDetector(
          onTap: _handleLewati,
          child: const Text(
            'Lewati',
            style: TextStyle(fontSize: 12.5, color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 12,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _buildUsiaField() {
    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).unfocus();
        final picked = await _showPickerSheet(
          title: 'Pilih Usia',
          options: List.generate(70, (i) => '${i + 10}'),
          selected: _usiaController.text,
        );
        if (picked != null) {
          setState(() => _usiaController.text = picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'USIA',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${_usiaController.text} Thn',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJenisKelaminField() {
    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).unfocus();
        final picked = await _showPickerSheet(
          title: 'Pilih Jenis Kelamin',
          options: const ['Laki-Laki', 'Perempuan'],
          selected: _jenisKelamin,
        );
        if (picked != null) {
          setState(() => _jenisKelamin = picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: _cardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'JENIS KELAMIN',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    _jenisKelamin,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<String?> _showPickerSheet({
    required String title,
    required List<String> options,
    required String selected,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 12),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.divider,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 14),
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              SizedBox(
                height: 280,
                child: ListView.builder(
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options[index];
                    final isSelected = option == selected;
                    return ListTile(
                      title: Text(
                        option,
                        style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_rounded,
                              color: AppColors.primary)
                          : null,
                      onTap: () => Navigator.of(context).pop(option),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildNumberCard({
    required String label,
    required TextEditingController controller,
    required String unit,
    required String? Function(String?) validator,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.4,
              color: AppColors.textSecondary,
            ),
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  validator: validator,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    errorStyle: TextStyle(fontSize: 10.5, color: Color(0xFFD84343)),
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.badgeBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  unit,
                  style: const TextStyle(
                      fontSize: 11, color: AppColors.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTargetBeratCard() {
    final berat = double.tryParse(_beratController.text.trim());
    final target = double.tryParse(_targetBeratController.text.trim());
    String badgeText = 'Target lari ideal';
    if (berat != null && target != null) {
      final selisih = berat - target;
      if (selisih > 0) {
        badgeText = '↓ ${selisih.toStringAsFixed(0)} kg target lari ideal';
      } else if (selisih < 0) {
        badgeText =
            '↑ ${selisih.abs().toStringAsFixed(0)} kg target lari ideal';
      } else {
        badgeText = 'Sudah di berat ideal';
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'TARGET BERAT BADAN',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.4,
                  color: AppColors.textSecondary,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFFCEFDB),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  badgeText,
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFB9791C),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _targetBeratController,
                  keyboardType: TextInputType.number,
                  validator: Validators.numberInRange(
                      label: 'Target berat badan', min: 20, max: 300),
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    errorStyle: TextStyle(fontSize: 10.5, color: Color(0xFFD84343)),
                    contentPadding: EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
              ),
              const Text('kg',
                  style: TextStyle(fontSize: 12, color: AppColors.textSecondary)),
              const SizedBox(width: 10),
              const Icon(Icons.schedule_rounded,
                  size: 14, color: AppColors.primary),
              const SizedBox(width: 3),
              const Text(
                'Pacing Otomatis',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.link,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBmiCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: _cardDecoration().copyWith(
        border: Border.all(color: AppColors.divider),
      ),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.monitor_weight_outlined,
                size: 18, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'INDEKS MASSA TUBUH (BMI)',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${_bmi.value} ',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      TextSpan(
                        text: '• ${_bmi.category}',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _bmi.color,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _bmi.category == 'Kategori Normal' ? 'Sehat' : 'Cek',
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppColors.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
