import 'dart:convert';
import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:talkbuddyai/shared/user_card.dart';

class Prompts extends StatefulWidget {
  final String username;
  final String authToken;

  const Prompts({super.key, required this.username, required this.authToken});

  @override
  _PromptsState createState() => _PromptsState();
}

class _PromptsState extends State<Prompts> {
  Map<String, dynamic>? data_user;

  @override
  void initState() {
    super.initState();

    fetchPrompt();
  }

  Future<void> fetchPrompt() async {
    final response = await http.get(
      Uri.parse('http://10.1.1.225:8002/web/prompts?token=${widget.authToken}'),
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

  void _showPopup(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Text(
                "Name: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              SizedBox(
                width: 6,
              ),
              Text(
                '${data_user![data_user!.keys.toList()[0]]!['name']}',
                style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
              ),
            ],
          ),
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Prompt: ",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
              SizedBox(
                width: 6,
              ),
              Expanded(
                child: Text(
                  '${data_user![data_user!.keys.toList()[0]]!['prompt']}',
                  style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14),
                ),
              ),
            ],
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
        title: Text('Accessible prompts',
            style: GoogleFonts.silkscreen(fontSize: 22)),
        backgroundColor: Colors.transparent,
      ),
      body: data_user == null
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            )
          : Column(
              children: [
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
                      image: AssetImage('lib/assets/images/talkbuddymain.png'),
                      fit: BoxFit.contain,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          _showPopup(context);
                        },
                        child: UserCardWidget(
                            title: 'Name',
                            subtitle:
                                '${data_user![data_user!.keys.toList()[0]]!['name']}'),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
