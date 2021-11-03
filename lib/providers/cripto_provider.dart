import 'dart:async';
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
  late AesCbc _aesCbc;
  SecretKey? _secretKey;

  CriptoProvider() {
    _aesCbc = AesCbc.with256bits(macAlgorithm: MacAlgorithm.empty);
    lock();
  }

  bool get locked => _locked;

  Future<String?> _getMasterKey() async =>
      (await SharedPreferences.getInstance()).getString('masterKey');

  Future<String?> _getMasterKeyIV() async =>
      (await SharedPreferences.getInstance()).getString('masterKeyIV');

  Future<bool> isMasterKey() async =>
      (await SharedPreferences.getInstance()).getBool('isMasterKey') ?? false;

  Future<SecretBox> _getSecret() async {
    String _mk = await (_getMasterKey() as FutureOr<String>);
    String _mkIv = await (_getMasterKeyIV() as FutureOr<String>);
    return SecretBox(_mk.codeUnits, nonce: _mkIv.codeUnits, mac: Mac.empty);
  }

  static String doHash(String s) =>
      s.isNotEmpty ? sha256.convert(utf8.encode(s)).toString() : '';

  void lock() {
    _secretKey = SecretKey('PASS*CLEARED'.codeUnits);
    _locked = true;
    notifyListeners();
  }

  Future<void> unlock(String key) async {
    try {
      _secretKey = await _aesCbc
          .newSecretKeyFromBytes(doHash(key).substring(0, 32).codeUnits);
      SecretBox _sb = await _getSecret();
      _secretKey =
          SecretKey(await _aesCbc.decrypt(_sb, secretKey: _secretKey!));
      _locked = false;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

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
    _sb = SecretBox(''.codeUnits, nonce: ''.codeUnits, mac: Mac.empty);

    return true;
  }

  Future<void> setMasterKey() async {
    return SharedPreferences.getInstance().then((pref) {
      DBHelper.read(DBHelper.userTable).then((data) {
        User _user = User.fromMap(data.first);
        pref.setString('masterKey', _user.encMk!);
        pref.setString('masterKeyIV', _user.mkIv!);
        pref.setBool('isMasterKey', true);
      });
    });
  }

  Future<String?> decryptPassword(Password? p) async {
    if (p == null) return '';
    if (p.passwordIv!.isEmpty) return '';
    if (p.passwordEnc!.isEmpty) return '';
    SecretBox _sb = SecretBox(
      p.passwordEnc!.codeUnits,
      nonce: p.passwordIv!.codeUnits,
      mac: Mac.empty,
    );
    p.passwordDec = String.fromCharCodes((await _aesCbc.decrypt(
      _sb,
      secretKey: _secretKey!,
    )));
    return p.passwordDec;
  }

  Future<String?> decryptUsername(Username? u) async {
    if (u == null) return '';
    if (u.usernameIv!.isEmpty) return '';
    if (u.usernameEnc!.isEmpty) return '';
    SecretBox _sb = SecretBox(
      u.usernameEnc!.codeUnits,
      nonce: u.usernameIv!.codeUnits,
      mac: Mac.empty,
    );
    u.usernameDec = String.fromCharCodes((await _aesCbc.decrypt(
      _sb,
      secretKey: _secretKey!,
    )));
    return u.usernameDec;
  }

  Future<String?> decryptPin(Pin? p) async {
    if (p == null) return '';
    if (p.pinIv!.isEmpty) return '';
    if (p.pinEnc!.isEmpty) return '';
    SecretBox _sb = SecretBox(
      p.pinEnc!.codeUnits,
      nonce: p.pinIv!.codeUnits,
      mac: Mac.empty,
    );
    p.pinDec = String.fromCharCodes((await _aesCbc.decrypt(
      _sb,
      secretKey: _secretKey!,
    )));
    return p.pinDec;
  }

  Future<String?> decryptNote(Note? n) async {
    if (n == null) return '';
    if (n.noteIv!.isEmpty) return '';
    if (n.noteEnc!.isEmpty) return '';
    SecretBox _sb = SecretBox(
      n.noteEnc!.codeUnits,
      nonce: n.noteIv!.codeUnits,
      mac: Mac.empty,
    );
    n.noteDec = String.fromCharCodes((await _aesCbc.decrypt(
      _sb,
      secretKey: _secretKey!,
    )));
    return n.noteDec;
  }

  Future<String?> decryptAddress(Address? a) async {
    if (a == null) return '';
    if (a.addressIv!.isEmpty) return '';
    if (a.addressEnc!.isEmpty) return '';
    SecretBox _sb = SecretBox(
      a.addressEnc!.codeUnits,
      nonce: a.addressIv!.codeUnits,
      mac: Mac.empty,
    );
    a.addressDec = String.fromCharCodes((await _aesCbc.decrypt(
      _sb,
      secretKey: _secretKey!,
    )));
    return a.addressDec;
  }

  Future<Password?> createPassword(String p) async {
    if (p.isEmpty) return null;
    Password _p = Password(
      passwordIv: String.fromCharCodes(_aesCbc.newNonce()),
      passwordHash: doHash(p),
    );
    SecretBox _sb = await _aesCbc.encrypt(
      p.codeUnits,
      secretKey: _secretKey!,
      nonce: _p.passwordIv!.codeUnits,
    );
    _p.passwordEnc = String.fromCharCodes(_sb.cipherText);
    _p.passwordStrength = Zxcvbn().evaluate(p).score.toString();
    return _p;
  }

  Future<Username?> createUsername(String u) async {
    if (u.isEmpty) return null;
    Username _u = Username(
      usernameIv: String.fromCharCodes(_aesCbc.newNonce()),
      usernameHash: doHash(u),
    );
    SecretBox _sb = await _aesCbc.encrypt(
      u.codeUnits,
      secretKey: _secretKey!,
      nonce: _u.usernameIv!.codeUnits,
    );
    _u.usernameEnc = String.fromCharCodes(_sb.cipherText);
    return _u;
  }

  Future<Pin?> createPin(String p) async {
    if (p.isEmpty) return null;
    Pin _p = Pin(pinIv: String.fromCharCodes(_aesCbc.newNonce()));
    SecretBox _sb = await _aesCbc.encrypt(
      p.codeUnits,
      secretKey: _secretKey!,
      nonce: _p.pinIv!.codeUnits,
    );
    _p.pinEnc = String.fromCharCodes(_sb.cipherText);
    return _p;
  }

  Future<Note?> createNote(String n) async {
    if (n.isEmpty) return null;
    Note _n = Note(noteIv: String.fromCharCodes(_aesCbc.newNonce()));
    SecretBox _sb = await _aesCbc.encrypt(
      n.codeUnits,
      secretKey: _secretKey!,
      nonce: _n.noteIv!.codeUnits,
    );
    _n.noteEnc = String.fromCharCodes(_sb.cipherText);
    return _n;
  }

  Future<Address?> createAddress(String a) async {
    if (a.isEmpty) return null;
    Address _a = Address(addressIv: String.fromCharCodes(_aesCbc.newNonce()));
    SecretBox _sb = await _aesCbc.encrypt(
      a.codeUnits,
      secretKey: _secretKey!,
      nonce: _a.addressIv!.codeUnits,
    );
    _a.addressEnc = String.fromCharCodes(_sb.cipherText);
    return _a;
  }

  Future<void> decryptItem(Item i) async {
    if (i.password != null) await this.decryptPassword(i.password);
    if (i.username != null) await this.decryptUsername(i.username);
    if (i.pin != null) await this.decryptPin(i.pin);
    if (i.address != null) await this.decryptAddress(i.address);
    if (i.note != null) await this.decryptNote(i.note);
  }

  Future<void> decryptItemPasswords(Item i) async {
    Future.forEach(i.passwords!, (dynamic p) async {
      await this.decryptPassword(p);
    });
  }

  Future<Item?> computeDecryptItem(Item? i) async {
    ItemSecret _is = ItemSecret(i, _secretKey);
    Item? _i = await compute<ItemSecret, Item?>(_decryptItem, _is);
    return _i;
  }

  static Future<Item?> _decryptItem(ItemSecret i) async {
    AesCbc _aesCbc = AesCbc.with256bits(macAlgorithm: MacAlgorithm.empty);
    if (i.item!.password != null) {
      SecretBox _sbPassword = SecretBox(
        i.item!.password!.passwordEnc!.codeUnits,
        nonce: i.item!.password!.passwordIv!.codeUnits,
        mac: Mac.empty,
      );
      i.item!.password!.passwordDec = String.fromCharCodes(
          await _aesCbc.decrypt(_sbPassword, secretKey: i.secretKey!));
    }
    if (i.item!.username != null) {
      SecretBox _sbUsername = SecretBox(
        i.item!.username!.usernameEnc!.codeUnits,
        nonce: i.item!.username!.usernameIv!.codeUnits,
        mac: Mac.empty,
      );
      i.item!.username!.usernameDec = String.fromCharCodes(
          await _aesCbc.decrypt(_sbUsername, secretKey: i.secretKey!));
    }
    if (i.item!.pin != null) {
      SecretBox _sbPin = SecretBox(
        i.item!.pin!.pinEnc!.codeUnits,
        nonce: i.item!.pin!.pinIv!.codeUnits,
        mac: Mac.empty,
      );
      i.item!.pin!.pinDec = String.fromCharCodes(
          await _aesCbc.decrypt(_sbPin, secretKey: i.secretKey!));
    }
    if (i.item!.address != null) {
      SecretBox _sbAddress = SecretBox(
        i.item!.address!.addressEnc!.codeUnits,
        nonce: i.item!.address!.addressIv!.codeUnits,
        mac: Mac.empty,
      );
      i.item!.address!.addressDec = String.fromCharCodes(
          await _aesCbc.decrypt(_sbAddress, secretKey: i.secretKey!));
    }
    if (i.item!.note != null) {
      SecretBox _sbNote = SecretBox(
        i.item!.note!.noteEnc!.codeUnits,
        nonce: i.item!.note!.noteIv!.codeUnits,
        mac: Mac.empty,
      );
      i.item!.note!.noteDec = String.fromCharCodes(
          await _aesCbc.decrypt(_sbNote, secretKey: i.secretKey!));
    }
    return i.item;
  }
}

class ItemSecret {
  ItemSecret(this.item, this.secretKey);

  final Item? item;
  final SecretKey? secretKey;
}
