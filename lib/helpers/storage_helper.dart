import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:googleapis_auth/auth.dart';

class StorageHelper {
  final storage = FlutterSecureStorage();

  //Save Credentials
  Future saveCredentials(AccessToken token, String refreshToken) async {
    await storage.write(key: 'type', value: token.type);
    await storage.write(key: 'data', value: token.data);
    await storage.write(key: 'expriy', value: token.expiry.toIso8601String());
    await storage.write(key: 'refreshtoken', value: refreshToken);
  }

  //Get Saved Credentials
  Future<Map<String, dynamic>> getCredentials() async {
    var result = await storage.readAll();
    if (result.length == 0) return null;
    return result;
  }

  //Clear Saved Credentials
  Future clear() {
    return storage.deleteAll();
  }
}
