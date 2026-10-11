import 'package:flutter/material.dart';

/// Palet warna untuk desain terbaru (Dashboard, Jadwal, Tugas Baru, Progres).
/// Dipisah dari AppColors supaya halaman Login/Registrasi/Profil yang sudah
/// jadi tidak ikut berubah.
class FitColors {
  FitColors._();

  static const Color bg = Color(0xFFF8FAFC);

  static const Color slate900 = Color(0xFF0F172A);
  static const Color slate800 = Color(0xFF1E293B);
  static const Color slate700 = Color(0xFF334155);
  static const Color slate600 = Color(0xFF475569);
  static const Color slate500 = Color(0xFF64748B);
  static const Color slate400 = Color(0xFF94A3B8);
  static const Color slate300 = Color(0xFFCBD5E1);
  static const Color slate200 = Color(0xFFE2E8F0);
  static const Color slate100 = Color(0xFFF1F5F9);
  static const Color slate50 = Color(0xFFF8FAFC);

  static const Color blue50 = Color(0xFFEFF6FF);
  static const Color blue100 = Color(0xFFDBEAFE);
  static const Color blue500 = Color(0xFF3B82F6);
  static const Color blue600 = Color(0xFF2563EB);
  static const Color blue700 = Color(0xFF1D4ED8);
  static const Color electric = Color(0xFF0066FF);

  static const Color emerald50 = Color(0xFFECFDF5);
  static const Color emerald100 = Color(0xFFD1FAE5);
  static const Color emerald200 = Color(0xFFA7F3D0);
  static const Color emerald500 = Color(0xFF10B981);
  static const Color emerald600 = Color(0xFF059669);
  static const Color emerald700 = Color(0xFF047857);

  static const Color rose50 = Color(0xFFFFF1F2);
  static const Color rose100 = Color(0xFFFFE4E6);
  static const Color rose200 = Color(0xFFFECDD3);
  static const Color rose300 = Color(0xFFFDA4AF);
  static const Color rose400 = Color(0xFFFB7185);
  static const Color rose500 = Color(0xFFF43F5E);
  static const Color rose600 = Color(0xFFE11D48);

  static const Color coral = Color(0xFFFF5733);
  static const Color orange100 = Color(0xFFFFEDD5);
  static const Color amber300 = Color(0xFFFCD34D);
  static const Color amber500 = Color(0xFFF59E0B);
  static const Color amber700 = Color(0xFFB45309);
  static const Color cyan200 = Color(0xFFA5F3FC);
  static const Color cyan300 = Color(0xFF67E8F9);

  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0D0F172A),
      blurRadius: 20,
      spreadRadius: -2,
      offset: Offset(0, 4),
    ),
  ];

  static const List<BoxShadow> softShadow = [
    BoxShadow(color: Color(0x0D0F172A), blurRadius: 4, offset: Offset(0, 1)),
  ];

  static const List<BoxShadow> glowBlue = [
    BoxShadow(
      color: Color(0x590066FF),
      blurRadius: 28,
      spreadRadius: -6,
      offset: Offset(0, 12),
    ),
  ];

  static const List<BoxShadow> navShadow = [
    BoxShadow(color: Color(0x1F0F172A), blurRadius: 36, offset: Offset(0, 12)),
  ];
}

/// Singkatan untuk bikin TextStyle supaya kode halaman tidak terlalu panjang.
TextStyle fitText(
  double size,
  FontWeight weight,
  Color color, {
  double? height,
  double? letterSpacing,
}) {
  return TextStyle(
    fontSize: size,
    fontWeight: weight,
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );
}
