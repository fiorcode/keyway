import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:googleapis/drive/v3.dart' as ga;
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:keyway/helpers/storage_helper.dart';

const _clientId =
    '51420250153-m16q6i98hbjc2unavf5lo4raov95rds7.apps.googleusercontent.com';
const _scopes = [ga.DriveApi.DriveFileScope];

class DriveHelper {
  final storage = StorageHelper();

  //Get Authenticated Http Client
  Future<http.Client> getHttpClient() async {
    //Get Stored Credentials
    var credentials = await storage.getCredentials();
    if (credentials == null) {
      var authClient = await clientViaUserConsent(
        ClientId(_clientId, ""),
        _scopes,
        (url) => launch(url),
      );
      storage.saveCredentials(
        authClient.credentials.accessToken,
        authClient.credentials.refreshToken,
      );
      return authClient;
    } else {
      return authenticatedClient(
        http.Client(),
        AccessCredentials(
            AccessToken(
              credentials['type'],
              credentials['data'],
              DateTime.parse(credentials['expriy']),
            ),
            credentials['refreshToken'],
            _scopes),
      );
    }
  }

  //UPLOAD FILE
  Future upload(File file) async {
    var client = await getHttpClient();
    var drive = ga.DriveApi(client);

    var response = await drive.files.create(
        ga.File()..name = path.basename(file.absolute.path),
        uploadMedia: ga.Media(file.openRead(), file.lengthSync()));
    print(response.toJson());
  }
}
