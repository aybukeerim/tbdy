import 'dart:async';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:talkbuddyai/screens/home/home_page.dart';

class WelcomePage extends StatefulWidget {
  @override
  State<WelcomePage> createState() {
    return _WelcomePageState();
  }
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    startSplashScreen();
  }

  startSplashScreen() {
    var duration = const Duration(seconds: 3);
    return Timer(duration, () {
      Navigator.of(context).push(
        PageTransition(
          type: PageTransitionType.rightToLeftWithFade,
          child: HomePage(),
          // isIos: true,
          duration: const Duration(milliseconds: 300),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: const BoxDecoration(
          color: Color(0xfff5cc18),
          image: DecorationImage(
            image: AssetImage('lib/assets/images/talkbuddymain.png'),
            fit: BoxFit.contain,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "UnNaturalAI",
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  fontFamily: "Raleway"),
            ),
            SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
