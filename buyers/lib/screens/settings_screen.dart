import 'package:buyers/constants/custom_routes.dart';
import 'package:buyers/screens/edit_profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Title',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SettingsScreen(),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          ListTile(
            title: Text(
              'Notifications',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: Text('Enable or disable notifications'),
            leading: Icon(Icons.notifications),
            onTap: () {
              // Add your logic for handling notifications settings
              // For example, you can navigate to a detailed settings screen
            },
          ),
          ListTile(
            title: Text(
              'Dark Mode',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w500),
            ),
            subtitle: Text('Enable or disable dark mode'),
            leading: Icon(Icons.brightness_4),
            onTap: () {
              // Add your logic for handling dark mode settings
              // For example, you can show a dialog to confirm the change
            },
          ),
          SizedBox(height: 16),
          Text(
            'Account Settings',
            style:
                GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ListTile(
            title: Text(
              'Change Password',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w500),
            ),
            leading: Icon(Icons.lock),
            onTap: () {
              // Add your logic for changing the password
              // For example, you can navigate to a change password screen
            },
          ),
          ListTile(
            title: Text(
              'Edit Profile',
              style: GoogleFonts.poppins(
                  fontSize: 16, fontWeight: FontWeight.w500),
            ),
            leading: Icon(Icons.edit),
            onTap: () {
              Routes.instance.push(
                widget: EditProfile(),
                context: context,
              );
            },
          ),
        ],
      ),
    );
  }
}
