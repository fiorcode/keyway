import 'package:external_path/external_path.dart';

import '../models/depot.dart';

class StorageHelper {
  static Future<List<String>> _externalPaths() async =>
      await ExternalPath.getExternalStorageDirectories();

  static Future<List<Depot>> getDepots() async {
    List<String> _paths = await _externalPaths();
    if (_paths.isNotEmpty) {
      List<Depot> _depots = <Depot>[];
      _paths.forEach((path) {
        _depots.add(Depot.factory(path));
      });
      return _depots;
    } else
      return <Depot>[];
  }
}
