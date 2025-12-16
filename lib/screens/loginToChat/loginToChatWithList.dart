import 'dart:convert';
import 'package:animated_icon/animated_icon.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talkbuddyai/core/api_env/api_env.dart';
import 'package:talkbuddyai/screens/chat/speakOut/soa.dart';
import 'package:talkbuddyai/screens/dashboard/dashboard_card_widget.dart';
import 'package:talkbuddyai/screens/login/login_screen.dart';
import 'package:http/http.dart' as http;
import 'package:talkbuddyai/shared/progress_bar.dart';
import 'package:translator/translator.dart';
import 'package:voice_assistant/voice_assistant.dart';
import '../chat/chat_page.dart';

class LoginToChatWithList extends StatefulWidget {
  final String username;
  final String authToken;

  const LoginToChatWithList(
      {Key? key, required this.username, required this.authToken});

  @override
  State<LoginToChatWithList> createState() => _LoginToChatWithListState();
}

class _LoginToChatWithListState extends State<LoginToChatWithList>
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
  String translatedText = '';
  String hintText = 'Enter Text';
  String text = '';
  TextEditingController txtController = TextEditingController();

  void clearText() {
    setState(() {
      text = '';
      txtController.text = '';
      translatedText = '';
    });
  }

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
        actions: [SizedBox()],
      ),
      endDrawer: Expanded(
        child: SizedBox(
          height: 200,
          child: Drawer(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            autocorrect: false,
                            controller: txtController,
                            style: Theme.of(context).textTheme.bodyLarge,
                            decoration: InputDecoration(
                              hintText: hintText,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onChanged: (text) async {
                              setState(() {
                                if (text.isEmpty) {
                                  translatedText = '';
                                } else {
                                  text
                                      .translate(from: 'auto', to: 'en')
                                      .then((translation) {
                                    setState(() {
                                      translatedText = translation.text;
                                    });
                                  });
                                }
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            clearText();
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.amber,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                          ),
                          child: const Text("Clean"),
                        ),
                      ],
                    ),
                    if (translatedText.isNotEmpty)
                      const Divider(
                        height: 15,
                      ),
                    if (translatedText.isNotEmpty)
                      Text(
                        translatedText,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    if (translatedText.isNotEmpty)
                      Text(
                        "Buraya cümle önerileri gelecek",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SampleLinearPage(),
                SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatBotScreen(
                          authToken: widget.authToken,
                          username: widget.username,
                        ),
                      ),
                    );
                  },
                  child: DashboardCardWidget(
                      title: "Chat with TalkBuddy",
                      subtitle:
                          "Exploring different topics broadens our horizons and sparks intriguing conversations. Whatever the subject, let's delve into it together and exchange thoughts!",
                      image: 'lib/assets/images/texting.jfif',
                      context: context),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RecordAndSend(
                                authToken: widget.authToken,
                                username: widget.username,
                              )),
                    );
                  },
                  child: DashboardCardWidget(
                      title: "Talk with TalkBuddy",
                      subtitle:
                          "Exploring topics broadens horizons and sparks engaging conversations. Let's discuss and exchange ideas together! We can also talk verbally if you prefer.",
                      image: 'lib/assets/images/speak.jfif',
                      context: context),
                ),
                InkWell(
                  onTap: () {
                  /*  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => TranslatedList(
                                authToken: widget.authToken,
                                username: widget.username,
                              )),
                    );*/
                  },
                  child: DashboardCardWidget(
                      title: "Psychology",
                      subtitle:
                          "Psychology is the scientific study of the mind and behavior, aiming to understand and improve human life quality. If you need more information or wish to discuss, I’m here to help. ",
                      image: 'lib/assets/images/psk2.jfif',
                      context: context),
                ),
                DashboardCardWidget(
                    title: "History",
                    subtitle:
                        "History examines humanity's past to understand societies, events, and culture, aiming to grasp their impact on our present. Need more info or want to chat? I'm here!",
                    image: 'lib/assets/images/histroy.jfif',
                    context: context),
                DashboardCardWidget(
                    title: "historical artifacts",
                    subtitle:
                        "Exploring different works broadens our horizons and sparks intriguing conversations. Whatever the work may be, let's discuss and exchange ideas together! If you'd like, we can start talking right away.",
                    image: 'lib/assets/images/tarih.jfif',
                    context: context),
                DashboardCardWidget(
                    title: "Travel",
                    subtitle:
                        "Crafting travel plans ignites excitement and opens doors to new adventures. Whether it's exploring distant lands or discovering hidden gems, let's map out our journey together!",
                    image: 'lib/assets/images/travel.jfif',
                    context: context),
                DashboardCardWidget(
                    title: "Business English",
                    subtitle:
                        "Exploring various business topics enhances our understanding and fosters insightful discussions. Whether it's marketing, finance, or management, let's delve into it together and exchange insights!",
                    image: 'lib/assets/images/buseng.jfif',
                    context: context),
                DashboardCardWidget(
                    title: "Education",
                    subtitle:
                        "Education shapes the future and empowers individuals for progress. By understanding learning methods and fostering inclusivity, we ensure quality education for all. Curious about strategies or initiatives? Let's discuss!",
                    image: 'lib/assets/images/egitim.jfif',
                    context: context),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
