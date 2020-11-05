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
}
