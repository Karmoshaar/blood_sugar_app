import 'package:intl/intl.dart';

class DateFormatter {
  static String format(DateTime date) {
    return DateFormat('MMM d · hh:mm a').format(date);
  }
}
