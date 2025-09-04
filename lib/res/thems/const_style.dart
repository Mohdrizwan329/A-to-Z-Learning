import 'package:flutter/material.dart';
import 'const_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ConstStyle {
  // Headings
  static TextStyle heading1 = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: ConstColors.textColorDark,
  );
  static TextStyle heading2 = GoogleFonts.poppins(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: ConstColors.textColorWhit,
  );
  static TextStyle heading3 = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: ConstColors.textColor,
  );
  static TextStyle heading4 = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: ConstColors.textColor,
  );
  static TextStyle heading5 = GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: ConstColors.textColor,
  );
  static TextStyle heading7 = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: ConstColors.primaryRed,
  );
  static TextStyle heading8 = GoogleFonts.poppins(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: ConstColors.textColor,
  );
  static const TextStyle smallText1 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,

    color: ConstColors.textFieldBorderColor,
  );
  static const TextStyle buttonStyle = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: ConstColors.buttonTextColor,
  );
  static const TextStyle heading6 = TextStyle(
    fontSize: 22,
    color: ConstColors.primaryBlue,
    fontWeight: FontWeight.w600,
  );
  static const TextStyle smallText2 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,

    color: ConstColors.buttonBorderColor,
  );
  static const TextStyle smallText3 = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,

    color: ConstColors.textColorWhit,
  );
  // otp page text
  static TextStyle otpPageText = TextStyle(
    fontSize: 23,
    fontWeight: FontWeight.w500,
    color: ConstColors.textColor,
  );

  // Small text
  static const TextStyle smallText = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,

    color: ConstColors.textFieldBorderColor,
  );

  // Link or clickable text
  static const TextStyle linkText = TextStyle(
    fontSize: 14,
    color: ConstColors.primaryBlue,
    fontWeight: FontWeight.w600,
  );

  // Buttons

  // home page

  static const TextStyle cardTextStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w500,
    color: ConstColors.textColor,
  );
  static const TextStyle homeHeading1 = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: ConstColors.textFieldBorderColor,
  );
  static const TextStyle homeHeading2 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: ConstColors.textColor,
  );
  // card screen
  static const TextStyle cardPageText = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.w500,
    color: ConstColors.textColor,
  );
  static const TextStyle cardPageText1 = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: ConstColors.textColor,
  );
  // Error
  static const TextStyle errorText = TextStyle(
    fontSize: 13,
    color: ConstColors.errorColor,
  );
}
