import 'package:buyers/constants/conformation_dialog.dart';
import 'package:buyers/constants/custom_routes.dart';
import 'package:buyers/constants/custom_text.dart';
import 'package:buyers/controllers/firebase_firestore_helper.dart';
import 'package:buyers/models/user_model.dart';
import 'package:buyers/providers/theme_provider.dart';
import 'package:buyers/screens/about_us_page.dart';
import 'package:buyers/screens/change_password_screen.dart';
import 'package:buyers/screens/home.dart';
import 'package:buyers/screens/order_screen.dart';
import 'package:buyers/screens/settings_screen.dart';
import 'package:buyers/screens/sign_up.dart';
import 'package:buyers/screens/support_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomDrawer extends StatelessWidget {
  final FirebaseFirestoreHelper _firestoreHelper = FirebaseFirestoreHelper();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).listTileTheme;
    User? currentUser = FirebaseAuth.instance.currentUser;
    String? userId = currentUser?.uid;

    return Drawer(
      width: 240,
      child: Container(
        color: theme.tileColor,
        child: SingleChildScrollView(
          child: FutureBuilder<UserModel?>(
            future: userId != null ? _firestoreHelper.getUserInfo() : null,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  height: 40,
                  width: 40,
                  child: Center(child: CircularProgressIndicator()),
                );
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                UserModel userInformation = snapshot.data!;

                return Column(
                  children: [
                    UserAccountsDrawerHeader(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(userInformation.image ?? ''),
                          fit: BoxFit.cover,
                        ),
                        color: Colors.blue.shade400.withOpacity(0.9),
                      ),
                      accountName: Text(
                        userInformation.name ?? '',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: theme.textColor,
                        ),
                      ),
                      accountEmail: Text(
                        userInformation.email ?? '',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: theme.textColor,
                        ),
                      ),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage:
                            NetworkImage(userInformation.image ?? ''),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.light_mode),
                      title: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'theme'.tr,
                            style: GoogleFonts.poppins(
                              color: theme.textColor,
                            ),
                          ),
                          Consumer<ThemeProvider>(
                            builder: (context, themeProvider, child) {
                              bool isLightModeEnabled =
                                  themeProvider.isLightModeEnabled;
                              return IconButton(
                                onPressed: () {
                                  themeProvider.toggleTheme();
                                },
                                icon: Icon(isLightModeEnabled
                                    ? Icons.dark_mode
                                    : Icons.dark_mode_outlined),
                              );
                            },
                          ),
                        ],
                      ),
                      selectedTileColor: theme.selectedTileColor,
                      iconColor: theme.iconColor,
                      textColor: theme.textColor,
                    ),
                    ListTile(
                      onTap: () {
                        Routes.instance.push(
                          widget: Home(),
                          context: context,
                        );
                      },
                      leading: const Icon(Icons.home),
                      title: Text(
                        'home'.tr,
                        style: GoogleFonts.poppins(
                          color: theme.textColor,
                        ),
                      ),
                      selectedTileColor: theme.selectedTileColor,
                      iconColor: theme.iconColor,
                      textColor: theme.textColor,
                    ),
                    ListTile(
                      onTap: () {
                        Routes.instance.push(
                          widget: OrderScreen(),
                          context: context,
                        );
                      },
                      leading: const Icon(Icons.shopping_bag),
                      title: Text(
                        'orders'.tr,
                        style: GoogleFonts.poppins(
                          color: theme.textColor,
                        ),
                      ),
                      selectedTileColor: theme.selectedTileColor,
                      iconColor: theme.iconColor,
                      textColor: theme.textColor,
                    ),
                    ListTile(
                      onTap: () {
                        Routes.instance.push(
                          widget: SettingsScreen(),
                          context: context,
                        );
                      },
                      leading: const Icon(Icons.settings),
                      title: Text(
                        'settings'.tr,
                        style: GoogleFonts.poppins(
                          color: theme.textColor,
                        ),
                      ),
                      selectedTileColor: theme.selectedTileColor,
                      iconColor: theme.iconColor,
                      textColor: theme.textColor,
                    ),
                    ListTile(
                      onTap: () {
                        Routes.instance.push(
                          widget: AboutUsPage(),
                          context: context,
                        );
                      },
                      leading: const Icon(Icons.info_outline),
                      title: Text(
                        'about'.tr,
                        style: GoogleFonts.poppins(
                          color: theme.textColor,
                        ),
                      ),
                      selectedTileColor: theme.selectedTileColor,
                      iconColor: theme.iconColor,
                      textColor: theme.textColor,
                    ),
                    ListTile(
                      onTap: () {
                        Routes.instance.push(
                          widget: SupportScreen(),
                          context: context,
                        );
                      },
                      leading: const Icon(Icons.support),
                      title: Text(
                        'support'.tr,
                        style: GoogleFonts.poppins(
                          color: theme.textColor,
                        ),
                      ),
                      selectedTileColor: theme.selectedTileColor,
                      iconColor: theme.iconColor,
                      textColor: theme.textColor,
                    ),
                    ListTile(
                      onTap: () {
                        Routes.instance.push(
                          widget: ChangePasswordScreen(),
                          context: context,
                        );
                      },
                      leading: const Icon(Icons.change_circle),
                      title: Text(
                        'changePassword'.tr,
                        style: GoogleFonts.poppins(
                          color: theme.textColor,
                        ),
                      ),
                      selectedTileColor: theme.selectedTileColor,
                      iconColor: theme.iconColor,
                      textColor: theme.textColor,
                    ),
                    ListTile(
                      onTap: () {
                        ConfirmationDialog.show(
                          context,
                          'Are you sure to logout',
                          ['yes'.tr, 'no'.tr],
                          [
                            () {
                              FirebaseAuth.instance.signOut();
                              Navigator.of(context).pop();
                            },
                            () {
                              Navigator.pop(context);
                            },
                          ],
                        );
                      },
                      leading: const Icon(Icons.login),
                      title: Text(
                        'logout'.tr,
                        style: GoogleFonts.poppins(
                          color: theme.textColor,
                        ),
                      ),
                      selectedTileColor: theme.selectedTileColor,
                      iconColor: theme.iconColor,
                      textColor: theme.textColor,
                    ),
                    const SizedBox(height: 60),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
