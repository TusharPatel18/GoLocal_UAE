// import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class StyleResources{
  static const Color scaffoldBackgroundColor = const Color(0xFFFCFFF9);
  static Color headerBackgroundColor =  Color(0xFF58C705).withAlpha(85);
  //Color(0xFF234f2e) = darkgreen;
  // static Color green =  Color(0xFF234f2e);
  static Color green =  Color(0xFF58C705).withOpacity(0.85);
  //Color(0xFF234f2e) = darkgreen;
  //static Color shadowColor = Color(0xFF234f2e).withOpacity(0.42);
  static Color shadowColor = Color(0xFF64B20B).withOpacity(0.42);
  static Color loginBg = Color(0xFF64B20B).withAlpha(42);
  static Color red = Color(0xFFC70505);

  static Color sideNavItemTextColor = Color(0xFF555555);
  static Color sideNavItemIconColor = Color(0xFF000000);
  static Color bottomNavItemIconColor = Color(0xFF333333);
  //Color(0xFF234f2e) = darkgreen;
  //static Color linkTextColor = Color(0xFF234f2e);
  static Color linkTextColor = Color(0xFF66CA1A);
  static Color Shadow1 = Color(0xFFcccccc);

  static Color bottomNavItemIconColorSelected = green;

  static TextStyle linkTextLinkStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: linkTextColor,
  );

  static TextStyle AppNameTextStyle = GoogleFonts.poppins(
    textStyle: TextStyle(color: linkTextColor,fontSize: 40,fontWeight: FontWeight.bold,
      shadows: [
      Shadow(
        blurRadius: 5.0,
        color: Shadow1,
        offset: Offset(4.0, 4.0),
      ),
    ],
    ),
  );

  static TextStyle SplashScreenTextStyle = GoogleFonts.poppins(
    textStyle: TextStyle(color: linkTextColor,fontSize: 30,fontWeight: FontWeight.bold,
      shadows: [
      Shadow(
        blurRadius: 5.0,
        color: Shadow1,
        offset: Offset(4.0, 4.0),
      ),
    ],
    ),
  );

  static TextStyle sideNavItemTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: sideNavItemTextColor,
  );

  static TextStyle sideNavUserNameTextStyle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.w500,
    color: green,
  );

  static TextStyle sideNavUserPhoneTextStyle = TextStyle(
    fontSize: 12,
    color: sideNavItemTextColor,
  );

  static TextStyle bottomNavItemTextStyle = sideNavUserPhoneTextStyle;
  static TextStyle categoryTitleStyle = sideNavUserPhoneTextStyle.copyWith(color: Colors.black87);

  static TextStyle bottomNavItemTextSelectedStyle = TextStyle(
    fontSize: 12,
    color: green,
  );

  static TextStyle homeHeaderTextStyle = TextStyle(
    fontSize: 15,
    color: sideNavItemTextColor,
    fontWeight: FontWeight.bold,
  );

  static TextStyle homeHeaderLinkTextStyle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.black,
  );

  static TextStyle cardTitleStyle =  TextStyle(
      color: green,
      fontWeight: FontWeight.bold,
      fontSize: 15
  );

  static TextStyle buttonFontStyle =  TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 20
  );
  static TextStyle accountTabStyleActive =  TextStyle(
      fontWeight: FontWeight.bold,
      color: StyleResources.green
  );

  static TextStyle accountTabStyle = TextStyle(
      fontWeight: FontWeight.normal,
      color: StyleResources.sideNavItemTextColor
  );
}