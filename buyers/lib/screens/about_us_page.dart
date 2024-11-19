import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About HU-Food Order App',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'HU-Food Order App is your go-to platform for ordering delicious food from a variety of restaurants. With a user-friendly interface and a wide range of culinary options, we aim to make your dining experience enjoyable and hassle-free.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Text(
              'Contact Us:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text('Email: info@hufood.com'),
            Text('Phone: +1 123-456-7890'),
            SizedBox(height: 16),
            Text(
              'Follow Us on Social Media:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Icon(Icons.facebook),
                SizedBox(width: 8),
                Icon(Icons.telegram_rounded),
                SizedBox(width: 8),
                Icon(Icons.one_x_mobiledata_outlined),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
