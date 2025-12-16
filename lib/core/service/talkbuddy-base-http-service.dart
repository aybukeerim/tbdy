import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talkbuddyai/core/api_env/api_env.dart';

class TalkBuddyHttpService {
  final String baseUrl = baseUrlApi;

  TalkBuddyHttpService();

  Future<String> post(String endpoint, dynamic body) async {
    String stringData = "";
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    try {
      var req = baseUrl + endpoint;
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(req));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      request.headers.set('Authorization', 'Bearer $token');
      request.headers.set('content-type', 'application/json');
      request.add(utf8.encode(json.encode(body)));
      HttpClientResponse response = await request.close();
      stringData = await response.transform(utf8.decoder).join();
    } finally {
      httpClient.close();
    }
    return stringData;
  }
}
