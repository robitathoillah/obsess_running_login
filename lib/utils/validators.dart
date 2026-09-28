/// Kumpulan fungsi validasi input, dipakai bareng oleh halaman Login,
/// Registrasi, dan Lengkapi Profil.

class Validators {
  Validators._();

  static final RegExp _emailRegex =
      RegExp(r'^[\w\.\-]+@[\w\-]+\.[a-zA-Z]{2,}$');

  // =========================
  // VALIDASI EMAIL
  // =========================
  static String? email(String? value) {
    final trimmed = value?.trim() ?? '';

    if (trimmed.isEmpty) {
      return 'Alamat email wajib diisi';
    }

    if (!_emailRegex.hasMatch(trimmed)) {
      return 'Format email tidak valid';
    }

    return null;
  }

  // =========================
  // VALIDASI PASSWORD
  // =========================
  static String? password(String? value) {
    final v = value ?? '';

    if (v.isEmpty) {
      return 'Kata sandi wajib diisi';
    }

    if (v.length < 8) {
      return 'Kata sandi minimal 8 karakter';
    }

    return null;
  }

  // =========================
  // VALIDASI NAMA LENGKAP
  // =========================
  static String? fullName(String? value) {
    final trimmed = value?.trim() ?? '';

    if (trimmed.isEmpty) {
      return 'Nama lengkap wajib diisi';
    }

    if (trimmed.length < 3) {
      return 'Nama lengkap minimal 3 karakter';
    }

    return null;
  }

  // =========================
  // VALIDASI KONFIRMASI PASSWORD
  // =========================
  static String? Function(String?) confirmPassword(String original) {
    return (String? value) {
      final v = value ?? '';

      if (v.isEmpty) {
        return 'Konfirmasi kata sandi wajib diisi';
      }

      if (v != original) {
        return 'Konfirmasi kata sandi tidak sama';
      }

      return null;
    };
  }

  // =========================
  // VALIDASI ANGKA DALAM RANGE
  // =========================
  static String? Function(String?) numberInRange({
    required String label,
    required double min,
    required double max,
  }) {
    return (String? value) {
      final v = value?.trim() ?? '';

      if (v.isEmpty) {
        return '$label wajib diisi';
      }

      final number = double.tryParse(v);

      if (number == null) {
        return '$label harus berupa angka';
      }

      if (number < min || number > max) {
        return '$label harus antara $min dan $max';
      }

      return null;
    };
  }
}