import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/cpe_body.dart';

class NistProvider with ChangeNotifier {
  static const _baseUrl = 'https://services.nvd.nist.gov/rest/json';

  Future<CpeBody> getCpesByCpeMatch({
    String type = '*',
    String trademark = '*',
    String model = '*',
  }) async {
    final urlString =
        '$_baseUrl/cpes/1.0?cpeMatchString=cpe:2.3:$type:$trademark:$model&resultsPerPage=100';
    final response = await http.get(Uri.parse(urlString));
    if (response.statusCode == 200) {
      return CpeBody.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed. Status code: ${response.statusCode}');
    }
  }

  Future<CpeBody> getCpesByKeyword(String keyword) async {
    keyword = keyword.trim();
    keyword = keyword.replaceAll(' ', '_');
    final urlString = '$_baseUrl/cpes/1.0?keyword=$keyword&resultsPerPage=100';
    final response = await http.get(Uri.parse(urlString));
    if (response.statusCode == 200) {
      return CpeBody.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed. Status code: ${response.statusCode}');
    }
  }
}
