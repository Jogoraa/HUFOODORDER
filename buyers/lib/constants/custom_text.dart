import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import the google_fonts package

Widget text({
  BuildContext? context,
  String? title,
  double? size,
  Color? color,
  FontWeight? fontWeight,
  TextOverflow? overflow,
}) {
  return Text(
    title!,
    style: GoogleFonts.poppins(
      // Replace 'poppins' with the font you want to use
      color: color,
      fontWeight: fontWeight ?? FontWeight.w600,
      fontSize: size ?? 14,
    ),
    overflow: overflow ?? TextOverflow.ellipsis,
  );
}
