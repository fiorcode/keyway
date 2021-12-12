import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/api/nist/cpe_body.dart';

class NistProvider with ChangeNotifier {
  static HttpClient client = new HttpClient();
  static const _baseUrl = 'https://services.nvd.nist.gov/rest/json';

  Future<CpeBody> getCpesByCpeMatch({
    String? type = '*',
    String trademark = '*',
    String model = '*',
    int startIndex = 0,
  }) async {
    trademark = trademark.replaceAll(' ', '_');
    model = model.replaceAll(' ', '_');
    String urlString =
        '$_baseUrl/cpes/1.0?cpeMatchString=cpe:2.3:$type:$trademark:$model&addOns=cves&resultsPerPage=100&startIndex=$startIndex';
    try {
      HttpClientRequest request = await client.getUrl(Uri.parse(urlString));
      HttpClientResponse response = await request.close();
      if (response.statusCode == 200) {
        String _json = await response.transform(utf8.decoder).join();
        return CpeBody.fromJson(jsonDecode(_json));
      } else if (response.statusCode == 404) {
        throw Exception('Not Found ❌');
      } else {
        throw Exception('Failed. Status code: ${response.statusCode}');
      }
    } on SocketException {
      throw Exception('No Internet connection 😭');
    }
  }

  Future<CpeBody> getCpesByKeyword(String keyword, {int startIndex = 0}) async {
    keyword = keyword.trim();
    keyword = keyword.replaceAll(' ', '_');
    final urlString =
        '$_baseUrl/cpes/1.0?keyword=$keyword&resultsPerPage=100&startIndex=$startIndex';
    final response = await http.get(Uri.parse(urlString));
    if (response.statusCode == 200) {
      return CpeBody.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed. Status code: ${response.statusCode}');
    }
  }
}
