import 'package:animated_icon/animated_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';

class RecordAndSend extends StatefulWidget {
  final String username;
  final String authToken;

  RecordAndSend({Key? key, required this.username, required this.authToken})
      : super(key: key);

  @override
  _RecordAndSendState createState() => _RecordAndSendState();
}

class _RecordAndSendState extends State<RecordAndSend> {
  FlutterSoundRecorder _soundRecorder = FlutterSoundRecorder();
  String _filePath = '';
  String _responseMessage = '';
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _initFilePath();
    _soundRecorder.openRecorder();
  }

  @override
  void dispose() {
    _soundRecorder.closeRecorder();
    super.dispose();
  }

  Future<String> _initFilePath() async {
    Directory appDocDir =
        await getTemporaryDirectory(); // Uygulama geçici dizini
    return '${appDocDir.path}/recorded_audio.aac'; // Kaydedilecek ses dosyasının yolu
  }

  Future<void> _startRecording() async {
    try {
      _filePath = await _initFilePath(); // Dosya yolu oluştur ve bekle
      await _soundRecorder.startRecorder(toFile: _filePath);
      setState(() {
        _isRecording = true;
      });
    } catch (err) {
      print('Kayıt başlatılamadı: $err');
    }
  }

  Future<void> _stopRecordingAndSend() async {
    try {
      String url = 'http://10.1.1.225:8002/message/'; // API'nin adresi
      var file = File(_filePath);
      var stream = http.ByteStream(file.openRead());
      var length = await file.length();

      var request = http.MultipartRequest('POST', Uri.parse(url));
      var multipartFile = http.MultipartFile('audio', stream, length,
          filename: _filePath.split('/').last);
      request.files.add(multipartFile);

      var response = await request.send();
      if (response.statusCode == 200) {
        // Başarılı bir şekilde yanıt alındığında
        var responseBody = await response.stream.bytesToString();
        setState(() {
          _responseMessage = responseBody; // API'den gelen metin mesajını sakla
        });
      } else {
        print(
            'Ses dosyası gönderilirken hata oluştu: ${response.reasonPhrase}');
      }
    } catch (err) {
      print('Ses dosyası gönderilirken hata oluştu: $err');
    } finally {
      await _soundRecorder.stopRecorder();
      setState(() {
        _isRecording = false;
      });
    }
  }

  Future<void> _sendAudioToAPI() async {
    try {
      String url = 'http://10.1.1.225:8002/message/';
      var fileBytes = File(_filePath).readAsBytesSync();
      String base64Audio = base64Encode(fileBytes);

      var requestBody = jsonEncode({
        "user": widget.username,
        "data": base64Audio,
        "who": "mobil",
        "data_format": "audio"
      });

      var response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: requestBody,
      );

      if (response.statusCode == 200) {
        var responseBody = jsonDecode(response.body);
        setState(() {
          _responseMessage =
              responseBody['send_data']; // API'den gelen metin mesajını sakla
        });
      } else {
        print(
            'Ses dosyası gönderilirken hata oluştu: ${response.reasonPhrase}');
      }
    } catch (err) {
      print('Ses dosyası gönderilirken hata oluştu: $err');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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
          Expanded(
            child: ListView(
              children: <Widget>[
                ListTile(
                  //title: Text('API Yanıtı:'),
                  subtitle:
                      Text(_responseMessage), // API'den gelen metin mesajı
                ),
              ],
            ),
          ),
          _isRecording
              ? Text('Kaydediliyor...')
              : ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.amber),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: _startRecording,
                  child: Text('Start Record',
                      style: TextStyle(color: Colors.black)),
                ),
          SizedBox(height: 20),
          _isRecording
              ? ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(Colors.amber),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  onPressed: _stopRecordingAndSend,
                  child: Text('Stop Record and Send',
                      style: TextStyle(color: Colors.black)),
                )
              : Container(),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(Colors.amber),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            onPressed: _sendAudioToAPI,
            child: Text('Send to API', style: TextStyle(color: Colors.black)),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
