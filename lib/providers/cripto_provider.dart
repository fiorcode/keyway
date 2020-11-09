import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:encrypt/encrypt.dart' as e;

import 'package:keyway/helpers/db_helper.dart';
import 'package:keyway/models/user.dart';

class CriptoProvider with ChangeNotifier {
  static SharedPreferences _pref;

  bool _locked;
  String _key;
  String _mk;
  e.Encrypter _crypter;
  e.Encrypted _mkCrypted;

  CriptoProvider() {
    unlock('Qwe123!');
  }

  bool get locked => _locked;

  String _getMasterKey() => _pref.getString('masterKey');

  Future<bool> isMasterKey() async {
    _pref = await SharedPreferences.getInstance();
    return _pref.getBool('isMasterKey') ?? false;
  }

  _setKey(String password) {
    _key = password;
    int _i = 0;
    while (_key.length < 32) {
      _key = _key + _key[_i];
      _i++;
    }
  }

  void unlock(String password) {
    _setKey(password);
    _crypter = e.Encrypter(e.AES(e.Key.fromUtf8(_key)));
    _mkCrypted = e.Encrypted.fromBase64(_getMasterKey());
    _mk = _crypter.decrypt(_mkCrypted, iv: e.IV.fromLength(16));
    _crypter = e.Encrypter(e.AES(e.Key.fromUtf8(_mk)));
    _key = 'PASS*CLEARED';
    _mk = 'MASTER*KEY*CLEARED';
    _locked = false;
    notifyListeners();
  }

  void lock() {
    _key = 'PASS*CLEARED';
    _crypter = e.Encrypter(e.AES(e.Key.fromUtf8(_key)));
    _mk = 'MASTER*KEY*CLEARED';
    _locked = true;
    notifyListeners();
  }

  bool initialSetup(String password) {
    _setKey(password);
    _crypter = e.Encrypter(e.AES(e.Key.fromUtf8(_key)));

    //CREATION OF MASTER KEY
    Random _random = Random.secure();
    List<int> _v = List<int>.generate(32, (i) => _random.nextInt(256));
    _mk = base64Url.encode(_v).substring(0, 32);

    //ENCRYPT AND SAVE MASTER KEY
    _mkCrypted = _crypter.encrypt(_mk, iv: e.IV.fromLength(16));
    _pref.setString('masterKey', _mkCrypted.base64);
    _pref.setBool('isMasterKey', true);

    //SAVE MASTER KEY IN DATABASE
    DBHelper.insert('user_data', {'enc_mk': _mkCrypted.base64});

    //CLEAN
    _random = Random.secure();
    _v = List<int>.generate(32, (i) => _random.nextInt(256));

    unlock(password);

    return true;
  }

  setMasterKey() async {
    final _userData = await DBHelper.getData('user_data');
    String _encMK = _userData
        .map(
          (item) => User(
            name: item['name'],
            surname: item['surname'],
            encMK: item['enc_mk'],
          ),
        )
        .toList()
        .first
        .encMK;
    _pref.setString('masterKey', _encMK);
    _pref.setBool('isMasterKey', true);
  }

  String doCrypt(String value) {
    return _crypter.encrypt(value, iv: e.IV.fromLength(16)).base64;
  }

  String doDecrypt(String value) {
    return _crypter.decrypt64(value, iv: e.IV.fromLength(16));
  }

  void dispose() {
    super.dispose();
  }
}
