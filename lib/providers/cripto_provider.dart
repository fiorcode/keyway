import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as e;

import 'package:keyway/helpers/db_helper.dart';
import 'package:keyway/models/user.dart';

class CriptoProvider with ChangeNotifier {
  bool _locked = true;
  SharedPreferences _pref;
  String _key;
  String _mk;
  e.Encrypter _crypter;
  e.Encrypted _mkCrypted;

  CriptoProvider() {
    lock();
  }

  bool get locked => _locked;

  Future<String> _getMasterKey() async =>
      (await SharedPreferences.getInstance()).getString('masterKey');

  Future<String> _getMasterKeyIV() async =>
      (await SharedPreferences.getInstance()).getString('masterKeyIV');

  Future<bool> isMasterKey() async =>
      (await SharedPreferences.getInstance()).getBool('isMasterKey') ?? false;

  Future<void> unlock(String password) async {
    //_setKey(password);
    String _hashedKey =
        sha256.convert(utf8.encode(password)).toString().substring(0, 32);
    _crypter = e.Encrypter(e.AES(e.Key.fromUtf8(_hashedKey)));
    _mkCrypted = e.Encrypted.fromBase64(await _getMasterKey());
    _mk = _crypter.decrypt(
      _mkCrypted,
      iv: e.IV.fromBase64(await _getMasterKeyIV()),
    );
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

  Future<bool> initialSetup(String password) async {
    _pref = await SharedPreferences.getInstance();
    // _setKey(password);
    String _hashedKey =
        sha256.convert(utf8.encode(password)).toString().substring(0, 32);
    _crypter = e.Encrypter(e.AES(e.Key.fromUtf8(_hashedKey)));

    //CREATION OF MASTER KEY
    // Random _random = Random.secure();
    // List<int> _v = List<int>.generate(32, (i) => _random.nextInt(256));
    // _mk = base64Url.encode(_v).substring(0, 32);

    //ENCRYPT AND SAVE MASTER KEY
    e.IV _iv = e.IV.fromSecureRandom(Random.secure().nextInt(16));
    _mkCrypted = _crypter.encrypt(_hashedKey, iv: _iv);
    _pref.setString('masterKey', _mkCrypted.base64);
    _pref.setString('masterKeyIV', _iv.base64);
    _pref.setBool('isMasterKey', true);

    //SAVE MASTER KEY IN DATABASE
    DBHelper.insert(
      'user_data',
      {
        'enc_mk': _mkCrypted.base64,
        'mk_iv': _iv.base64,
      },
    );

    //CLEAN
    // _random = Random.secure();
    // _v = List<int>.generate(32, (i) => _random.nextInt(256));

    unlock(password);

    return true;
  }

  Future<void> setMasterKey() async {
    _pref = await SharedPreferences.getInstance();
    final _userData = await DBHelper.getData('user_data');
    User _user = _userData
        .map(
          (item) => User(
            name: item['name'],
            surname: item['surname'],
            encMK: item['enc_mk'],
            mkIV: item['mk_iv'],
          ),
        )
        .toList()
        .first;
    _pref.setString('masterKey', _user.encMK);
    _pref.setString('masterKeyIV', _user.mkIV);
    _pref.setBool('isMasterKey', true);
  }

  String doCrypt(String value, String iv) {
    if (value.isEmpty || value == null) return '';
    var _iv = e.IV.fromBase16(iv);
    var _iv2 = e.IV.fromLength(16);
    return _crypter.encrypt(value, iv: _iv).base64;
  }

  String doDecrypt(String value, String iv) {
    if (value.isEmpty || value == null) return '';
    return _crypter.decrypt64(value, iv: e.IV.fromBase16(iv));
  }

  // void _setKey(String password) {
  //   _key = password;
  //   int _i = 0;
  //   while (_key.length < 32) {
  //     _key = _key + _key[_i];
  //     _i++;
  //   }
  // }

  void dispose() {
    super.dispose();
  }
}
