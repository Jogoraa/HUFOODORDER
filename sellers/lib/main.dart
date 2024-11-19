// ignore_for_file: prefer_const_constructors, unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:provider/provider.dart';
import 'package:sellers/constants/theme.dart';
import 'package:sellers/controllers/firebase_auth_helper.dart';
import 'package:sellers/controllers/firebase_firestore_helper.dart';
import 'package:sellers/delivery/delivery_home.dart';
import 'package:sellers/firebase_options.dart';
import 'package:sellers/models/employee_model.dart';
import 'package:sellers/providers/app_provider.dart';
import 'package:sellers/screens/home.dart';
import 'package:sellers/screens/landing_screen.dart';
import 'package:sellers/screens/login.dart';
import 'package:sellers/screens/welcome.dart';
import 'package:sellers/splash_screen/SplashScreen.dart';
import 'package:sellers/widgets/bottom_bar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Stripe.publishableKey =
      'pk_test_51OFnrbL5s11I9QDMOFtPyDVhgwlglgvExwrsPoeZwvmFJa3hv6kdqMY06muBIWP3OgnqOGeQpMwmzOocYcWECL8k00hpdzUzvM';
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseAuthHelper _firestoreAuthHelper = FirebaseAuthHelper();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'HU-Food Order ',
        theme: themeData,
        darkTheme: themeData,
        home: StreamBuilder(
            stream: FirebaseAuthHelper.instance.getAuthChange,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return SplashScreen();
              } else {
                return const Login();
              }
            }),
      ),
    );
  }
}


