import 'package:intl/intl.dart';

class DateHelper {
  static DateFormat _ddMMyyyy = DateFormat('dd/MM/yyyy');
  static DateFormat _ddMMyyHm = DateFormat('dd/MM/yy k:mm');

  static String ddMMyyyy(dynamic date) {
    if (date is String) {
      if (date.isEmpty) return 'No date';
      return _ddMMyyyy.format(DateTime.parse(date));
    } else if (date is DateTime) return _ddMMyyyy.format(date);
    return 'Unknown format';
  }

  static String ddMMyyHm(dynamic date) {
    if (date is String) {
      if (date.isEmpty) return 'No date';
      return _ddMMyyHm.format(DateTime.parse(date));
    } else if (date is DateTime) return _ddMMyyHm.format(date);
    return 'Unknown format';
  }

  static bool expired(dynamic date, int dayLapse) {
    if (date.isEmpty) return true;
    DateTime _date;
    if (date is String)
      _date = DateTime.parse(date);
    else if (date is DateTime) _date = date;
    DateTime _nowUTC = DateTime.now().toUtc();
    int _days = _nowUTC.difference(_date).inDays;
    return dayLapse <= _days;
  }

  static int compare(String date1, String date2) {
    DateTime _d1 = DateTime.parse(date1);
    DateTime _d2 = DateTime.parse(date2);
    if (_d1.isAfter(_d2))
      return 1;
    else if (_d1.isBefore(_d2)) return -1;
    return 0;
  }
}
