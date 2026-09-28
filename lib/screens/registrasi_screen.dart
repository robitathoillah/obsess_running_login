import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../utils/validators.dart';
import '../widgets/app_text_field.dart';
import 'lengkapi_profil_screen.dart';

class RegistrasiScreen extends StatefulWidget {
  const RegistrasiScreen({super.key});

  @override
  State<RegistrasiScreen> createState() => _RegistrasiScreenState();
}

class _RegistrasiScreenState extends State<RegistrasiScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    FocusScope.of(context).unfocus();

    final isValid = _formKey.currentState?.validate() ?? false;

    // Checkbox syarat & ketentuan divalidasi terpisah (bukan bagian dari
    // Form) karena bukan TextFormField.
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('Kamu harus menyetujui Syarat & Ketentuan terlebih dahulu'),
          backgroundColor: Color(0xFFD84343),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    if (!isValid) return;
    if (_isSubmitting) return;

    setState(() => _isSubmitting = true);
    try {
      // TODO: ganti simulasi ini dengan pemanggilan API/Firebase asli.
      await Future.delayed(const Duration(milliseconds: 900));
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Akun untuk ${_nameController.text.trim()} berhasil dibuat'),
          backgroundColor: AppColors.primary,
          behavior: SnackBarBehavior.floating,
        ),
      );

      // Lanjut ke halaman Lengkapi Profil setelah akun berhasil dibuat.
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const LengkapiProfilScreen()),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
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
                  _buildIntroCard(),
                  const SizedBox(height: 20),
                  _buildFormFields(),
                  const SizedBox(height: 16),
                  _buildTermsCheckbox(),
                  const SizedBox(height: 20),
                  _buildRegisterButton(),
                  const SizedBox(height: 18),
                  _buildFooter(),
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
          onTap: () => Navigator.of(context).pop(),
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
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: AppColors.badgeBg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.directions_run_rounded,
                  size: 14, color: AppColors.primary),
              SizedBox(width: 4),
              Text(
                'OBSESS ID',
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.4,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildIntroCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFFCEFDB),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.emoji_events_outlined,
                    size: 13, color: Color(0xFFB9791C)),
                SizedBox(width: 4),
                Text(
                  'Dapatkan panduan lari personal',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFB9791C),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'Buat akun baru',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Mulai perjalanan sehatmu hari ini dan catat setiap langkah kemenangan.',
            style: TextStyle(
              fontSize: 12.5,
              height: 1.4,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Nama Lengkap',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        AppTextField(
          controller: _nameController,
          hintText: 'Nama Lengkap',
          prefixIcon: Icons.person_outline_rounded,
          textInputAction: TextInputAction.next,
          validator: Validators.fullName,
        ),
        const SizedBox(height: 16),
        const Text(
          'Email',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        AppTextField(
          controller: _emailController,
          hintText: 'Email aktif',
          prefixIcon: Icons.mail_outline_rounded,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          validator: Validators.email,
        ),
        const SizedBox(height: 16),
        const Text(
          'Password',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        AppTextField(
          controller: _passwordController,
          hintText: 'Minimal 8 karakter',
          prefixIcon: Icons.lock_outline_rounded,
          obscureText: _obscurePassword,
          textInputAction: TextInputAction.next,
          validator: Validators.password,
          onChanged: (_) => _formKey.currentState?.validate(),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 20,
              color: AppColors.textSecondary,
            ),
            onPressed: () {
              setState(() => _obscurePassword = !_obscurePassword);
            },
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Konfirmasi Password',
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        AppTextField(
          controller: _confirmPasswordController,
          hintText: 'Ulangi Password',
          prefixIcon: Icons.check_circle_outline_rounded,
          obscureText: _obscureConfirmPassword,
          textInputAction: TextInputAction.done,
          validator: (value) =>
              Validators.confirmPassword(_passwordController.text)(value),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword
                  ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              size: 20,
              color: AppColors.textSecondary,
            ),
            onPressed: () {
              setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: _agreeToTerms,
            activeColor: AppColors.checkboxActive,
            shape: const CircleBorder(),
            onChanged: (value) {
              setState(() => _agreeToTerms = value ?? false);
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: RichText(
              text: const TextSpan(
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  color: AppColors.textSecondary,
                ),
                children: [
                  TextSpan(text: 'Saya menyetujui '),
                  TextSpan(
                    text: 'Syarat & Ketentuan',
                    style: TextStyle(
                        color: AppColors.link, fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: ' serta '),
                  TextSpan(
                    text: 'Kebijakan Privasi',
                    style: TextStyle(
                        color: AppColors.link, fontWeight: FontWeight.w600),
                  ),
                  TextSpan(text: ' Obsess'),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _isSubmitting ? null : _handleRegister,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
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
                    'Daftar',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, size: 18),
                ],
              ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Sudah punya akun? ',
          style: TextStyle(fontSize: 13, color: AppColors.textSecondary),
        ),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: const Text(
            'Masuk',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.link,
            ),
          ),
        ),
      ],
    );
  }
}