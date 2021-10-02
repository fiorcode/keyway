import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:keyway/models/word.dart';
import 'package:zxcvbn/zxcvbn.dart';

import '../models/password.dart';

class PasswordHelper {
  static List<String> _conectors = [
    '@',
    '#',
    '%',
    '&',
    '-',
    '+',
    '(',
    ')',
    '*',
    '"',
    ':',
    ';',
    '!',
    '?',
    ',',
    '_',
    '.',
    '.',
    '\$',
    '^',
    '{',
    '}',
    '|',
    '<',
    '>',
  ];
  static bool minLong(String s) => s.length > 5;
  static bool maxLong(String s) => s.length < 33;
  static bool hasLow(String s) => s.contains(RegExp(r'[a-z]'));
  static bool hasUpp(String s) => s.contains(RegExp(r'[A-Z]'));
  static bool hasNum(String s) => s.contains(RegExp(r'[0-9]'));
  static bool hasSpec(String s) {
    return s.contains(RegExp(r'[@#%&+()*":;!?,_.$^{}|<>]'));
  }

  static bool valid(String s) {
    if (s.isEmpty) return true;
    return validRegExp.hasMatch(s.substring(s.length - 1));
  }

  static RegExp get validRegExp =>
      RegExp(r'[a-zA-Z0-9@#%&+()*":;!?,_.$^{}|<>]');

  static Future<List<Word>> getWordList() async {
    List<Word> _wordList = <Word>[];
    final _list =
        jsonDecode(await rootBundle.loadString('assets/word_list_en.json'));
    _list.forEach((w) {
      _wordList.add(Word.fromJson(w));
    });
    return _wordList;
  }

  static ZxcvbnResult evaluate(String s, {Password password}) {
    if (s.isEmpty) return ZxcvbnResult();
    var _evaluation = Zxcvbn().evaluate(s);
    if (password != null)
      password.passwordStrength = _evaluation.score.toString();
    return ZxcvbnResult(
      password: _evaluation.password,
      score: _evaluation.score.toInt(),
      suggestions: _evaluation.feedback.suggestions,
      warning: _evaluation.feedback.warning,
    );
  }

  static Future<ZxcvbnResult> dicePassword() async {
    List<Word> _wordList = await getWordList();
    Random _rdm = Random.secure();
    String _pass = _wordList.elementAt(_rdm.nextInt(_wordList.length)).value +
        _conectors.elementAt(_rdm.nextInt(_conectors.length)) +
        _wordList.elementAt(_rdm.nextInt(_wordList.length)).value;
    return evaluate(_pass);
  }

  static Future<Password> secureDicePassword() async {
    List<Word> _wordList = await getWordList();
    List<Word> _lowFreqList =
        _wordList.where((w) => int.parse(w.freq) < 1000).toList();
    Random _rdm = Random.secure();
    String _word1 =
        _lowFreqList.elementAt(_rdm.nextInt(_lowFreqList.length)).value;
    String _conect = _conectors.elementAt(_rdm.nextInt(_conectors.length));
    String _word2 =
        _lowFreqList.elementAt(_rdm.nextInt(_lowFreqList.length)).value;
    String _conect2 = _conectors.elementAt(_rdm.nextInt(_conectors.length));
    String _pass = _word1 + _conect + _word2 + _conect2;
    return Password(
        passwordDec: _pass, passwordStrength: evaluate(_pass).score.toString());
  }
}

class ZxcvbnResult {
  String password;
  int score;
  List<String> suggestions;
  String warning;

  ZxcvbnResult({
    this.password = '',
    this.score = -1,
    this.suggestions,
    this.warning = '',
  });
}

  // static Future<bool> secureDicePassword() async {
  //   List<Word> _wordList = await getWordList();
  //   Random _rdm = Random.secure();
  //   String _word1 = _wordList.elementAt(_rdm.nextInt(_wordList.length)).value;
  //   String _conect = _conectors.elementAt(_rdm.nextInt(_conectors.length));
  //   String _word2 = _wordList.elementAt(_rdm.nextInt(_wordList.length)).value;
  //   return strength(_word1 + _conect + _word2).score > 2;
  // }

  // static Future<bool> secureDicePassword() async {
  //   List<Word> _wordList = await getWordList();
  //   List<Word> _lowFreqList =
  //       _wordList.where((w) => int.parse(w.freq) < 40).toList();
  //   Random _rdm = Random.secure();
  //   String _word1 =
  //       _lowFreqList.elementAt(_rdm.nextInt(_lowFreqList.length)).value;
  //   int _rdmIndex = _rdm.nextInt(_word1.length);
  //   _word1 = _rdmIndex == 0
  //       ? toBeginningOfSentenceCase(_word1)
  //       : _word1.substring(0, _rdmIndex) +
  //           toBeginningOfSentenceCase(_word1.substring(_rdmIndex));
  //   String _conect = _conectors.elementAt(_rdm.nextInt(_conectors.length));
  //   String _word2 =
  //       _lowFreqList.elementAt(_rdm.nextInt(_lowFreqList.length)).value;
  //   _rdmIndex = _rdm.nextInt(_word2.length);
  //   _word2 = _rdmIndex == 0
  //       ? toBeginningOfSentenceCase(_word2)
  //       : _word2.substring(0, _rdmIndex) +
  //           toBeginningOfSentenceCase(_word2.substring(_rdmIndex));
  //   return strength(_word1 + _conect + _word2).score > 2;
  // }

  // static List<String> suggestions(String s) {
  //   var _sugs = [];
  //   if (s.isEmpty) return <String>[];
  //   _sugs = Zxcvbn().evaluate(s).feedback.suggestions;
  //   return _sugs;
  // }
