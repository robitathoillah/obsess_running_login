import 'package:flutter/material.dart';

/// Jenis olahraga + konstanta estimasi (dipakai untuk simulasi sementara
/// sebelum GPS sungguhan dipasang).
enum JenisOlahraga {
  berjalan('Berjalan', Icons.directions_walk_rounded, 4.5, 4.7, 1350, 2.0, 108),
  berlari('Berlari', Icons.directions_run_rounded, 10.75, 10.7, 1220, 5.0, 152);

  const JenisOlahraga(
    this.label,
    this.icon,
    this.kmPerJam,
    this.kkalPerMenit,
    this.langkahPerKm,
    this.targetKm,
    this.bpm,
  );

  final String label;
  final IconData icon;
  final double kmPerJam;
  final double kkalPerMenit;
  final int langkahPerKm;
  final double targetKm;
  final int bpm;

  int get estKkal30 => (kkalPerMenit * 30).round();
  int get targetPaceDetik => (3600 / kmPerJam).round();
  String get targetPace => formatPaceTanda(targetPaceDetik);
}

/// Hasil akhir satu sesi olahraga.
class HasilSesi {
  const HasilSesi({
    required this.jenis,
    required this.durasi,
    required this.jarakKm,
    required this.langkah,
    required this.kalori,
    required this.tanggal,
  });

  final JenisOlahraga jenis;
  final Duration durasi;
  final double jarakKm;
  final int langkah;
  final int kalori;
  final DateTime tanggal;

  int get paceDetik =>
      jarakKm < 0.01 ? 0 : (durasi.inSeconds / jarakKm).round();

  /// Contoh: 11'06"
  String get paceTanda => paceDetik == 0 ? '-' : formatPaceTanda(paceDetik);

  /// Contoh: 8,45
  String get paceKoma => paceDetik == 0
      ? '0,00'
      : '${paceDetik ~/ 60},${(paceDetik % 60).toString().padLeft(2, '0')}';

  String get jarakText => formatKm(jarakKm);
  String get langkahText => formatRibuan(langkah);
  String get durasiJam => formatJam(durasi);
  String get tanggalPanjang =>
      '${tanggal.day} ${_bulan[tanggal.month - 1]} ${tanggal.year}';

  /// Angka + satuan durasi untuk kartu ringkasan.
  String get durasiAngka => durasi.inSeconds < 60
      ? '${durasi.inSeconds}'
      : '${(durasi.inSeconds / 60).round()}';
  String get durasiSatuan => durasi.inSeconds < 60 ? 'detik' : 'menit';

  int get bpm => jenis.bpm;
}

const List<String> _bulan = [
  'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli',
  'Agustus', 'September', 'Oktober', 'November', 'Desember',
];

String formatPaceTanda(int detikPerKm) =>
    "${detikPerKm ~/ 60}'${(detikPerKm % 60).toString().padLeft(2, '0')}\"";

String formatKm(double km) => km.toStringAsFixed(1).replaceAll('.', ',');

String formatRibuan(int n) {
  final s = n.toString();
  final b = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    if (i > 0 && (s.length - i) % 3 == 0) b.write('.');
    b.write(s[i]);
  }
  return b.toString();
}

String formatJam(Duration d) {
  String two(int v) => v.toString().padLeft(2, '0');
  return '${two(d.inHours)}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}';
}