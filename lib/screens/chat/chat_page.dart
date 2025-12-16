import 'dart:convert';
import 'package:animated_icon/animated_icon.dart';
import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http;
import 'package:talkbuddyai/core/db/db.dart';
import 'package:talkbuddyai/models/db_model/db_message_model.dart';

class ChatBotScreen extends StatefulWidget {
  final String username;
  final String authToken;

  ChatBotScreen({Key? key, required this.username, required this.authToken})
      : super(key: key);

  @override
  _ChatBotScreenState createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  List<Message> messages = [];
  List<Map<String, dynamic>> dialogueList = [];
  final TextEditingController _dataController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  FlutterTts flutterTts = FlutterTts();
  bool speaking = false;

  @override
  void initState() {
    super.initState();
    fetchMessages();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  Future<void> fetchMessages() async {
    List<Message> fetchedMessages =
        await MessageDatabase.instance.getAllMessages();
    setState(() {
      messages = fetchedMessages;
    });
  }

  Future<http.Response> _getResponse(String text) async {
    final String apiUrl = "http://10.1.1.225:8002/message/";
    final String data = text;
    final msg = jsonEncode(
      {
        "user": widget.username,
        "data": data,
        "who": "mobile",
        "data_format": "text"
      },
    );

    var response = await http.post(Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'}, body: msg);

    return response;
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
    return Scaffold(
      body: Container(
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
          children: <Widget>[
            AppBar(
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
              title: Row(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        AssetImage('lib/assets/images/welcometologin.png'),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Text(
                    'TalkBuddy',
                    style: TextStyle(
                      fontFamily: 'Cera Pro',
                    ),
                  ),
                ],
              ),
              backgroundColor: Colors.transparent,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () async {
                    bool confirm = await showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Clear Chat"),
                          content: Text(
                              "Are you sure you want to delete all messages from this device?"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false);
                              },
                              child: Text("No"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                              child: Text("Yes"),
                            ),
                          ],
                        );
                      },
                    );

                    if (confirm == true) {
                      await MessageDatabase.instance.clearAllMessages();
                      setState(() {
                        messages.clear();
                      });
                    }
                  },
                  child: Text(
                    'Clean Chat',
                    style: TextStyle(color: Colors.brown.shade200),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  final Widget messageWidget =
                      messages[index].sender == widget.username
                          ? _buildOutgoingMessage(messages[index].message)
                          : _buildIncomingMessage(messages[index].message);

                  return messageWidget;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _dataController,
                      decoration: InputDecoration(
                        hintText: 'Message',
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.amber, width: 1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Colors.amber, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.send,
                      color: Colors.amber,
                    ),
                    onPressed: () {
                      _sendMessage(_dataController.text);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> speech(String message) async {
    flutterTts.setLanguage('en-US');
    flutterTts.isLanguageInstalled("en-US");
    flutterTts.setSpeechRate(0.5);
    flutterTts.setVolume(0.5);
    flutterTts.setPitch(1);

    await flutterTts.speak(message);
  }

  void stopSpeech() {
    flutterTts.stop();
  }

  bool isPlaying = false;

  Widget _buildIncomingMessage(String message) {
    return Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.centerLeft,
      nip: BubbleNip.leftTop,
      color: Colors.blueGrey.shade100,
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              if (isPlaying) {
                stopSpeech();
              } else {
                speech(message);
              }
              setState(() {
                isPlaying = !isPlaying;
              });
            },
            icon: Icon(
              isPlaying ? Icons.volume_off : Icons.volume_down,
              color: Colors.amber,
            ),
          ),
          Expanded(
            child: Text(
              message,
              maxLines: 5000,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutgoingMessage(String message) {
    return Bubble(
      margin: BubbleEdges.only(top: 10),
      alignment: Alignment.centerRight,
      nip: BubbleNip.rightTop,
      color: Colors.amber,
      child: Text(message),
    );
  }

  void _sendMessage(String text) async {
    String sender = widget.username;
    String receiver = 'ai';

    // Gönderilen mesajı veritabanına kaydet
    Message sentMessage = Message(
      sender: sender,
      receiver: receiver,
      message: text,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );
    await MessageDatabase.instance.insertMessage(sentMessage);

    setState(() {
      messages.add(sentMessage);
      //_scrollToBottom();
    });

    _dataController.clear();

    // Cevabı al ve ekrana ekle
    await Future.delayed(Duration(seconds: 3));
    await _receiveMessage(sentMessage);
  }

  Future<void> _receiveMessage(Message sentMessage) async {
    var response = await _getResponse(sentMessage.message);

    if (response.statusCode == 200) {
      var responseData = jsonDecode(response.body);
      var messageText = responseData['send_data'];

      Message receivedMessage = Message(
        sender: "web",
        receiver: sentMessage.sender,
        message: messageText,
        timestamp: DateTime.now().millisecondsSinceEpoch,
      );
      await MessageDatabase.instance.insertMessage(receivedMessage);

      setState(() {
        messages.add(receivedMessage);
      });
    } else {}
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }
}
