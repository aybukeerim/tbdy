import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talkbuddyai/screens/dashboard/dashboard_with_bottom_bar.dart';
import 'firebase_options.dart';
import 'screens/welcome/welcome_page.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var access_token = prefs.getString('access_token');
  var username = prefs.getString('username');

  print(access_token);
  print(username);
  runApp(MaterialApp(
      home: access_token == null
          ? MyApp()
          : BottomBar(
              username: username!,
              authToken: access_token,
              selectedIndex: 0,
            )));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      title: 'TalkBuddy',
      theme: ThemeData(
        primaryColor: Colors.yellow,
        primarySwatch: Colors.yellow,
      ),
      home: WelcomePage(),
    );
  }
}
