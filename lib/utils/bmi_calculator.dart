import 'dart:math';
import 'package:flutter/material.dart';

/// Hasil perhitungan BMI: nilai + kategori + warna badge-nya.
class BmiResult {
  const BmiResult({
    required this.value,
    required this.category,
    required this.color,
  });

  final double value;
  final String category;
  final Color color;
}

/// Kalkulator BMI standar (kg / m^2), dipakai di halaman Lengkapi Profil.
/// Kategori mengikuti rentang umum yang dipakai WHO (disederhanakan buat
/// keperluan UI, bukan untuk diagnosis medis).
class BmiCalculator {
  BmiCalculator._();

  static BmiResult calculate({
    required double heightCm,
    required double weightKg,
  }) {
    // Jaga-jaga: kalau tinggi badan 0/negatif, hindari pembagian aneh
    // (human error di input) -> anggap belum valid dan kembalikan 0.
    if (heightCm <= 0 || weightKg <= 0) {
      return const BmiResult(
        value: 0,
        category: '-',
        color: Colors.grey,
      );
    }

    final heightM = heightCm / 100;
    final bmi = weightKg / pow(heightM, 2);

    String category;
    Color color;
    if (bmi < 18.5) {
      category = 'Kurus';
      color = const Color(0xFFE0A32E);
    } else if (bmi < 25) {
      category = 'Kategori Normal';
      color = const Color(0xFF2E9E5B);
    } else if (bmi < 30) {
      category = 'Kelebihan Berat Badan';
      color = const Color(0xFFE0A32E);
    } else {
      category = 'Obesitas';
      color = const Color(0xFFD84343);
    }

    return BmiResult(
      value: double.parse(bmi.toStringAsFixed(1)),
      category: category,
      color: color,
    );
  }
}