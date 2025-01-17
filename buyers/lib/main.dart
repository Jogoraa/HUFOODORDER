// ignore_for_file: prefer_const_constructors

import 'package:buyers/controllers/firebase_auth_helper.dart';
import 'package:buyers/firebase_options.dart';
import 'package:buyers/local_strings.dart';
import 'package:buyers/providers/app_provider.dart';
import 'package:buyers/providers/theme_provider.dart';
import 'package:buyers/screens/cart_screen.dart';
import 'package:chapa_unofficial/chapa_unofficial.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:buyers/splash_screen/splash_screen.dart';
import 'package:buyers/screens/welcome.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Chapa.configure(privateKey: "CHASECK_TEST-gtChIAQQhCK18xGtfMdnMo5RUpsV9iqe");
  // Stripe.publishableKey =
  //     'pk_test_51OFnrbL5s11I9QDMOFtPyDVhgwlglgvExwrsPoeZwvmFJa3hv6kdqMY06muBIWP3OgnqOGeQpMwmzOocYcWECL8k00hpdzUzvM';
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    //  webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    // Set androidProvider to `AndroidProvider.debug`
    androidProvider: AndroidProvider.debug,
  );
  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppProvider(),
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        translations: LocalStrings(),
        locale: Locale('en', 'US'),
        title: 'HU-Food ',
        theme: Provider.of<ThemeProvider>(context).themeData,
        routes: {'/checkoutPage': (context) => const CartScreen()},
        home: StreamBuilder(
            stream: FirebaseAuthHelper.instance.getAuthChange,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SplashScreen();
              } else {
                return Welcome();
              }
            }),
      ),
    );
  }
}
