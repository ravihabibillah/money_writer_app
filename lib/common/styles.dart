import 'package:flutter/material.dart';

ThemeData buildTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    colorScheme: _colorScheme,
    primaryColor: primaryColor,
    scaffoldBackgroundColor: secondaryTextColor,
    cardColor: backgroundWhite,
    errorColor: errorRed,
    buttonTheme: const ButtonThemeData(
      colorScheme: _colorScheme,
      textTheme: ButtonTextTheme.normal,
    ),
    primaryIconTheme: _customIconTheme(base.iconTheme),
    textTheme: _buildTextTheme(base.textTheme),
    primaryTextTheme: _buildTextTheme(base.primaryTextTheme),
    iconTheme: _customIconTheme(base.iconTheme),
  );
}

IconThemeData _customIconTheme(IconThemeData original) {
  return original.copyWith(color: secondaryDarkColor);
}

TextTheme _buildTextTheme(TextTheme base) {
  return base
      .copyWith(
        caption: base.caption!.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          letterSpacing: defaultLetterSpacing,
        ),
        button: base.button!.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          letterSpacing: defaultLetterSpacing,
        ),
      )
      .apply(
        fontFamily: 'Rubik',
        displayColor: secondaryColor,
        bodyColor: secondaryColor,
      );
}

const ColorScheme _colorScheme = ColorScheme(
  primary: primaryColor,
  primaryVariant: secondaryDarkColor,
  secondary: secondaryColor,
  secondaryVariant: secondaryLightColor,
  surface: primaryLightColor,
  background: primaryLightColor,
  error: errorRed,
  onPrimary: secondaryColor,
  onSecondary: secondaryColor,
  onSurface: secondaryColor,
  onBackground: secondaryColor,
  onError: backgroundWhite,
  brightness: Brightness.light,
);

const Color primaryColor = Color(0xFFb1ddd9);
const Color primaryLightColor = Color(0xFFe4ffff);
const Color primaryDarkColor = Color(0xFF81aba8);

const Color secondaryColor = Color(0xFF00796b);
const Color secondaryLightColor = Color(0xFF48a999);
const Color secondaryDarkColor = Color(0xFF004c40);

const Color primaryTextColor = Color(0xFF000000);
const Color secondaryTextColor = Color(0xFFe0f2f1);

const Color infoBlue = Color(0xFF039be5);
const Color errorRed = Color(0xFFC5032B);
const Color backgroundWhite = Colors.white;

const defaultLetterSpacing = 0.03;
