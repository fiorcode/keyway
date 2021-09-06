import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:keyway/models/address.dart';
import 'package:keyway/models/note.dart';
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

  void lock() {
    _crypter = e.Encrypter(e.AES(e.Key.fromUtf8('PASS*CLEARED')));
    _locked = true;
    notifyListeners();
  }

  Future<void> unlock(String key) async {
    try {
      _crypter = e.Encrypter(
        e.AES(
          e.Key.fromBase16(doHash(key).substring(0, 32)),
          mode: e.AESMode.cbc,
        ),
      );
      String _mk = await _getMasterKey();
      String _mkIv = await _getMasterKeyIV();
      e.Encrypted _mkCrypted = e.Encrypted.fromBase64(_mk);
      e.IV _iv = e.IV.fromBase64(_mkIv);
      _mk = _crypter.decrypt(_mkCrypted, iv: _iv);
      _crypter = e.Encrypter(e.AES(e.Key.fromUtf8(_mk), mode: e.AESMode.cbc));
      _mk = 'MASTER*KEY*CLEARED';
      _locked = false;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<bool> initialSetup(String key) async {
    //CREATES A ENCRYPTER WITH THE USERS KEY
    _crypter = e.Encrypter(
      e.AES(
        e.Key.fromBase16(doHash(key).substring(0, 32)),
        mode: e.AESMode.cbc,
      ),
    );

    //GENERATES A RANDOM STRING TO BE USED AS MASTER KEY
    List<int> _v = List<int>.generate(32, (i) => Random.secure().nextInt(256));
    String _mk = base64Url.encode(_v).substring(0, 32);

    //ENCRYPT AND SAVE MASTER KEY
    e.IV _iv = e.IV.fromSecureRandom(16);
    e.Encrypted _mkCrypted = _crypter.encrypt(_mk, iv: _iv);
    _pref = await SharedPreferences.getInstance();
    _pref.setString('masterKey', _mkCrypted.base64);
    _pref.setString('masterKeyIV', _iv.base64);
    _pref.setBool('isMasterKey', true);

    //SAVE MASTER KEY IN DATABASE
    await DBHelper.insert(
      DBHelper.userTable,
      {'mk_enc': _mkCrypted.base64, 'mk_iv': _iv.base64},
    );

    _v.clear();
    _mk = 'MASTER*KEY*CLEARED';
    _mkCrypted = null;

    await unlock(key);

    return true;
  }

  Future<void> setMasterKey() async {
    return SharedPreferences.getInstance().then((pref) {
      DBHelper.read(DBHelper.userTable).then((data) {
        User _user = User.fromMap(data.first);
        pref.setString('masterKey', _user.encMk);
        pref.setString('masterKeyIV', _user.mkIv);
        pref.setBool('isMasterKey', true);
      });
    });
  }

  String doCrypt(String value, String iv) {
    if (value.isEmpty || value == null) return '';
    return _crypter.encrypt(value, iv: e.IV.fromBase64(iv)).base64;
  }

  String doDecrypt(String value, String iv) {
    if (value.isEmpty || value == null) return '';
    return _crypter.decrypt64(value, iv: e.IV.fromBase64(iv));
  }

  String decryptPassword(Password p) {
    if (p == null) return '';
    if (p.passwordIv.isEmpty) return '';
    if (p.passwordEnc.isEmpty) return '';
    return _crypter.decrypt64(p.passwordEnc, iv: e.IV.fromBase64(p.passwordIv));
  }

  String decryptUsername(Username u) {
    if (u == null) return '';
    if (u.usernameIv.isEmpty) return '';
    if (u.usernameEnc.isEmpty) return '';
    return _crypter.decrypt64(u.usernameEnc, iv: e.IV.fromBase64(u.usernameIv));
  }

  String decryptPin(Pin p) {
    if (p == null) return '';
    if (p.pinIv.isEmpty) return '';
    if (p.pinEnc.isEmpty) return '';
    return _crypter.decrypt64(p.pinEnc, iv: e.IV.fromBase64(p.pinIv));
  }

  String decryptNote(Note n) {
    if (n == null) return '';
    if (n.noteIv.isEmpty) return '';
    if (n.noteEnc.isEmpty) return '';
    return _crypter.decrypt64(n.noteEnc, iv: e.IV.fromBase64(n.noteIv));
  }

  String decryptAddress(Address a) {
    if (a == null) return '';
    if (a.addressIv.isEmpty) return '';
    if (a.addressEnc.isEmpty) return '';
    return _crypter.decrypt64(a.addressEnc, iv: e.IV.fromBase64(a.addressIv));
  }

  Password createPassword(String p) {
    if (p.isEmpty) return null;
    Password _p = Password(
      passwordIv: e.IV.fromSecureRandom(16).base64,
      passwordHash: doHash(p),
    );
    _p.passwordEnc = doCrypt(p, _p.passwordIv);
    _p.passwordStrength = Zxcvbn().evaluate(p).score.toString();
    return _p;
  }

  Username createUsername(String u) {
    if (u.isEmpty) return null;
    Username _u = Username(
      usernameIv: e.IV.fromSecureRandom(16).base64,
      usernameHash: doHash(u),
    );
    _u.usernameEnc = doCrypt(u, _u.usernameIv);
    return _u;
  }

  Pin createPin(String p) {
    if (p.isEmpty) return null;
    Pin _p = Pin(pinIv: e.IV.fromSecureRandom(16).base64);
    _p.pinEnc = doCrypt(p, _p.pinIv);
    return _p;
  }

  Note createNote(String l) {
    if (l.isEmpty) return null;
    Note _n = Note(noteIv: e.IV.fromSecureRandom(16).base64);
    _n.noteEnc = doCrypt(l, _n.noteIv);
    return _n;
  }

  Address createAddress(String a) {
    if (a.isEmpty) return null;
    Address _a = Address(addressIv: e.IV.fromSecureRandom(16).base64);
    _a.addressEnc = doCrypt(a, _a.addressIv);
    return _a;
  }
}
