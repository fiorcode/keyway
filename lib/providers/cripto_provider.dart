import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cryptography/cryptography.dart';
import 'package:crypto/crypto.dart';
// import 'package:encrypt/encrypt.dart' as e;
import 'package:zxcvbn/zxcvbn.dart';

import 'package:keyway/helpers/db_helper.dart';
import 'package:keyway/models/address.dart';
import 'package:keyway/models/item.dart';
import 'package:keyway/models/note.dart';
import 'package:keyway/models/pin.dart';
import 'package:keyway/models/user.dart';
import 'package:keyway/models/username.dart';
import 'package:keyway/models/password.dart';

class CriptoProvider with ChangeNotifier {
  bool _locked = true;
  // SharedPreferences _pref;
  // e.Encrypter _crypter;
  AesCbc _aesCbc;
  SecretKey _secretKey;

  CriptoProvider() {
    _aesCbc = AesCbc.with256bits(macAlgorithm: MacAlgorithm.empty);
    lock();
  }

  bool get locked => _locked;

  Future<String> _getMasterKey() async =>
      (await SharedPreferences.getInstance()).getString('masterKey');

  Future<String> _getMasterKeyIV() async =>
      (await SharedPreferences.getInstance()).getString('masterKeyIV');

  Future<bool> isMasterKey() async =>
      (await SharedPreferences.getInstance()).getBool('isMasterKey') ?? false;

  Future<SecretBox> _getSecret() async {
    String _mk = await _getMasterKey();
    String _mkIv = await _getMasterKeyIV();
    return SecretBox(_mk.codeUnits, nonce: _mkIv.codeUnits, mac: Mac.empty);
  }

  static String doHash(String s) =>
      s.isNotEmpty ? sha256.convert(utf8.encode(s)).toString() : '';

  void lock() {
    _secretKey = SecretKey('PASS*CLEARED'.codeUnits);
    _locked = true;
    notifyListeners();
  }

  // void lock() {
  //   _crypter = e.Encrypter(e.AES(e.Key.fromUtf8('PASS*CLEARED')));
  //   _locked = true;
  //   notifyListeners();
  // }

  Future<void> unlock(String key) async {
    try {
      _secretKey = await _aesCbc
          .newSecretKeyFromBytes(doHash(key).substring(0, 32).codeUnits);
      SecretBox _sb = await _getSecret();
      _secretKey = SecretKey(await _aesCbc.decrypt(_sb, secretKey: _secretKey));
      _locked = false;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  // Future<void> unlock(String key) async {
  //   try {
  //     _crypter = e.Encrypter(
  //       e.AES(
  //         e.Key.fromBase16(doHash(key).substring(0, 32)),
  //         mode: e.AESMode.cbc,
  //       ),
  //     );
  //     String _mk = await _getMasterKey();
  //     String _mkIv = await _getMasterKeyIV();
  //     e.Encrypted _mkCrypted = e.Encrypted.fromBase64(_mk);
  //     e.IV _iv = e.IV.fromBase64(_mkIv);
  //     _mk = _crypter.decrypt(_mkCrypted, iv: _iv);
  //     _crypter = e.Encrypter(e.AES(e.Key.fromUtf8(_mk), mode: e.AESMode.cbc));
  //     _mk = 'MASTER*KEY*CLEARED';
  //     _locked = false;
  //     notifyListeners();
  //   } catch (error) {
  //     throw error;
  //   }
  // }

  // Future<bool> initialSetup(String key) async {
  //   //CREATES A ENCRYPTER WITH THE USERS KEY
  //   _crypter = e.Encrypter(
  //     e.AES(
  //       e.Key.fromBase16(doHash(key).substring(0, 32)),
  //       mode: e.AESMode.cbc,
  //     ),
  //   );

  //   //GENERATES A RANDOM STRING TO BE USED AS MASTER KEY
  //   List<int> _v = List<int>.generate(32, (i) => Random.secure().nextInt(256));
  //   String _mk = base64Url.encode(_v).substring(0, 32);

  //   //ENCRYPT AND SAVE MASTER KEY
  //   e.IV _iv = e.IV.fromSecureRandom(16);
  //   e.Encrypted _mkCrypted = _crypter.encrypt(_mk, iv: _iv);
  //   _pref = await SharedPreferences.getInstance();
  //   _pref.setString('masterKey', _mkCrypted.base64);
  //   _pref.setString('masterKeyIV', _iv.base64);
  //   _pref.setBool('isMasterKey', true);

  //   //SAVE MASTER KEY IN DATABASE
  //   await DBHelper.insert(
  //     DBHelper.userTable,
  //     {'mk_enc': _mkCrypted.base64, 'mk_iv': _iv.base64},
  //   );

  //   _v.clear();
  //   _mk = 'MASTER*KEY*CLEARED';
  //   _mkCrypted = null;

  //   await unlock(key);

  //   return true;
  // }

  static Future<bool> initialSetup(String key) async {
    //  CREATES A ENCRYPTER WITH THE USERS KEY
    final _algo = AesCbc.with256bits(macAlgorithm: MacAlgorithm.empty);
    final _secret = await _algo.newSecretKeyFromBytes(
      doHash(key).substring(0, 32).codeUnits,
    );
    _algo.newNonce();

    //  GENERATES A RANDOM STRING TO BE USED AS MASTER KEY
    List<int> _v = List<int>.generate(32, (i) => Random.secure().nextInt(256));
    String _mk = base64Url.encode(_v).substring(0, 32);

    //  ENCRYPT AND SAVE MASTER KEY
    SecretBox _sb = await _algo.encrypt(_mk.codeUnits, secretKey: _secret);
    SharedPreferences _pref = await SharedPreferences.getInstance();
    _pref.setString('masterKey', String.fromCharCodes(_sb.cipherText));
    _pref.setString('masterKeyIV', String.fromCharCodes(_sb.nonce));
    _pref.setBool('isMasterKey', true);

    //  SAVE MASTER KEY IN DATABASE
    await DBHelper.insert(
      DBHelper.userTable,
      {
        'mk_enc': String.fromCharCodes(_sb.cipherText),
        'mk_iv': String.fromCharCodes(_sb.nonce),
      },
    );

    _v.clear();
    _mk = 'MASTER*KEY*CLEARED';
    _sb = null;

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

  Future<String> doCrypt(String value, String iv) async {
    if (value.isEmpty || value == null) return '';
    SecretBox _sb = await _aesCbc.encrypt(value.codeUnits,
        secretKey: _secretKey, nonce: iv.codeUnits);
    return String.fromCharCodes(_sb.cipherText);
  }

  // String doCrypt(String value, String iv) {
  //   if (value.isEmpty || value == null) return '';
  //   return _crypter.encrypt(value, iv: e.IV.fromBase64(iv)).base64;
  // }

  Future<String> doDecrypt(String value, String iv) async {
    if (value.isEmpty || value == null) return '';
    return String.fromCharCodes(
      (await _aesCbc.decrypt(
        SecretBox(value.codeUnits, nonce: iv.codeUnits, mac: Mac.empty),
        secretKey: _secretKey,
      )),
    );
  }

  // String doDecrypt(String value, String iv) {
  //   if (value.isEmpty || value == null) return '';
  //   return _crypter.decrypt64(value, iv: e.IV.fromBase64(iv));
  // }

  Future<String> decryptPassword(Password p) async {
    if (p == null) return '';
    if (p.passwordIv.isEmpty) return '';
    if (p.passwordEnc.isEmpty) return '';
    SecretBox _sb = SecretBox(
      p.passwordEnc.codeUnits,
      nonce: p.passwordIv.codeUnits,
      mac: Mac.empty,
    );
    p.passwordDec = String.fromCharCodes((await _aesCbc.decrypt(
      _sb,
      secretKey: _secretKey,
    )));
    return p.passwordDec;
  }

  // String decryptPassword(Password p) {
  //   if (p == null) return '';
  //   if (p.passwordIv.isEmpty) return '';
  //   if (p.passwordEnc.isEmpty) return '';
  //   return _crypter.decrypt64(p.passwordEnc, iv: e.IV.fromBase64(p.passwordIv));
  // }

  Future<String> decryptUsername(Username u) async {
    if (u == null) return '';
    if (u.usernameIv.isEmpty) return '';
    if (u.usernameEnc.isEmpty) return '';
    SecretBox _sb = SecretBox(
      u.usernameEnc.codeUnits,
      nonce: u.usernameIv.codeUnits,
      mac: Mac.empty,
    );
    u.usernameDec = String.fromCharCodes((await _aesCbc.decrypt(
      _sb,
      secretKey: _secretKey,
    )));
    return u.usernameDec;
  }

  // String decryptUsername(Username u) {
  //   if (u == null) return '';
  //   if (u.usernameIv.isEmpty) return '';
  //   if (u.usernameEnc.isEmpty) return '';
  //   return _crypter.decrypt64(u.usernameEnc, iv: e.IV.fromBase64(u.usernameIv));
  // }

  Future<String> decryptPin(Pin p) async {
    if (p == null) return '';
    if (p.pinIv.isEmpty) return '';
    if (p.pinEnc.isEmpty) return '';
    SecretBox _sb = SecretBox(
      p.pinEnc.codeUnits,
      nonce: p.pinIv.codeUnits,
      mac: Mac.empty,
    );
    p.pinDec = String.fromCharCodes((await _aesCbc.decrypt(
      _sb,
      secretKey: _secretKey,
    )));
    return p.pinDec;
  }

  // String decryptPin(Pin p) {
  //   if (p == null) return '';
  //   if (p.pinIv.isEmpty) return '';
  //   if (p.pinEnc.isEmpty) return '';
  //   return _crypter.decrypt64(p.pinEnc, iv: e.IV.fromBase64(p.pinIv));
  // }

  Future<String> decryptNote(Note n) async {
    if (n == null) return '';
    if (n.noteIv.isEmpty) return '';
    if (n.noteEnc.isEmpty) return '';
    SecretBox _sb = SecretBox(
      n.noteEnc.codeUnits,
      nonce: n.noteIv.codeUnits,
      mac: Mac.empty,
    );
    n.noteDec = String.fromCharCodes((await _aesCbc.decrypt(
      _sb,
      secretKey: _secretKey,
    )));
    return n.noteDec;
  }

  // String decryptNote(Note n) {
  //   if (n == null) return '';
  //   if (n.noteIv.isEmpty) return '';
  //   if (n.noteEnc.isEmpty) return '';
  //   return _crypter.decrypt64(n.noteEnc, iv: e.IV.fromBase64(n.noteIv));
  // }

  Future<String> decryptAddress(Address a) async {
    if (a == null) return '';
    if (a.addressIv.isEmpty) return '';
    if (a.addressEnc.isEmpty) return '';
    SecretBox _sb = SecretBox(
      a.addressEnc.codeUnits,
      nonce: a.addressIv.codeUnits,
      mac: Mac.empty,
    );
    a.addressDec = String.fromCharCodes((await _aesCbc.decrypt(
      _sb,
      secretKey: _secretKey,
    )));
    return a.addressDec;
  }

  // String decryptAddress(Address a) {
  //   if (a == null) return '';
  //   if (a.addressIv.isEmpty) return '';
  //   if (a.addressEnc.isEmpty) return '';
  //   return _crypter.decrypt64(a.addressEnc, iv: e.IV.fromBase64(a.addressIv));
  // }

  Future<Password> createPassword(String p) async {
    if (p.isEmpty) return null;
    Password _p = Password(
      passwordIv: String.fromCharCodes(_aesCbc.newNonce()),
      passwordHash: doHash(p),
    );
    SecretBox _sb = await _aesCbc.encrypt(
      p.codeUnits,
      secretKey: _secretKey,
      nonce: _p.passwordIv.codeUnits,
    );
    _p.passwordEnc = String.fromCharCodes(_sb.cipherText);
    _p.passwordStrength = Zxcvbn().evaluate(p).score.toString();
    return _p;
  }

  // Password createPassword(String p) {
  //   if (p.isEmpty) return null;
  //   Password _p = Password(
  //     passwordIv: e.IV.fromSecureRandom(16).base64,
  //     passwordHash: doHash(p),
  //   );
  //   _p.passwordEnc = doCrypt(p, _p.passwordIv);
  //   _p.passwordStrength = Zxcvbn().evaluate(p).score.toString();
  //   return _p;
  // }

  Future<Username> createUsername(String u) async {
    if (u.isEmpty) return null;
    Username _u = Username(
      usernameIv: String.fromCharCodes(_aesCbc.newNonce()),
      usernameHash: doHash(u),
    );
    SecretBox _sb = await _aesCbc.encrypt(
      u.codeUnits,
      secretKey: _secretKey,
      nonce: _u.usernameIv.codeUnits,
    );
    _u.usernameEnc = String.fromCharCodes(_sb.cipherText);
    return _u;
  }

  // Username createUsername(String u) {
  //   if (u.isEmpty) return null;
  //   Username _u = Username(
  //     usernameIv: e.IV.fromSecureRandom(16).base64,
  //     usernameHash: doHash(u),
  //   );
  //   _u.usernameEnc = doCrypt(u, _u.usernameIv);
  //   return _u;
  // }

  Future<Pin> createPin(String p) async {
    if (p.isEmpty) return null;
    Pin _p = Pin(pinIv: String.fromCharCodes(_aesCbc.newNonce()));
    SecretBox _sb = await _aesCbc.encrypt(
      p.codeUnits,
      secretKey: _secretKey,
      nonce: _p.pinIv.codeUnits,
    );
    _p.pinEnc = String.fromCharCodes(_sb.cipherText);
    return _p;
  }

  // Pin createPin(String p) {
  //   if (p.isEmpty) return null;
  //   Pin _p = Pin(pinIv: e.IV.fromSecureRandom(16).base64);
  //   _p.pinEnc = doCrypt(p, _p.pinIv);
  //   return _p;
  // }

  Future<Note> createNote(String n) async {
    if (n.isEmpty) return null;
    Note _n = Note(noteIv: String.fromCharCodes(_aesCbc.newNonce()));
    SecretBox _sb = await _aesCbc.encrypt(
      n.codeUnits,
      secretKey: _secretKey,
      nonce: _n.noteIv.codeUnits,
    );
    _n.noteEnc = String.fromCharCodes(_sb.cipherText);
    return _n;
  }

  // Note createNote(String l) {
  //   if (l.isEmpty) return null;
  //   Note _n = Note(noteIv: e.IV.fromSecureRandom(16).base64);
  //   _n.noteEnc = doCrypt(l, _n.noteIv);
  //   return _n;
  // }

  Future<Address> createAddress(String a) async {
    if (a.isEmpty) return null;
    Address _a = Address(addressIv: String.fromCharCodes(_aesCbc.newNonce()));
    SecretBox _sb = await _aesCbc.encrypt(
      a.codeUnits,
      secretKey: _secretKey,
      nonce: _a.addressIv.codeUnits,
    );
    _a.addressEnc = String.fromCharCodes(_sb.cipherText);
    return _a;
  }

  // Address createAddress(String a) {
  //   if (a.isEmpty) return null;
  //   Address _a = Address(addressIv: e.IV.fromSecureRandom(16).base64);
  //   _a.addressEnc = doCrypt(a, _a.addressIv);
  //   return _a;
  // }

  Future<void> decryptItem(Item i) async {
    if (i.password != null) await this.decryptPassword(i.password);
    if (i.username != null) await this.decryptUsername(i.username);
    if (i.pin != null) await this.decryptPin(i.pin);
    if (i.address != null) await this.decryptAddress(i.address);
    if (i.note != null) await this.decryptNote(i.note);
  }
}
