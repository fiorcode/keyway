import 'package:keyway/models/cpe_ref.dart';
import 'package:keyway/models/cpe_title.dart';

class Cpe {
  final bool deprecated;
  final String cpe23Uri;
  final String lastModifiedDate;
  final List<CpeTitle> titles;
  final List<CpeRef> refs;
  final List<String> vulnerabilities;

  Cpe({
    this.deprecated,
    this.cpe23Uri,
    this.lastModifiedDate,
    this.titles,
    this.refs,
    this.vulnerabilities,
  });

  String get type {
    switch (cpe23Uri.split(':')[2]) {
      case 'h':
        return 'HARDWARE';
        break;
      case 'o':
        return 'OS/FIRMAWARE';
        break;
      default:
        return 'APP/PROGRAM';
    }
  }

  String get trademark => cpe23Uri.split(':')[3].toUpperCase();

  String get model => cpe23Uri.split(':')[4].toUpperCase();

  bool get hasVulns => vulnerabilities.isNotEmpty;

  factory Cpe.fromJson(Map<String, dynamic> parsedJson) {
    List<dynamic> _cpeTitles = parsedJson['titles'] as List<dynamic>;
    List<dynamic> _cpeRefs = parsedJson['refs'] as List<dynamic>;
    return Cpe(
      deprecated: parsedJson['deprecated'],
      cpe23Uri: parsedJson['cpe23Uri'],
      lastModifiedDate: parsedJson['lastModifiedDate'],
      titles: _cpeTitles.map((t) => CpeTitle.fromJson(t)).toList(),
      refs: _cpeRefs.map((r) => CpeRef.fromJson(r)).toList(),
      vulnerabilities: List<String>.from(parsedJson['vulnerabilities']),
    );
  }
}
