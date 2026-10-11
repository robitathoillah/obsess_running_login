/// Format tanggal bahasa Indonesia tanpa package tambahan (intl).
class IdDate {
  IdDate._();

  static const List<String> hari = [
    'Senin',
    'Selasa',
    'Rabu',
    'Kamis',
    'Jumat',
    'Sabtu',
    'Minggu',
  ];

  static const List<String> bulan = [
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];

  static const List<String> bulanSingkat = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  /// Contoh: "Senin, 30 Januari 2026".
  static String full(DateTime d) {
    return '${hari[d.weekday - 1]}, ${d.day} ${bulan[d.month - 1]} ${d.year}';
  }

  /// Contoh: "07.30".
  static String time24(int hour, int minute) {
    final h = hour.toString().padLeft(2, '0');
    final m = minute.toString().padLeft(2, '0');
    return '$h.$m';
  }
}
