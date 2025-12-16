import 'dart:convert';
import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:talkbuddyai/shared/user_card.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class TranslatedList extends StatefulWidget {
  final String username;
  final String authToken;

  const TranslatedList(
      {super.key, required this.username, required this.authToken});

  @override
  _TranslatedListState createState() => _TranslatedListState();
}

class _TranslatedListState extends State<TranslatedList> {
  Map<String, dynamic>? data_user;

  @override
  void initState() {
    super.initState();
    fetchTranslatedList();
  }

  Future<void> fetchTranslatedList() async {
    String token = widget.authToken;
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    int userId = decodedToken["id"];
    final response = await http.get(
      Uri.parse(
          'http://10.1.1.225:8002/web/translate?token=${widget.authToken}&user_id=$userId'),
      headers: {
        'Content-Type': 'application/json',
        "authorization": "bearer ${widget.authToken}"
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        data_user = data;
      });
      print(data);
    } else {
      throw Exception(response.body);
    }
  }

  String _formatDate() {
    DateTime dateTime =
        DateTime.parse(data_user![data_user!.keys.toList()[0]]!['create_time']);
    return DateFormat.yMMMd().format(dateTime);
  }

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Message"),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: data_user!.entries.toList().reversed.map((entry) {
              String translate_text = entry.value['translate_text'];
              String text = entry.value['text'];

              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "$translate_text",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "$text",
                      style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Close"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: AnimateIcon(
          key: UniqueKey(),
          onTap: () {
            Navigator.of(context).pop();
          },
          iconType: IconType.onlyIcon,
          height: 60,
          width: 60,
          color: Colors.amber,
          animateIcon: AnimateIcons.skipBackwards,
        ),
        title:
            Text('Translate list', style: GoogleFonts.silkscreen(fontSize: 22)),
        backgroundColor: Colors.transparent,
      ),
      body: data_user![data_user!.keys.toList()] == null
          ? Center(
              child: Container(
                child: Text("There is no word you translated..."),
              ),
            )
          : Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  colorFilter: ColorFilter.mode(
                    Colors.yellow.withOpacity(0.9),
                    BlendMode.dstOut,
                  ),
                  image: AssetImage('lib/assets/images/talkbuddymain.png'),
                  fit: BoxFit.contain,
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 30,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          _showPopup(context);
                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Text(_formatDate()),
                            ),
                            UserCardWidget(
                              title:
                                  '${data_user![data_user!.keys.toList()[0]]!['translate_text']}',
                              subtitle:
                                  '${data_user![data_user!.keys.toList()[0]]!['text']}',
                            ),
                            UserCardWidget(
                              title:
                                  '${data_user![data_user!.keys.toList()[0]]!['main_language']}',
                              subtitle:
                                  '${data_user![data_user!.keys.toList()[0]]!['translated_language']}',
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
