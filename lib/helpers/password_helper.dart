import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:keyway/models/word.dart';
import 'package:zxcvbn/zxcvbn.dart';

import '../models/password.dart';

class PasswordHelper {
  static List<String> _conectors = [
    '!',
    '#',
    '%',
    '^',
    '&',
    '*',
    '.',
    '?',
    '<',
    '>'
  ];
  static bool minLong(String s) => s.length > 5;
  static bool maxLong(String s) => s.length < 33;
  static bool hasLow(String s) => s.contains(RegExp(r'[a-z]'));
  static bool hasUpp(String s) => s.contains(RegExp(r'[A-Z]'));
  static bool hasNum(String s) => s.contains(RegExp(r'[0-9]'));
  static bool hasSpec(String s) {
    return s.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  static bool isStrong(String s) {
    return minLong(s) &&
        maxLong(s) &&
        hasLow(s) &&
        hasUpp(s) &&
        hasNum(s) &&
        hasSpec(s);
  }

  static ZxcvbnResult strength(String s, {Password password}) {
    if (s.isEmpty) return null;
    var _evaluation = Zxcvbn().evaluate(s);
    if (password != null) password.strength = _evaluation.score.toString();
    return ZxcvbnResult(
      score: _evaluation.score.toInt(),
      suggestions: _evaluation.feedback.suggestions,
      warning: _evaluation.feedback.warning,
    );
  }

  static List<String> suggestions(String s) {
    var _sugs = [];
    if (s.isEmpty) return <String>[];
    _sugs = Zxcvbn().evaluate(s).feedback.suggestions;
    return _sugs;
  }

  static Future<String> dicePassword() async {
    List<Word> _wordList = <Word>[];
    final _list =
        jsonDecode(await rootBundle.loadString('assets/word_list_en.json'));
    _list.forEach((w) {
      _wordList.add(Word.fromJson(w));
    });
    return _wordList
            .elementAt(Random.secure().nextInt(_wordList.length))
            .value +
        _conectors.elementAt(Random.secure().nextInt(_conectors.length)) +
        _wordList.elementAt(Random.secure().nextInt(_wordList.length)).value;
  }
}

class ZxcvbnResult {
  int score;
  List<String> suggestions;
  String warning;

  ZxcvbnResult({this.score, this.suggestions, this.warning});
}
