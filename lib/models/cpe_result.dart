import 'package:keyway/models/cpe.dart';

class CpeResult {
  final String dataType;
  final String feedVersion;
  final int cpeCount;
  final String feedTimestamp;
  final List<Cpe> cpes;

  CpeResult({
    this.dataType,
    this.feedVersion,
    this.cpeCount,
    this.feedTimestamp,
    this.cpes,
  });

  factory CpeResult.fromJson(Map<String, dynamic> parsedJson) {
    List<dynamic> _cpes = parsedJson['cpes'] as List<dynamic>;
    return CpeResult(
      dataType: parsedJson['dataType'],
      feedVersion: parsedJson['feedVersion'],
      cpeCount: parsedJson['cpeCount'],
      feedTimestamp: parsedJson['feedTimestamp'],
      cpes: _cpes.map((c) => Cpe.fromJson(c)).toList(),
    );
  }
}
