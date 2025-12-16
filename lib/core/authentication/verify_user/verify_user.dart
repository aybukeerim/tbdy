import 'package:animated_icon/animated_icon.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:metaballs/metaballs.dart';
import 'package:page_transition/page_transition.dart';
import 'package:talkbuddyai/screens/home/home_page.dart';
import 'package:talkbuddyai/screens/login/login_screen.dart';
import 'package:talkbuddyai/shared/colors.dart';

class PhoneAuthScreen extends StatefulWidget {
  @override
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _smsController = TextEditingController();
  String _verificationId = "";
  String _errorMessageVerify = "";

  Future<void> _verifyPhone() async {
    verificationCompleted(AuthCredential phoneAuthCredential) async {
      await FirebaseAuth.instance.signInWithCredential(phoneAuthCredential);
      // Giriş başarılı, işlemleri yapabilirsiniz.
    }

    verificationFailed(FirebaseAuthException authException) {
      print('Phone number verification failed. Code: ${authException.code}');
      // Doğrulama başarısız.
    }

    codeSent(String verificationId, [int? forceResendingToken]) async {
      _verificationId = verificationId;
      // Telefon numarasına doğrulama kodu gönderildi.
    }

    codeAutoRetrievalTimeout(String verificationId) {
      _verificationId = verificationId;
      // Otomatik zaman aşımı gerçekleşti.
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: _phoneNumberController.text,
      timeout: const Duration(seconds: 60),
      verificationCompleted: verificationCompleted,
      verificationFailed: verificationFailed,
      codeSent: codeSent,
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    );
    if (_phoneNumberController.text.isEmpty) {
      setState(() {
      });
    } else {
      setState(() {
        _showButton = false; // Butonun görünürlüğünü kapat
        _showFields = false;
      });
    }
  }

  Future<void> _signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      // Giriş başarılı, işlemleri yapabilirsiniz.
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    } catch (e) {
      print("Failed to sign in: $e");
      // Giriş başarısız.
    }
    if (_smsController.text.isEmpty) {
      setState(() {
        _errorMessageVerify = 'Please enter a verify code';
      });
    } else {
      setState(() {
        _errorMessageVerify = '';
      });
    }
  }

  OutlineInputBorder myinputborder() {
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
        color: Colors.orangeAccent.shade100,
        width: 3,
      ),
    );
  }

  OutlineInputBorder myfocusborder() {
    return const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
      borderSide: BorderSide(
        color: Colors.yellow,
        width: 3,
      ),
    );
  }

  int colorEffectIndex = 0;
  bool _showButton = true;
  bool _showFields = true;
  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 40,
            child: AnimateIcon(
              key: UniqueKey(),
              onTap: () {
                Navigator.of(context).pushReplacement(
                  PageTransition(
                    type: PageTransitionType.leftToRightWithFade,
                    child: HomePage(key: Key("")),
                    duration: const Duration(milliseconds: 300),
                  ),
                );
              },
              iconType: IconType.onlyIcon,
              height: 70,
              width: 70,
              color: Colors.orange,
              animateIcon: AnimateIcons.skipBackwards,
            ),
          ),
          IgnorePointer(
            ignoring: _showButton,
            child: Metaballs(
              effect: colorsAndEffects[colorEffectIndex].effect,
              glowRadius: 1,
              glowIntensity: 0.6,
              maxBallRadius: 50,
              minBallRadius: 20,
              metaballs: 30,
              color: Colors.grey,
              gradient: LinearGradient(
                  colors: colorsAndEffects[colorEffectIndex].colors,
                  begin: Alignment.bottomRight,
                  end: Alignment.topLeft),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedTextKit(
                isRepeatingAnimation: false,
                animatedTexts: [
                  TyperAnimatedText(
                    "First,\nverify the phone number used on this device...",
                    textStyle: GoogleFonts.silkscreen(),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              _showFields
                  ? Column(
                      children: [
                        Card(
                          elevation: 0,
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            controller: _phoneNumberController,
                            decoration: InputDecoration(
                              errorText: _errorMessageVerify.isNotEmpty
                                  ? _errorMessageVerify
                                  : null,
                              labelText: "Phone Number",
                              hintText: "+905555555555",
                              labelStyle: GoogleFonts.silkscreen(),
                              border: myinputborder(),
                              enabledBorder: myinputborder(),
                              focusedBorder: myfocusborder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        _showButton
                            ? ElevatedButton(
                                onPressed: _verifyPhone,
                                child: const Text('Send Verification Code'),
                              )
                            : const SizedBox.shrink(),
                      ],
                    )
                  : Column(
                      children: [
                        Card(
                          elevation: 0,
                          child: TextField(
                            keyboardType: TextInputType.number,
                            controller: _smsController,
                            decoration: InputDecoration(
                              errorText: _errorMessageVerify.isNotEmpty
                                  ? _errorMessageVerify
                                  : null,
                              labelText: "Verify code",
                              labelStyle: GoogleFonts.silkscreen(),
                              border: myinputborder(),
                              enabledBorder: myinputborder(),
                              focusedBorder: myfocusborder(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16.0),
                        ElevatedButton(
                          onPressed: _signInWithPhoneNumber,
                          child: const Text('Log In'),
                        ),
                      ],
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
