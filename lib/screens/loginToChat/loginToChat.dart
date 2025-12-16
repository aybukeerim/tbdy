import 'dart:convert';
import 'package:animate_do/animate_do.dart';
import 'package:animated_icon/animated_icon.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talkbuddyai/core/api_env/api_env.dart';
import 'package:talkbuddyai/screens/chat/chat_page.dart';
import 'package:talkbuddyai/screens/chat/speakOut/speakOutAi.dart';
import '../login/login_screen.dart';

class LoginToChat extends StatefulWidget {
  final String username;
  final String authToken;

  LoginToChat({Key? key, required this.username, required this.authToken})
      : super(key: key);

  @override
  State<LoginToChat> createState() => _LoginToChatState();
}

class _LoginToChatState extends State<LoginToChat>
    with TickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatBotScreen(
              username: username,
              authToken: accessToken,
            ),
          ),
        );
      } else {
        print('Giriş Başarısız');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  int start = 200;
  int delay = 200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AnimateIcon(
          key: UniqueKey(),
          onTap: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();

            prefs.remove('username');
            prefs.remove('access_token');

            Navigator.of(context).push(
              PageTransition(
                type: PageTransitionType.leftToRight,
                child: LoginScreen(),
                //PhoneAuthScreen(),
                // isIos: true,
                duration: const Duration(milliseconds: 300),
              ),
            );
          },
          iconType: IconType.continueAnimation,
          height: 60,
          width: 60,
          color: Colors.amber,
          animateIcon: AnimateIcons.skipBackwards,
        ),
        title: AnimatedTextKit(
          isRepeatingAnimation: false,
          animatedTexts: [
            TyperAnimatedText(
              "Back to Login Page",
              textStyle: GoogleFonts.silkscreen(fontSize: 14),
            ),
          ],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SlideInLeft(
                delay: Duration(milliseconds: start),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 35,
                    vertical: 10,
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all<Color>(Colors.white)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatBotScreen(
                            authToken: widget.authToken,
                            username: widget.username,
                          ),
                        ),
                        /* MaterialPageRoute(
                          builder: (context) => ChatBotScreen(
                            username: widget.username,
                          ),
                        ),*/
                      );
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 100,
                          backgroundImage: AssetImage(
                            'lib/assets/gifs/texting2.gif',
                          ),
                        ),
                        AnimatedTextKit(
                          isRepeatingAnimation: false,
                          animatedTexts: [
                            TyperAnimatedText(
                              "Chat with TalkBuddy",
                              textStyle:
                                  GoogleFonts.silkscreen(color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              SlideInLeft(
                delay: Duration(milliseconds: start),
                child: Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 35,
                    vertical: 10,
                  ),
                  child: TextButton(
                    style: ButtonStyle(
                        overlayColor:
                            MaterialStateProperty.all<Color>(Colors.white)),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SpeakWithTalkBuddy()),
                      );
                    },
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 100,
                          backgroundImage: AssetImage(
                            'lib/assets/gifs/talking.gif',
                          ),
                        ),
                        AnimatedTextKit(
                          isRepeatingAnimation: false,
                          animatedTexts: [
                            TyperAnimatedText(
                              "Talk with TalkBuddy",
                              textStyle: GoogleFonts.silkscreen(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                        AnimatedTextKit(
                          isRepeatingAnimation: false,
                          animatedTexts: [
                            TyperAnimatedText(
                              "Coming soon...",
                              textStyle:
                                  GoogleFonts.silkscreen(color: Colors.black),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
