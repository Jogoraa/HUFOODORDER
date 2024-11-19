import 'dart:io';

import 'package:buyers/constants/custome_button.dart';
import 'package:buyers/models/user_model.dart';
import 'package:buyers/providers/app_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Ensure you have the necessary import for 'tr'
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart'; // Import the lottie package

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? image;
  TextEditingController name = TextEditingController();

  void takePicture() async {
    XFile? value = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (value != null) {
      setState(() {
        image = File(value.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(
      context,
    );

    return Scaffold(
      appBar: AppBar(title: Text('profileSettings'.tr)),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        children: [
          // Profile Image
          image == null
              ? CupertinoButton(
                  onPressed: () {
                    takePicture();
                  },
                  child: Lottie.asset(
                    'images/scanlicence.json', // Replace with the path to your Lottie animation file
                    height: 50,
                    width: 50,
                  ),
                )
              : CircleAvatar(
                  radius: 50,
                  backgroundImage: FileImage(
                    image!,
                  ),
                ),
          const SizedBox(height: 12),
          // Full Name Input Field
          TextFormField(
            decoration: InputDecoration(
              filled: true,
              hintText: 'Full Name',
            ),
          ),
          const SizedBox(height: 12),
          // Email Input Field
          TextFormField(
            controller: name,
            decoration: InputDecoration(
              filled: true,
              hintText: 'Email',
            ),
          ),
          const SizedBox(height: 12),
          // Update Button
          SizedBox(
            child: CustomButton(
              onPressed: () async {
                UserModel userModel = appProvider.getUserInformation.copyWith(
                  name: name.text,
                );
                appProvider.updateUserInfoFirebase(context, userModel, image);
              },
              title: 'update'.tr,
            ),
          ),
        ],
      ),
    );
  }
}
