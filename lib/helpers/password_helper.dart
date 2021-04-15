import 'package:zxcvbn/zxcvbn.dart';

class PasswordHelper {
  static bool minLong(String s) => s.length > 5;
  static bool maxLong(String s) => s.length < 33;
  static bool hasLow(String s) => s.contains(RegExp(r'[a-z]'));
  static bool hasUpp(String s) => s.contains(RegExp(r'[A-Z]'));
  static bool hasNum(String s) => s.contains(RegExp(r'[0-9]'));
  static bool hasSpec(String s) =>
      s.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  static bool isStrong(String s) =>
      minLong(s) &&
      maxLong(s) &&
      hasLow(s) &&
      hasUpp(s) &&
      hasNum(s) &&
      hasSpec(s);

  // static String level(String s) {
  //   if (s.length < 11) return 'very weak';
  //   int _value = 50;
  //   if (hasLow(s)) _value = _value + 10;
  //   if (hasUpp(s)) _value = _value + 10;
  //   if (hasNum(s)) _value = _value + 10;
  //   if (hasSpec(s)) _value = _value + 10;
  //   if (s.length > 19) _value = _value + 10;
  //   switch (_value) {
  //     case 55:
  //       return 'weak';
  //       break;
  //     case 85:
  //       return 'strong';
  //       break;
  //     case 100:
  //       return 'very strong';
  //       break;
  //     default:
  //   }
  // }

  static int level(String s) {
    if (s.isEmpty) return -1;
    return Zxcvbn().evaluate(s).score.toInt();
  }
}
