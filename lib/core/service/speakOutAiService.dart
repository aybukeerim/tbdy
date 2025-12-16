import 'dart:convert';
import 'package:http/http.dart' as http;

class Message {
  String user;
  String data;

  Message({required this.user, required this.data});

  Map<String, dynamic> toJson() {
    return {
      'user': user,
      'data': data,
    };
  }
}

class OpenAIService {
  final List<Message> messages = [];

  Future<String> chatGPTAPI(String prompt) async {
    messages.add(Message(user: "905522812973", data: prompt));
    try {
      final res = await http.post(
        Uri.parse("http://10.1.1.225:8002/message/"),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(
          {
            "user": "905522812973",
            "data": messages.map((message) => message.toJson()).toList(),
            "who": "mobile",
            "data_format": "audio"
          },
        ),
      );
      if (res.statusCode == 200) {
        String content = jsonDecode(res.body)['data'];
        content = content.trim();
        return content;
      }
      return 'An internal error occurred';
    } catch (e) {
      return e.toString();
    }
  }
}
