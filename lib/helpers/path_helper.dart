import 'package:external_path/external_path.dart';

class PathHelper {
  static Future<List<String>> externalPaths() async =>
      await ExternalPath.getExternalStorageDirectories();
}
