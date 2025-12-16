import 'package:animated_background/animated_background.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:metaballs/metaballs.dart';
import 'package:page_transition/page_transition.dart';
import 'package:talkbuddyai/shared/colors.dart';
import '../login/login_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  int colorEffectIndex = 0;
  bool _showButton = false;
  AnimationController? _animationController;
  Animation<double>? _animationTween;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 30),
      vsync: this,
    );
    _animationTween =
        Tween(begin: 20.0, end: 20.0).animate(_animationController!);
    _animationController!.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Metaballs(
            effect: colorsAndEffects[colorEffectIndex].effect,
            glowRadius: 1,
            glowIntensity: 0.6,
            maxBallRadius: 50,
            minBallRadius: 20,
            metaballs: 40,
            color: Colors.grey,
            gradient: LinearGradient(
                colors: colorsAndEffects[colorEffectIndex].colors,
                begin: Alignment.bottomRight,
                end: Alignment.topLeft),
            child: AnimatedBackground(
              behaviour: RandomParticleBehaviour(
                options: const ParticleOptions(
                  baseColor: Colors.yellow,
                  spawnOpacity: 0.0,
                  opacityChangeRate: 0.25,
                  minOpacity: 0.1,
                  maxOpacity: 0.4,
                  spawnMinSpeed: 30.0,
                  spawnMaxSpeed: 70.0,
                  spawnMinRadius: 7.0,
                  spawnMaxRadius: 15.0,
                  particleCount: 40,
                ),
              ),
              vsync: this,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('lib/assets/images/talkbuddymain.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: AnimatedTextKit(
                      isRepeatingAnimation: false,
                      onFinished: () {
                        setState(() {
                          _showButton = true;
                        });
                      },
                      animatedTexts: [
                        TyperAnimatedText(
                          "Easy access to information with ChatGPT's integration with Whatsapp\n\nEasy to use\nImproving your language skills\nConstant access\nRegister and get started using.\n\nSo Let's Start!",
                          textStyle: GoogleFonts.silkscreen(),
                          speed: const Duration(milliseconds: 30),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (_showButton)
            Positioned(
              bottom: 100,
              left: 60,
              right: 60,
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomCenter,
                        colors: <Color>[
                          Colors.yellow,
                          Colors.yellow.shade300,
                        ]),
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(30),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black54.withOpacity(0.4),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3),
                      ),
                    ]),
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.transparent,
                      disabledForegroundColor:
                          Colors.transparent.withOpacity(0.38),
                      disabledBackgroundColor:
                          Colors.transparent.withOpacity(0.12),
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () => Navigator.of(context).push(
                          PageTransition(
                            type: PageTransitionType.rightToLeftWithFade,
                            child: LoginScreen(),
                            //PhoneAuthScreen(),
                            // isIos: true,
                            duration: const Duration(milliseconds: 300),
                          ),
                        ),
                    child: Text(
                      "Get Started",
                      style: GoogleFonts.silkscreen(fontSize: 16),
                    )
                    //  AnimatedTextKit(
                    //    isRepeatingAnimation: false,
                    //    animatedTexts: [
                    //      TyperAnimatedText(
                    //        "Get Started",
                    //        textStyle: GoogleFonts.silkscreen(fontSize: 16),
                    //      ),
                    //    ],
                    //  ),
                    ),
              ),
            ),
        ],
      ),
    );
  }
}
