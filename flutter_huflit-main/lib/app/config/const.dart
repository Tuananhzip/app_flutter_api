import 'package:flutter/material.dart';

const String urlNoImage = "assets/images/no_image.png";
const String urlLogo = "assets/images/hlphone_logo.png";
const String urlBackground = "assets/images/background.jpg";
const String urlBackgroundProfile =
    "https://img.freepik.com/free-vector/abstract-classic-blue-screensaver_23-2148421853.jpg";
const String urlUserDefault =
    "https://static.vecteezy.com/system/resources/previews/024/983/914/original/simple-user-default-icon-free-png.png";
const List<String> listImage = [
  "https://mir-s3-cdn-cf.behance.net/project_modules/max_3840_webp/34b5bf180145769.6505ae7623131.jpg",
  "https://daitinmobile.com/wp-content/uploads/2024/04/SEA_iPhone_15_Pro_Sep23_Web_Banner_Pre-Avail_1280x457_FFH-BuyNow_2.jpg",
  "https://www.xtsmart.vn/vnt_upload/product/09_2023/banner_iphone_15_pro_max_5_1_3.jpg",
  "https://www.apple.com/newsroom/images/2023/09/apple-unveils-iphone-15-pro-and-iphone-15-pro-max/tile/Apple-iPhone-15-Pro-lineup-hero-230912.jpg.landing-big_2x.jpg",
];
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
TextStyle styleVerySmall({Color color = Colors.black}) {
  return TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: color,
  );
}

TextStyle styleSmall({Color color = Colors.black}) {
  return TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: color,
  );
}

TextStyle styleMedium({Color color = Colors.black, double size = 24}) {
  return TextStyle(
    fontSize: size,
    fontWeight: FontWeight.bold,
    color: color,
  );
}
