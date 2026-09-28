import 'package:flutter/material.dart';

/// Palet warna diambil dari sampling desain Figma "PROJECT KEL 1 S3"
/// (halaman Login). Sesuaikan lagi nilainya kalau kamu punya akses
/// ke tab "Inspect" di Figma untuk nilai hex yang lebih presisi.
class AppColors {
  AppColors._();

  // Warna utama (icon, tombol Masuk)
  static const Color primary = Color(0xFF0B5A9E);
  static const Color primaryDark = Color(0xFF08476F);

  // Background halaman (lavender sangat muda)
  static const Color background = Color(0xFFF7F8FD);

  // Background input field & tombol sosial
  static const Color fieldFill = Color(0xFFEEF2FF);

  // Background badge "OBSESS RUNNING"
  static const Color badgeBg = Color(0xFFE9EFFE);

  // Warna teks
  static const Color textPrimary = Color(0xFF1A1F36);
  static const Color textSecondary = Color(0xFF767C94);
  static const Color textHint = Color(0xFF9AA1B7);

  // Warna link ("Lupa Password?", "Daftar")
  static const Color link = Color(0xFF2F5FDB);

  static const Color checkboxActive = Color(0xFF2F5FDB);
  static const Color divider = Color(0xFFE3E6F0);
}
