import 'dart:convert';
import 'package:animated_background/animated_background.dart';
import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:metaballs/metaballs.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talkbuddyai/screens/dashboard/dashboard_with_bottom_bar.dart';
import 'package:talkbuddyai/screens/home/home_page.dart';
import 'package:talkbuddyai/screens/loginToChat/loginToChat.dart';
import 'package:talkbuddyai/screens/signup/signup.dart';
import 'package:talkbuddyai/shared/colors.dart';
import 'package:talkbuddyai/shared/text_field.dart';
import 'package:http/http.dart' as http;
import 'login_screen.dart';

class LoginForm extends StatefulWidget {
  LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> with TickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _access_tokenController = TextEditingController();
  PhoneNumber number = PhoneNumber(isoCode: 'TR');

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
        await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'TR');

    setState(() {
      this.number = number;
    });
  }

  bool isLoggedIn = false;

  Future<void> loginService(BuildContext context) async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    try {
      final http.Response response = await http.post(
        Uri.parse("http://10.1.1.225:8002/web/login"),
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

        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("access_token", accessToken);
        pref.setString("username", username);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => BottomBar(
              username: username,
              authToken: accessToken,
              selectedIndex: 0,
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Phone number or password is incorrect!!!')),
        );
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> logout(BuildContext context) async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void navigateToNextPage() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? accessToken = pref.getString("access_token");
    String? username = pref.getString("username");

    if (accessToken != null && username != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoginToChat(
            username: username,
            authToken: accessToken,
          ),
        ),
      );
    }
  }

  Future<void> getRemember() async {
    final prefs = await SharedPreferences.getInstance();
    isChecked = prefs.getBool('hatırla') ?? false;
    if (isChecked) {
      _usernameController.text = prefs.getString('username') ?? "";
      _access_tokenController.text = prefs.getString('access_token') ?? "";
    }
    setState(() {});
  }

  Future<void> setRemember() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        'username', isChecked ? _usernameController.text : "");
    await prefs.setString(
        'access_token', isChecked ? _access_tokenController.text : "");
    await prefs.setBool('hatırla', isChecked);
  }

  bool isChecked = false;
  bool passwordVisible = false;
  int colorEffectIndex = 0;

  @override
  void initState() {
    super.initState();
    getRemember();
    passwordVisible = true;
  }

  bool isPhoneNumberValid = true;

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
                        AnimateIcon(
                          key: UniqueKey(),
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              PageTransition(
                                type: PageTransitionType.leftToRightWithFade,
                                child: HomePage(key: Key("")),
                                duration: const Duration(milliseconds: 300),
                              ),
                            );
                          },
                          iconType: IconType.onlyIcon,
                          height: 70,
                          width: 70,
                          color: Colors.orange,
                          animateIcon: AnimateIcons.skipBackwards,
                        ),
                        const SizedBox(height: 50),
                        Center(
                          child: CircleAvatar(
                            radius: 100,
                            backgroundImage: AssetImage(
                              'lib/assets/gifs/giphy.gif',
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 8.0),
                              ),
                              TextFieldWidget(
                                  controller: _usernameController,
                                  title: "+905555555555"),
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
                                            ],
                                          ),
                                          color: Colors.white,
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(30),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black54
                                                  .withOpacity(0.4),
                                              spreadRadius: 5,
                                              blurRadius: 7,
                                              offset: const Offset(0, 3),
                                            ),
                                          ],
                                        ),
                                        child: TextButton(
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
                                          onPressed: () async {
                                            await loginService(context);
                                          },
                                          child: const Text(
                                            "SUBMIT",
                                            style: TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ),
                                    ),
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
                                      disabledForegroundColor:
                                          Colors.transparent.withOpacity(0.38),
                                      disabledBackgroundColor:
                                          Colors.transparent.withOpacity(0.12),
                                      shadowColor: Colors.transparent,
                                    ),
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUp()),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        const Text(
                                            "'Don’t have an account yet?'",
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.normal,
                                                color: Colors.black)),
                                        Text(" Create your account",
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 10),
                              if (!isPhoneNumberValid)
                                Text(
                                  'Geçerli bir telefon numarası girin.',
                                  style: TextStyle(color: Colors.red),
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

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.yellow;
    }
    return Colors.yellow;
  }
}
