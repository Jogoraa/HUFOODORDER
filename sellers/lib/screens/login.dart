// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sellers/constants/constants.dart';
import 'package:sellers/constants/custom_button.dart';
import 'package:sellers/constants/custom_snackbar.dart';
import 'package:sellers/constants/routes.dart';
import 'package:sellers/constants/theme.dart';
import 'package:sellers/controllers/firebase_auth_helper.dart';
import 'package:sellers/screens/sign_up.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isShowPassword = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  // Function to initiate the password reset process
  // Function to initiate the password reset process
  Future<void> resetPassword(String email) async {
    try {
      await FirebaseAuthHelper.instance.resetPassword(email, context);
      customSnackbar(
        context: context,
        message: 'Password reset email sent. Please check your email.',
      );
    } catch (error) {
      print('Error resetting password: $error');
      customSnackbar(
        context: context,
        message: 'Error resetting password. Please try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 60.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      'Login',
                      style: themeData.textTheme.displayLarge,
                    ),
                    Icon(Icons.login)
                  ],
                ),
                Image.asset('images/seller1.png'),

                TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    hintText: 'E-mail ',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),

                TextFormField(
                  controller: password,
                  obscureText: isShowPassword,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.blue,
                    ),
                    suffixIcon: CupertinoButton(
                      onPressed: () {
                        setState(() {
                          isShowPassword = !isShowPassword;
                        });
                      },
                      child: Icon(
                        Icons.visibility,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                CustomButton(
                  title: 'Login',
                  onPressed: () async {
                    bool isValidate =
                        loginValidation(email.text, password.text);
                    if (isValidate) {
                      bool islogined = await FirebaseAuthHelper.instance
                          .login(email.text, password.text, context);
                      if (islogined) {
                        FirebaseAuthHelper authHelper = FirebaseAuthHelper();
                        authHelper.getHomeScreen();
                      } else {
                        customSnackbar(
                          context: context,
                          message: 'Some error occurred! Please try again!!!',
                        );
                      }
                    }
                  },
                ),

                // Reset Password Button
                CupertinoButton(
                  onPressed: () {
                    resetPassword(email.text);
                  },
                  child: Text(
                    'Reset Password',
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),

                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    'Do not Have An Account',
                    style: themeData.textTheme.bodyLarge,
                  ),
                ),

                Center(
                  child: CupertinoButton(
                    onPressed: () {
                      Routes.instance
                          .push(widget: const SignUp(), context: context);
                    },
                    child: Text(
                      'Create Account',
                      style: TextStyle(
                          color: Color.fromARGB(255, 11, 226, 100),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
