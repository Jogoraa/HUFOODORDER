import 'dart:async';

import 'package:buyers/controllers/firebase_auth_helper.dart';
import 'package:buyers/providers/theme_provider.dart';
import 'package:buyers/widgets/bottom_bar.dart';
import 'package:buyers/widgets/language_choice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

// Import added
import '../constants/custom_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _coffeeController;
  bool copAnimated = false;
  bool animateCafeText = false;

  startTimer() {
    Timer(
      const Duration(seconds: 6),
      () async {
        // if the user is already authenticated, send the user to the home screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) {
            // Use Consumer for listening to changes in Provider values
            return Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return StreamBuilder(
                  stream: FirebaseAuthHelper.instance.getAuthChange,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return CustomBottomBar();
                    } else {
                      // if not authenticated, send to the auth screen
                      return LanguageDialog();
                    }
                  },
                );
              },
            );
          }),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _coffeeController = AnimationController(vsync: this);
    _coffeeController.addListener(() {
      if (_coffeeController.value > 0.7) {
        _coffeeController.stop();
        copAnimated = true;
        setState(() {});
        Future.delayed(const Duration(seconds: 1), () {
          animateCafeText = true;
          setState(() {});
        });
      }
    });

    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    _coffeeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFFAC898),
      body: Stack(
        children: [
          // White Container top half
          AnimatedContainer(
            duration: const Duration(seconds: 1),
            height: copAnimated ? screenHeight / 1.9 : screenHeight,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: FractionalOffset(-1.0, 0.0),
                end: FractionalOffset(5.0, -1.0),
                colors: [
                  Color(0xFFFFFFFF),
                  Color.fromARGB(255, 241, 235, 229),
                ],
              ),
              borderRadius: BorderRadius.circular(copAnimated ? 40.0 : 0.0),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Visibility(
                  visible: !copAnimated,
                  child: Lottie.asset(
                    'images/67226-food-app-interaction.json',
                    controller: _coffeeController,
                    onLoaded: (composition) {
                      _coffeeController
                        ..duration = composition.duration
                        ..forward();
                    },
                  ),
                ),
                Visibility(
                  visible: copAnimated,
                  child: Image.asset(
                    'images/image0.png',
                    height: 300.0,
                  ),
                ),
                Center(
                  child: AnimatedOpacity(
                    opacity: animateCafeText ? 1 : 0,
                    duration: const Duration(seconds: 1),
                    child: Text(
                      'Customer FOOD Order App'.toUpperCase(),
                      style: GoogleFonts.lato(
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Text bottom part
          Visibility(visible: copAnimated, child: const _BottomPart()),
        ],
      ),
    );
  }
}

class _BottomPart extends StatelessWidget {
  const _BottomPart({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Find The Food for You',
              style: GoogleFonts.lato(
                fontSize: 27,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 30.0),
            Text(
              'We make it simple to find food for you. '
              'Enter your address and let us do the rest.',
              style: GoogleFonts.lato(
                fontSize: 15,
                fontWeight: FontWeight.normal,
                color: Colors.black.withOpacity(0.8),
                height: 1.5,
              ),
            ),
            const SizedBox(height: 50.0),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Start ".toUpperCase(),
                    style: GoogleFonts.lato(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 25),
                  GestureDetector(
                    onTap: () {
                      Routes.instance.pushAndRemoveUntil(
                        widget: LanguageDialog(),
                        context: context,
                      );
                    },
                    child: Container(
                      height: 85.0,
                      width: 85.0,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.0),
                      ),
                      child: const Icon(
                        Icons.chevron_right,
                        size: 50.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50.0),
          ],
        ),
      ),
    );
  }
}
