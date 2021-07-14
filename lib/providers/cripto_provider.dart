import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:keyway/models/address.dart';
import 'package:keyway/models/long_text.dart';
import 'package:keyway/models/pin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as e;

import 'package:keyway/helpers/db_helper.dart';
import 'package:keyway/models/user.dart';
import 'package:keyway/models/username.dart';
import 'package:keyway/models/password.dart';
import 'package:zxcvbn/zxcvbn.dart';

class CriptoProvider with ChangeNotifier {
  bool _locked = true;
  SharedPreferences _pref;
  e.Encrypter _crypter;

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

  String doHash(String s) =>
      s.isNotEmpty ? sha256.convert(utf8.encode(s)).toString() : '';

  Future<void> unlock(String key) async {
    _crypter = e.Encrypter(e.AES(e.Key.fromUtf8(doHash(key).substring(0, 32))));
    e.Encrypted _mkCrypted = e.Encrypted.fromBase16(await _getMasterKey());
    String _mk = _crypter.decrypt(
      _mkCrypted,
      iv: e.IV.fromBase16(await _getMasterKeyIV()),
    );
    _crypter = e.Encrypter(e.AES(e.Key.fromUtf8(_mk)));
    _mk = 'MASTER*KEY*CLEARED';
    _locked = false;
    notifyListeners();
  }

  void lock() {
    _crypter = e.Encrypter(e.AES(e.Key.fromUtf8('PASS*CLEARED')));
    _locked = true;
    notifyListeners();
  }

  Future<bool> initialSetup(String key) async {
    //CREATES A ENCRYPTER WITH THE USERS KEY
    _crypter = e.Encrypter(e.AES(e.Key.fromUtf8(doHash(key).substring(0, 32))));

    //GENERATES A RANDOM STRING TO BE USED AS MASTER KEY
    List<int> _v = List<int>.generate(32, (i) => Random.secure().nextInt(256));
    String _mk = base64Url.encode(_v).substring(0, 32);

    //ENCRYPT AND SAVE MASTER KEY
    e.IV _iv = e.IV.fromSecureRandom(16);
    e.Encrypted _mkCrypted = _crypter.encrypt(_mk, iv: _iv);
    _pref = await SharedPreferences.getInstance();
    _pref.setString('masterKey', _mkCrypted.base16);
    _pref.setString('masterKeyIV', _iv.base16);
    _pref.setBool('isMasterKey', true);

    //SAVE MASTER KEY IN DATABASE
    DBHelper.insert(
      DBHelper.userTable,
      {'mk_enc': _mkCrypted.base16, 'mk_iv': _iv.base16},
    );

    _v.clear();
    _mk = 'MASTER*KEY*CLEARED';
    _mkCrypted = null;

    unlock(key);

    return true;
  }

  Future<void> setMasterKey() async {
    return SharedPreferences.getInstance().then((pref) {
      DBHelper.getData(DBHelper.userTable).then((data) {
        User _user = User.fromMap(data.first);
        pref.setString('masterKey', _user.encMK);
        pref.setString('masterKeyIV', _user.mkIV);
        pref.setBool('isMasterKey', true);
      });
    });
  }

  String doCrypt(String value, String iv) {
    if (value.isEmpty || value == null) return '';
    return _crypter.encrypt(value, iv: e.IV.fromBase16(iv)).base64;
  }

  String doDecrypt(String value, String iv) {
    if (value.isEmpty || value == null) return '';
    return _crypter.decrypt64(value, iv: e.IV.fromBase16(iv));
  }

  Password createPassword(String p) {
    if (p.isEmpty) return null;
    Password _p = Password(
      passwordIv: e.IV.fromSecureRandom(16).base16,
      passwordHash: doHash(p),
    );
    _p.passwordEnc = doCrypt(p, _p.passwordIv);
    _p.passwordStrength = Zxcvbn().evaluate(p).score.toString();
    return _p;
  }

  Username createUsername(String u) {
    if (u.isEmpty) return null;
    Username _u = Username(usernameIv: e.IV.fromSecureRandom(16).base16);
    _u.usernameEnc = doCrypt(u, _u.usernameIv);
    return _u;
  }

  Pin createPin(String p) {
    if (p.isEmpty) return null;
    Pin _p = Pin(pinIv: e.IV.fromSecureRandom(16).base16);
    _p.pinEnc = doCrypt(p, _p.pinIv);
    return _p;
  }

  LongText createLongText(String l) {
    if (l.isEmpty) return null;
    LongText _l = LongText(longTextIv: e.IV.fromSecureRandom(16).base16);
    _l.longTextEnc = doCrypt(l, _l.longTextIv);
    return _l;
  }

  Address createAddress(String a) {
    if (a.isEmpty) return null;
    Address _a = Address(addressIv: e.IV.fromSecureRandom(16).base16);
    _a.addressEnc = doCrypt(a, _a.addressIv);
    return _a;
  }

  void dispose() {
    super.dispose();
  }
}
