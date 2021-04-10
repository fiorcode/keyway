import 'package:intl/intl.dart';

class DateHelper {
  static DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  static String shortDate(dynamic date) {
    if (date is String)
      return dateFormat.format(DateTime.parse(date));
    else if (date is DateTime) return dateFormat.format(date);
    return 'Unknown format';
  }
}
