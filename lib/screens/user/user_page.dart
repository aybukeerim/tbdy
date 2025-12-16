import 'dart:convert';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:talkbuddyai/screens/prompts/prompts.dart';
import 'package:talkbuddyai/screens/used_tips/used_tips.dart';
import 'package:talkbuddyai/shared/user_card.dart';
import 'package:voice_assistant/voice_assistant.dart';
import '../chat_pages/chat_page_list.dart';
import '../translate/translated_list.dart';

class UserInfoPage extends StatefulWidget {
  final String username;
  final String authToken;

  const UserInfoPage(
      {super.key, required this.username, required this.authToken});

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  Map<String, dynamic>? userInfo;
  Map<String, dynamic>? langList;

  @override
  void initState() {
    super.initState();
    fetchUserInfo();
  }

  Future<void> fetchUserInfo() async {
    final response = await http.get(
      Uri.parse('http://10.1.1.225:8002/web/user?token=${widget.authToken}'),
      headers: {
        'Content-Type': 'application/json',
        "authorization": "bearer ${widget.authToken}"
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        userInfo = data['user'];
        langList = data['lang_list'];
      });
    } else {
      throw Exception(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: userInfo == null
          ? Column(
              children: [
                AppBar(
                  title: Text('Profile',
                      style: GoogleFonts.silkscreen(fontSize: 24)),
                  backgroundColor: Colors.transparent,
                ),
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: CircularProgressIndicator(
                    color: Colors.amber,
                  ),
                ),
              ],
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 21,
                  ),
                  Text('Profile', style: GoogleFonts.silkscreen(fontSize: 24)),
                  SizedBox(
                    height: 30,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        colorFilter: ColorFilter.mode(
                          Colors.yellow.withOpacity(0.9),
                          BlendMode.dstOut,
                        ),
                        image:
                            AssetImage('lib/assets/images/talkbuddymain.png'),
                        fit: BoxFit.contain,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        UserCardWidget(
                          title: 'Name',
                          subtitle: '${userInfo!['name']}',
                        ),
                        UserCardWidget(
                          title: 'Phone',
                          subtitle: '${userInfo!['tel']}',
                        ),
                        UserCardWidget(
                          title: 'Email',
                          subtitle: '${userInfo!['email']}',
                        ),
                        UserCardWidget(
                          title: 'Organization',
                          subtitle: '${userInfo!['org']}',
                        ),
                        UserCardWidget(
                          title: 'Main Language',
                          subtitle: '${userInfo!['main_lang']}',
                        ),
                        UserCardWidget(
                          title: 'Learning Language',
                          subtitle: '${userInfo!['learning_lang']}',
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Language List ',
                          style: GoogleFonts.silkscreen(fontSize: 24),
                        ),
                        SizedBox(height: 10),
                        if (langList != null)
                          Column(
                            children: langList!.values
                                .map<Widget>(
                                  (lang) => UserCardWidget(
                                    title: '${lang['language']}',
                                    subtitle: '${lang['code']}',
                                  ),
                                )
                                .toList(),
                          ),
                        SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UsedTips(
                                  authToken: widget.authToken,
                                  username: widget.username,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.amber,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 8),
                                  Text(
                                    "used tips",
                                    style: GoogleFonts.silkscreen(
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  AnimatedTextKit(
                                    isRepeatingAnimation: true,
                                    animatedTexts: [
                                      TyperAnimatedText(
                                        "------>",
                                        textStyle: GoogleFonts.silkscreen(),
                                        speed: const Duration(milliseconds: 30),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Prompts(
                                        authToken: widget.authToken,
                                        username: widget.username,
                                      )),
                            );
                          },
                          child: Card(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.amber,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 8),
                                  Text(
                                    "Accessible prompts",
                                    style: GoogleFonts.silkscreen(
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  AnimatedTextKit(
                                    isRepeatingAnimation: true,
                                    animatedTexts: [
                                      TyperAnimatedText(
                                        "------>",
                                        textStyle: GoogleFonts.silkscreen(),
                                        speed: const Duration(milliseconds: 30),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ChatPageList(
                                        authToken: widget.authToken,
                                        username: widget.username,
                                      )),
                            );
                          },
                          child: Card(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.amber,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 8),
                                  Text(
                                    "All messages",
                                    style: GoogleFonts.silkscreen(
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  AnimatedTextKit(
                                    isRepeatingAnimation: true,
                                    animatedTexts: [
                                      TyperAnimatedText(
                                        "------>",
                                        textStyle: GoogleFonts.silkscreen(),
                                        speed: const Duration(milliseconds: 30),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TranslatedList(
                                        authToken: widget.authToken,
                                        username: widget.username,
                                      )),
                            );
                          },
                          child: Card(
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                color: Colors.amber,
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.grey,
                                    spreadRadius: 5,
                                    blurRadius: 7,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(width: 8),
                                  Text(
                                    "Translated Words",
                                    style: GoogleFonts.silkscreen(
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  AnimatedTextKit(
                                    isRepeatingAnimation: true,
                                    animatedTexts: [
                                      TyperAnimatedText(
                                        "------>",
                                        textStyle: GoogleFonts.silkscreen(),
                                        speed: const Duration(milliseconds: 30),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
