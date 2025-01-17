import 'package:admin/constants/routes.dart';
import 'package:admin/views/screens/change_password.dart';
import 'package:admin/views/screens/dashboard_screen.dart';
import 'package:admin/views/screens/login_screen.dart';
import 'package:admin/views/screens/sign_up_screen.dart';
import 'package:admin/views/widgets/custom_side_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sidebarx/sidebarx.dart';

class MainAppScreen extends StatefulWidget {
  @override
  State<MainAppScreen> createState() => _MainAppScreenState();
}

class _MainAppScreenState extends State<MainAppScreen> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);

  final _key = GlobalKey<ScaffoldState>();

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    // Navigate to login screen after signing out
    Routes.instance.pushAndRemoveUntil(widget: LoginScreen(), context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return Scaffold(
          key: _key,
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 10, 116, 255),
            automaticallyImplyLeading: false,
            titleTextStyle: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 30),
            titleSpacing: 3,
            title: Text(getTitleByIndex(_controller.selectedIndex)),
            actions: [
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == 'Signup') {
                    Routes.instance
                        .push(widget: SignupScreen(), context: context);
                  } else if (value == 'changepassword') {
                    Routes.instance
                        .push(widget: ChangePasswordScreen(), context: context);
                  } else if (value == 'logout') {
                    _signOut();
                  }
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem<String>(
                      value: 'Signup',
                      child: Text('Add admin'),
                    ),
                    PopupMenuItem<String>(
                      value: 'changepassword',
                      child: Text('Change Password'),
                    ),
                    PopupMenuItem<String>(
                      value: 'logout',
                      child: Text('Logout'),
                    ),
                  ];
                },
              )
            ],
          ),
          drawer: CustomeSideBar(controller: _controller),
          body: Expanded(
            child: Row(
              children: [
                CustomeSideBar(controller: _controller),
                Expanded(
                  child: Column(
                    children: [
                      _controller == 0 ? SizedBox.fromSize() : Dashboard(),
                      Expanded(
                        child: MainScreens(
                          controller: _controller,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
