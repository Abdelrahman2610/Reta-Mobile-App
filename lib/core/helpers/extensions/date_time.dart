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
