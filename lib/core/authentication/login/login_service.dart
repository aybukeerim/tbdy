import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talkbuddyai/core/api_env/api_env.dart';
import 'package:talkbuddyai/core/authentication/verify_user/verify_user.dart';
import 'package:talkbuddyai/screens/login/login_screen.dart';

class LoginService {
  BuildContext? context;
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _saveLoginState(bool loggedIn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', loggedIn);
  }

  Future<bool> isUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  Future<void> loginService() async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final String url = baseUrlApi + loginEndPoint;

    try {
      final http.Response response = await http.post(
        Uri.parse(url),
        body: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        final String accessToken = responseData['access_token'];
        final String tokenType = responseData['token_type'];
        final String username = responseData['username'];
        final String authName = responseData['auth_name'];

        print('Access Token: $accessToken');
        print('Token Type: $tokenType');
        print('Username: $username');
        print('Auth Name: $authName');
        await _saveLoginState(true);
        Navigator.push(
          context!,
          MaterialPageRoute(builder: (context) => PhoneAuthScreen()),
        );
      } else {
        print('Giriş Başarısız');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> logout(BuildContext context) async {
    await _saveLoginState(false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}
