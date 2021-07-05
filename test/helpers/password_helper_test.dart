import 'package:flutter_test/flutter_test.dart';

import 'package:keyway/helpers/password_helper.dart';
import 'package:keyway/models/password.dart';
import 'package:keyway/models/word.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('Creación de lista de palabras', () async {
    List<Word> _wordList = <Word>[];
    await PasswordHelper.getWordList().then((list) {
      _wordList = list;
    });
    bool _emptyList = _wordList.isEmpty;
    expect(_emptyList, false);
  });

  test('Contraseña de +8 caracteres', () async {
    Password _randomPassword = Password(passwordEnc: '', passwordStrength: '');
    PasswordHelper.dicePassword().then((p) {
      bool _passwordPlus8 = _randomPassword.passwordEnc.length > 8;
      expect(_passwordPlus8, false);
    });
  });

  group('1000 tests de creación común', () {
    int i = 0;
    while (i < 1000) {
      i = i + 1;
      test("Test de 1000 contraseñas comunes", () {
        expectLater(
            PasswordHelper.dicePassword()
                .then((p) => int.parse(p.passwordStrength) > 2),
            completion(true));
      });
    }
  });

  group('1000 tests de cración segura', () {
    int i = 0;
    while (i < 1000) {
      i = i + 1;
      test("Test de 1000 contraseñas seguras", () {
        expectLater(
            PasswordHelper.secureDicePassword()
                .then((p) => int.parse(p.passwordStrength) > 2),
            completion(true));
      });
    }
  });

  // int j = 0;
  // while (j < 100) {
  //   j = j + 1;
  //   test("strenght password", () {
  //     expectLater(PasswordHelper.secureDicePassword(), completion(true));
  //   });
  // }

  // test('ramdom password is secure', () async {
  //   int _strenght = 0;
  //   await PasswordHelper.getWordList().then((list) {
  //     String _randomPassword = PasswordHelper.dicePasswordFromList(list);
  //     _strenght = PasswordHelper.strength(_randomPassword).score;
  //   });
  //   expect(_strenght > 2, true);
  // });

  // group('testing 100 random generated passwords', () {
  //   // Future<List<int>> getList() {

  //   // }
  //   // List<bool> _values = <bool>[true, true, true, false];
  //   // for (int i = 0; i == 99; i++) {
  //   //   PasswordHelper.getWordList().then((list) {
  //   //     String _randomPassword = PasswordHelper.dicePasswordFromList(list);
  //   //     _values.add(PasswordHelper.strength(_randomPassword).score > 2);
  //   //   });
  //   // }

  // });
}
