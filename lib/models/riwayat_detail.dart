/// Data lengkap satu sesi olahraga. Dipakai oleh halaman Detail Riwayat dan
/// Unduh Riwayat. Nilai-nilainya disimpan sebagai teks yang sudah diformat
/// supaya tampilannya sama persis dengan desain.
///
/// TODO: ganti dengan data asli dari backend / hasil tracking GPS.
class RiwayatDetail {
  const RiwayatDetail({
    required this.isRun,
    required this.title,
    required this.sessionLabel,
    required this.dateShort,
    required this.dateLong,
    required this.targetReached,
    required this.distance,
    required this.distanceNote,
    required this.calories,
    required this.caloriesNote,
    required this.duration,
    required this.durationNote,
    required this.steps,
    required this.stepsNote,
    required this.avgSpeed,
    required this.avgPace,
    required this.bestPace,
    required this.bestPaceAt,
    required this.zone,
    required this.speedTimes,
    required this.speedValues,
    required this.axisMinutes,
    required this.axisKm,
    required this.routeName,
  });

  /// true = berlari, false = berjalan (menentukan ikon).
  final bool isRun;
  final String title;
  final String sessionLabel;

  /// Contoh: "19 Sep 2026 • 17:30 WIB".
  final String dateShort;

  /// Contoh: "19 September 2026, 17:30 WIB".
  final String dateLong;
  final bool targetReached;

  /// Angka saja tanpa satuan, contoh: "4,8".
  final String distance;
  final String distanceNote;
  final String calories;
  final String caloriesNote;
  final String duration;
  final String durationNote;
  final String steps;
  final String stepsNote;

  /// Kecepatan rata-rata (km/jam), contoh: "8.45".
  final String avgSpeed;
  final String avgPace;
  final String bestPace;
  final String bestPaceAt;
  final String zone;

  /// Posisi tiap titik grafik di sumbu X (0.0 sampai 1.0).
  final List<double> speedTimes;

  /// Kecepatan (km/jam) untuk tiap titik di atas.
  final List<double> speedValues;

  /// Batas sumbu X dalam menit (kelipatan 10) dan dalam km (bilangan bulat).
  final int axisMinutes;
  final int axisKm;
  final String routeName;

  /// Teks ringkasan untuk disalin / dibagikan.
  String get summaryText {
    return '$title • $dateShort\n'
        'Jarak $distance km • Waktu $duration • Kalori $calories kkal • '
        'Langkah $steps\n'
        'Pace rata-rata $avgPace /km';
  }
}
