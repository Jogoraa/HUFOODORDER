import 'package:flutter/material.dart';

void customSnackbar({
  BuildContext? context,
  Color? backgroundColor,
  Color? messageColor,
  Color? closTextColor,
  String? message,
  String? closLabel,
  Duration? duration,
  double? margin,
}) {
  ScaffoldMessenger.of(context!).showSnackBar(
    SnackBar(
      backgroundColor: backgroundColor ?? Colors.green.shade700,
      closeIconColor: messageColor ?? Colors.white,
      dismissDirection: DismissDirection.horizontal,
      behavior: SnackBarBehavior.floating,
      margin: EdgeInsets.all(margin ?? 25),
      content: Text(
        message ?? '',
        style: TextStyle(
          color: messageColor ?? Colors.black, // Adjust text color as needed
          fontSize: 16,
        ),
      ),
      duration: duration ?? Duration(seconds: 5),
      action: SnackBarAction(
        label: closLabel ?? 'Ok',
        textColor: closTextColor ?? Colors.white,
        backgroundColor: backgroundColor ?? Colors.red,
        onPressed: () {},
      ),
    ),
  );
}
