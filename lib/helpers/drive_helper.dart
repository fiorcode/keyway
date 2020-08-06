import 'dart:io';
import "package:http/io_client.dart";

import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as gda;

class DriveHelper {
  bool _userLoad = false;
  GoogleSignIn _googleSignIn;
  GoogleSignInAccount _currentUser;

  bool get userLoad => _userLoad;

  DriveHelper() {
    _googleSignIn = GoogleSignIn(scopes: [gda.DriveApi.DriveAppdataScope]);
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount account) {
      _currentUser = account;
      if (_currentUser != null) {}
    });
    _googleSignIn.signInSilently();
  }

  //Get Authenticated Http Client
  Future<http.Client> getHttpClient() async {
    return GoogleHttpClient(await _currentUser.authHeaders);
  }

  //UPLOAD FILE
  Future upload(File file) async {
    var client = await getHttpClient();
    var drive = gda.DriveApi(client);

    var response = await drive.files.create(
        gda.File()..name = path.basename(file.absolute.path),
        uploadMedia: gda.Media(file.openRead(), file.lengthSync()));
    print(response.toJson());
  }
}

class GoogleHttpClient extends IOClient {
  Map<String, String> _headers;
  GoogleHttpClient(this._headers) : super();
  @override
  Future<IOStreamedResponse> send(http.BaseRequest request) =>
      super.send(request..headers.addAll(_headers));

  @override
  Future<http.Response> head(Object url, {Map<String, String> headers}) =>
      super.head(url, headers: headers..addAll(_headers));
}
