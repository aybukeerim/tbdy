import 'dart:convert';
import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:talkbuddyai/shared/user_card.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class UsedTips extends StatefulWidget {
  final String username;
  final String authToken;

  const UsedTips({super.key, required this.username, required this.authToken});

  @override
  _UsedTipsState createState() => _UsedTipsState();
}

class _UsedTipsState extends State<UsedTips> {
  Map<String, dynamic>? data_user;

  @override
  void initState() {
    super.initState();

    fetchUsedTips();
  }

  Future<void> fetchUsedTips() async {
    String token = widget.authToken;
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    int userId = decodedToken["id"];
    final response = await http.get(
      Uri.parse(
          'http://10.1.1.225:8002/web/used_tips?token=${widget.authToken}&user_id=$userId'),
      headers: {
        'Content-Type': 'application/json',
        "authorization": "bearer ${widget.authToken}"
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);

      setState(() {
        ///*
        /// data_user değişkenine data['id'] değeri atanmış, ancak bu, beklendiği gibi bir Map<String, dynamic> değil.
        ///data_user'ın tipi Map<String, dynamic>? olduğu için, data['id'] değeri doğrudan data_user'a atanamaz.
        ///Bunun yerine, data_user'ı güncellemek için data'nın kendisini atamak gerekir.
        ///data_user = data['id']; hatalı bir gösterim

        data_user = data;
      });
      print(data);
    } else {
      throw Exception(response.body);
    }
  }

  void _showPopup(BuildContext context, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: data_user!.entries.toList().reversed.map((entry) {
              String entryId = entry.key;
              Map<String, dynamic> item = entry.value;
              String main_text = item['main_text'];
              String used_tips_text = item['used_tips_text'];

              if (entryId == id) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            "Main Text: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              "$main_text",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Text(
                            "Used Tips: ",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Expanded(
                            child: Text(
                              '$used_tips_text',
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              } else {
                return SizedBox.shrink();
              }
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
        title: Text('used tips', style: GoogleFonts.silkscreen(fontSize: 22)),
        backgroundColor: Colors.transparent,
      ),
      body: data_user == null
          ? Center(
              child: CircularProgressIndicator(
                color: Colors.amber,
              ),
            )
          : Column(
              children: data_user!.entries.toList().reversed.map(
                (entry) {
                  String main_text = entry.value['main_text'];
                  String main_textA = entry.key;
                  return Container(
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
                        GestureDetector(
                          onTap: () {
                            _showPopup(context, '$main_textA');
                          },
                          child: UserCardWidget(
                              title: 'Typo', subtitle: '$main_text'),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  );
                },
              ).toList(),
            ),
    );
  }
}
