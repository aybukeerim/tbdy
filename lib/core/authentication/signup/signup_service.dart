import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talkbuddyai/core/authentication/verify_user/verify_user.dart';

class SignUpService {
  BuildContext? context;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  int colorEffectIndex = 0;

  Future<void> _saveLoginState(bool loggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', loggedIn);
  }

  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> signup() async {
    final String name = _usernameController.text;
    final String password = _passwordController.text;
    final String phone = _phoneController.text;
    final String email = _emailController.text;
    final msg = jsonEncode(
      {
        'name': name,
        'password': password,
        'phone': phone,
        'email': email,
      },
    );
    final String url = "http://10.1.1.225:8002/web/register";

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        body: msg,
        headers: {"content-type": "application/json"},
      );

      print(response.headers);
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // final String accessToken = responseData['access_token'];
        final String tokenType = responseData['token_type'];
        final String username = responseData['username'];
        final String authName = responseData['auth_name'];

        // print('Access Token: $accessToken');
        print('Token Type: $tokenType');
        print('Username: $username');
        print('Auth Name: $authName');

        print('responseData: $responseData');

        await _saveLoginState(true);
        Navigator.push(
          context!,
          MaterialPageRoute(builder: (context) => PhoneAuthScreen()),
        );
      } else {
        print(response);
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
