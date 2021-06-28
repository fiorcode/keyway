import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/cpe_body.dart';
import '../models/cpe.dart';

class NistProvider with ChangeNotifier {
  static const _baseUrl = 'https://services.nvd.nist.gov/rest/json';

  Future<List<Cpe>> getCpesByCpeMatch({
    String type = '*',
    String trademark = '*',
    String model = '*',
  }) async {
    final urlString =
        '$_baseUrl/cpes/1.0?cpeMatchString=cpe:2.3:$type:$trademark:$model&resultsPerPage=50';
    final response = await http.get(Uri.parse(urlString));
    if (response.statusCode == 200) {
      CpeBody _body = CpeBody.fromJson(jsonDecode(response.body));
      return _body.result.cpes;
    } else {
      throw Exception('Failed. Status code: ${response.statusCode}');
    }
  }
}
