import 'package:keyway/models/cpe_result.dart';

class CpeBody {
  final int resultsPerPage;
  final int startIndex;
  final int totalResults;
  final CpeResult result;

  CpeBody({
    this.resultsPerPage,
    this.startIndex,
    this.totalResults,
    this.result,
  });

  factory CpeBody.fromJson(Map<String, dynamic> parsedJson) {
    return CpeBody(
      resultsPerPage: parsedJson['resultsPerPage'],
      startIndex: parsedJson['startIndex'],
      totalResults: parsedJson['totalResults'],
      result: CpeResult.fromJson(parsedJson['result']),
    );
  }
}
