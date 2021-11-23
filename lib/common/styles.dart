import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ThemeData buildTheme() => ThemeData(
      primarySwatch: Pallete.tealToDark,
      appBarTheme: AppBarTheme(
        backgroundColor: Pallete.tealToDark.shade100,
        // This will be applied to the "back" icon
        iconTheme: IconThemeData(color: Pallete.tealToDark.shade900),
        elevation: 0,
        // This will be applied to the action icon buttons that locates on the right side
        actionsIconTheme: IconThemeData(color: Pallete.tealToDark.shade900),
        titleTextStyle: TextStyle(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          color: Pallete.tealToDark.shade900,
        ),
      ),
      iconTheme: const IconThemeData(
        color: Pallete.tealToDark,
      ),
    );

class Pallete {
  static const MaterialColor tealToDark = MaterialColor(
    0xff00796b,
    <int, Color>{
      50: Color(0xffe0f2f1), //10%
      100: Color(0xffb2dfdb), //20%
      200: Color(0xff80cbc4), //30%
      300: Color(0xff4db6ac), //40%
      400: Color(0xff26a69a), //50%
      500: Color(0xff009688), //60%
      600: Color(0xff00897b), //70%
      700: Color(0xff00796b), //80%
      800: Color(0xff00695c), //90%
      900: Color(0xff004d40), //100%
    },
  );
}

// Source : https://dev.to/rohanjsh/custom-swatch-for-material-app-theme-primaryswatch-3kic
