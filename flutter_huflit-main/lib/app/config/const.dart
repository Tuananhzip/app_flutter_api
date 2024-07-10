import 'package:flutter/material.dart';

const String urlLogo = "assets/images/hlphone_logo.png";
const String urlBackground = "assets/images/background.jpg";
const String urlBackgroundProfile = "assets/images/background_profile.jpg";
const String urlUserDefault =
    "https://static.vecteezy.com/system/resources/previews/024/983/914/original/simple-user-default-icon-free-png.png";
SizedBox spaceHeight({int x = 1}) => SizedBox(height: 16.0 * (x < 1 ? 1 : x));
SizedBox spaceWidth({int x = 1}) => SizedBox(width: 16.0 * (x < 1 ? 1 : x));
final ThemeData myTheme = ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blueAccent,
    background: Colors.white,
  ),
  buttonTheme: const ButtonThemeData(
    buttonColor: Colors.blueAccent,
    textTheme: ButtonTextTheme.primary,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
      foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.all<Color>(Colors.blueAccent),
      side: MaterialStateProperty.all<BorderSide>(
        const BorderSide(color: Colors.blueAccent),
      ),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    fillColor: Colors.white,
  ),
);
