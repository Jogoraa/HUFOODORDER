import 'package:buyers/constants/constants.dart';
import 'package:buyers/constants/custom_routes.dart';
import 'package:buyers/constants/custom_snackbar.dart';
import 'package:buyers/constants/custom_text.dart';
import 'package:buyers/constants/custome_button.dart';
import 'package:buyers/controllers/firebase_auth_helper.dart';
import 'package:buyers/screens/phone_auth_screen.dart';
import 'package:buyers/screens/sign_up.dart';
import 'package:buyers/widgets/bottom_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/utils.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuthHelper _authHelper = FirebaseAuthHelper();
  bool isShowPassword = false;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> handleGoogleSignIn() async {
    try {
      await _authHelper.signInWithGoogle();
      Routes.instance.pushAndRemoveUntil(
        widget: CustomBottomBar(),
        context: context,
      );
    } catch (e) {
      print('Error signing in with Google: $e');
    }
  }

  Future<void> handleForgotPassword() async {
    String emailValue = email.text.trim();

    if (emailValue.isNotEmpty) {
      try {
        await _authHelper.sendPasswordResetEmail(emailValue);
        print('Password reset email sent successfully');

        customSnackbar(
          context: context,
          backgroundColor: Colors.green.shade700,
          messageColor: Colors.white,
          message: 'Password reset email sent successfully',
          closLabel: 'Ok',
          closTextColor: Colors.white,
          duration: Duration(seconds: 5),
          margin: 25,
        );
      } catch (e) {
        print('Error sending password reset email: $e');
        // Handle errors when sending reset password email.

        customSnackbar(
          context: context,
          backgroundColor: Colors.red,
          messageColor: Colors.white,
          message: 'Error sending password reset email',
          closLabel: 'Ok',
          closTextColor: Colors.white,
          duration: Duration(seconds: 5),
          margin: 25,
        );
      }
    } else {
      print('Email is required for password reset.');
      // Handle the case where the email field is empty.

      customSnackbar(
        context: context,
        backgroundColor: Colors.red,
        messageColor: Colors.white,
        message: 'Email is required for password reset',
        closLabel: 'Ok',
        closTextColor: Colors.white,
        duration: Duration(seconds: 5),
        margin: 25,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 25),
            child: Column(
              children: [
                text(title: 'login'.tr, size: 30, color: Colors.blue),
                Container(
                  height: 200,
                  child: Image.asset('images/food-delivery.png'),
                ),
                SizedBox(height: 20),
                Container(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        color: Colors.transparent,
                        child: CupertinoButton(
                          onPressed: () {
                            handleGoogleSignIn();
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/icons/google1.png',
                                width: 30,
                                height: 30,
                              ),
                              FittedBox(
                                  child: text(
                                color: Colors.black,
                                title: 'Google sign in',
                                size: 16,
                              )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.transparent,
                        child: CupertinoButton(
                          onPressed: () {
                            Routes.instance.push(
                                widget: PhoneAuthScreen(), context: context);
                          },
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/icons/phone.png',
                                width: 30,
                                height: 30,
                              ),
                              FittedBox(
                                  child: text(
                                      color: Colors.black,
                                      title: 'Phone sign in',
                                      size: 16)),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: email,
                  decoration: InputDecoration(
                    hintText: 'email'.tr,
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                ),
                SizedBox(height: 12),
                TextFormField(
                  controller: password,
                  obscureText: isShowPassword,
                  decoration: InputDecoration(
                    hintText: 'password'.tr,
                    prefixIcon: Icon(
                      Icons.lock,
                      color: Colors.black,
                    ),
                    suffixIcon: CupertinoButton(
                      onPressed: () {
                        setState(() {
                          isShowPassword = !isShowPassword;
                        });
                      },
                      child: Icon(
                        isShowPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                CustomButton(
                  title: 'login'.tr,
                  color: Colors.green,
                  onPressed: () async {
                    bool isValidate =
                        loginValidation(email.text, password.text);
                    if (isValidate) {
                      try {
                        bool isLogged = await _authHelper.login(
                            email.text, password.text, context);
                        if (isLogged) {
                          Routes.instance.pushAndRemoveUntil(
                              widget: CustomBottomBar(), context: context);
                          Navigator.of(context, rootNavigator: true).pop();
                        }
                      } catch (e) {
                        print('Error during login: $e');
                        // Handle the login error, show a message, or take other actions.
                      }
                    }
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                CustomButton(
                  title: 'Forgot Password',
                  color: Colors.orange,
                  onPressed: () {
                    handleForgotPassword();
                  },
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Text('noAccount'.tr),
                ),
                SizedBox(
                  height: 20,
                ),
                Center(
                  child: Card(
                    child: CupertinoButton(
                      onPressed: () {
                        Routes.instance
                            .push(widget: const SignUp(), context: context);
                      },
                      child: text(
                          title: 'createAccount'.tr,
                          size: 20,
                          color: Colors.blue.shade900),
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
