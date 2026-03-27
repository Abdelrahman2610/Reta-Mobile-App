import 'package:intl/intl.dart';

extension DateTimeFormat on DateTime {
  String get toArabicTransactionFormat {
    final formatter = DateFormat('d MMMM yyyy', 'ar');
    final date = formatter.format(this);

    final hour = this.hour % 12 == 0 ? 12 : this.hour % 12;
    final minute = this.minute.toString().padLeft(2, '0');
    final period = this.hour < 12 ? 'صباحاً' : 'مساءً';

    return '$date - $hour:$minute $period';
  }
}

extension ArabicDateFormat on String? {
  String toArabicDate() {
    if (this == null || this!.isEmpty) return '-';

    // يدعم format: dd/MM/yyyy أو yyyy-MM-dd
    try {
      final parts = this!.contains('/') ? this!.split('/') : this!.split('-');

      late int day, month, year;

      if (this!.contains('/')) {
        // dd/MM/yyyy
        day = int.parse(parts[0]);
        month = int.parse(parts[1]);
        year = int.parse(parts[2]);
      } else {
        // yyyy-MM-dd
        year = int.parse(parts[0]);
        month = int.parse(parts[1]);
        day = int.parse(parts[2]);
      }

      const months = [
        '',
        'يناير',
        'فبراير',
        'مارس',
        'إبريل',
        'مايو',
        'يونيو',
        'يوليو',
        'أغسطس',
        'سبتمبر',
        'أكتوبر',
        'نوفمبر',
        'ديسمبر',
      ];

      return '$day ${months[month]} $year';
    } catch (_) {
      return this ?? '-';
    }
  }
}
