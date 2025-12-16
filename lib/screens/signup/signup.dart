import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:metaballs/metaballs.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talkbuddyai/core/api_env/api_env.dart';
import 'package:talkbuddyai/screens/login/login_screen.dart';
import 'package:talkbuddyai/shared/colors.dart';
import 'package:talkbuddyai/shared/text_field.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/authentication/verify_user/verify_user.dart';

class SignUp extends StatefulWidget {


  SignUp(  {super.key});

  @override
  State<SignUp> createState() => _SignUpState( );
}

class _SignUpState extends State<SignUp> with TickerProviderStateMixin {

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  int colorEffectIndex = 0;

  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();

    passwordVisible = true;
  }

  bool agree = false;

  _launchURL() async {
    final Uri url = Uri.parse(privacyPol);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }
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

    final String url = "http://10.1.1.225:8002/web/register";
    try {
      final msg = jsonEncode(
        {
          'name': name,
          'password': password,
          'phone': phone,
          'email': email,
        },
      );
      final http.Response response = await http.post(
        Uri.parse(url), headers: {'Content-Type': 'application/json'},
        body: msg
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

    final String tel = responseData['phone'];
        final String tokenType = responseData['token_type'];
        final String username = responseData['username'];
        final String authName = responseData['auth_name'];

       print('Tel: $tel');
        print('Token Type: $tokenType');
        print('Username: $username');
        print('Auth Name: $authName');
        await _saveLoginState(true);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PhoneAuthScreen()),
        );
      } else {
        print(response.body);
      }
    } catch (e) {
      print('Error: $e');
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Metaballs(
            effect: colorsAndEffects[colorEffectIndex].effect,
            glowRadius: 1,
            glowIntensity: 0.9,
            maxBallRadius: 50,
            minBallRadius: 20,
            metaballs: 40,
            gradient: LinearGradient(
                colors: colorsAndEffects[colorEffectIndex].colors,
                begin: Alignment.bottomRight,
                end: Alignment.topLeft),
            child: AnimatedBackground(
              behaviour: RandomParticleBehaviour(
                options: const ParticleOptions(
                  baseColor: Colors.yellow,
                  spawnOpacity: 0.0,
                  opacityChangeRate: 0.25,
                  minOpacity: 0.1,
                  maxOpacity: 0.4,
                  spawnMinSpeed: 30.0,
                  spawnMaxSpeed: 70.0,
                  spawnMinRadius: 7.0,
                  spawnMaxRadius: 15.0,
                  particleCount: 40,
                ),
              ),
              vsync: this,
              child: SingleChildScrollView(
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: 20.0, left: 20.0, top: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        const SizedBox(height: 50),
                        Text(
                          "REGISTER",
                          style: TextStyle(fontSize: 22),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 8.0),
                              ),
                              TextFieldWidget(
                                  controller: _usernameController,
                                  title: "Name"),
                              const SizedBox(height: 20),
                              TextFieldWidget(
                                  controller: _phoneController, title: "+905555555555"),
                              const SizedBox(height: 20),
                              TextFieldWidget(
                                  controller: _emailController, title: "Email"),
                              const SizedBox(height: 20),
                              TextField(
                                obscureText: passwordVisible,
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  fillColor: const Color(0xffe8f0fd),
                                  filled: true,
                                  hintText: 'Password',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      passwordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Colors.orangeAccent.shade100,
                                    ),
                                    onPressed: () {
                                      setState(
                                        () {
                                          passwordVisible = !passwordVisible;
                                        },
                                      );
                                    },
                                  ),
                                  alignLabelWithHint: false,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(5),
                                    borderSide: BorderSide.none,
                                  ),
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                textInputAction: TextInputAction.done,
                              ),
                              const SizedBox(height: 15),
                              Row(
                                children: [
                                  Material(
                                    child: Checkbox(
                                      value: agree,
                                      onChanged: (value) {
                                        setState(() {
                                          agree = value ?? false;
                                        });
                                      },
                                    ),
                                    color: Colors.transparent,
                                  ),
                                  Expanded(
                                    child: TextButton(
                                      child: Text(
                                        'I have read and accept the Confidentiality Agreement.',
                                        overflow: TextOverflow.clip,
                                      ),
                                      onPressed: _launchURL,
                                    ),
                                  )
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 30.0, bottom: 20.0),
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    SizedBox(
                                        height: 45,
                                        child: Container(
                                          decoration: BoxDecoration(
                                              gradient: LinearGradient(
                                                  begin: Alignment.topRight,
                                                  end: Alignment.bottomCenter,
                                                  colors: <Color>[
                                                    Colors.yellow,
                                                    Colors.yellow.shade300,
                                                  ]),
                                              color: Colors.white,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                      Radius.circular(30)),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black54
                                                      .withOpacity(0.4),
                                                  spreadRadius: 5,
                                                  blurRadius: 7,
                                                  offset: const Offset(0, 3),
                                                ),
                                              ]),
                                          child: TextButton(
                                              style: TextButton.styleFrom(
                                                foregroundColor: Colors.black,
                                                backgroundColor:
                                                    Colors.transparent,
                                                disabledForegroundColor: Colors
                                                    .transparent
                                                    .withOpacity(0.38),
                                                disabledBackgroundColor: Colors
                                                    .transparent
                                                    .withOpacity(0.12),
                                                shadowColor: Colors.transparent,
                                              ),
                                              onPressed: () {
                                                agree ?  signup() : null;
                                              },
                                              child: const Text("REGISTER",
                                                  style: TextStyle(
                                                      fontSize: 18.0,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.black))),
                                        )),
                                  ],
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  TextButton(
                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.black,
                                        backgroundColor: Colors.transparent,
                                        disabledForegroundColor: Colors
                                            .transparent
                                            .withOpacity(0.38),
                                        disabledBackgroundColor: Colors
                                            .transparent
                                            .withOpacity(0.12),
                                        shadowColor: Colors.transparent,
                                      ),
                                      onPressed: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    LoginScreen()),
                                          ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          const Text(
                                              "'Already have an account?'",
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.normal,
                                                  color: Colors.black)),
                                          Text("Log In",
                                              style: TextStyle(
                                                  fontSize: 14.0,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.black),),
                                        ],
                                      )),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
