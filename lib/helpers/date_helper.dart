import 'package:intl/intl.dart';

class DateHelper {
  static DateFormat _ddMMyyyy = DateFormat('dd/MM/yyyy');
  static DateFormat _ddMMyyHm = DateFormat('dd/MM/yy k:mm');

  static String ddMMyyyy(dynamic date) {
    if (date is String)
      return _ddMMyyyy.format(DateTime.parse(date));
    else if (date is DateTime) return _ddMMyyyy.format(date);
    return 'Unknown format';
  }

  static String ddMMyyHm(dynamic date) {
    if (date is String)
      return _ddMMyyHm.format(DateTime.parse(date));
    else if (date is DateTime) return _ddMMyyHm.format(date);
    return 'Unknown format';
  }

  static bool expired(dynamic date, int dayLapse) {
    DateTime _date;
    if (date is String)
      _date = DateTime.parse(date);
    else if (date is DateTime) _date = date;
    DateTime _nowUTC = DateTime.now().toUtc();
    int _days = _nowUTC.difference(_date).inDays;
    return dayLapse <= _days;
  }
}
