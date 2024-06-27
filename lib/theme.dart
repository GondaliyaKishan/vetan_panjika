import 'package:flutter/material.dart';

class AppThemeData{
  //
  // Dark mode flag
  //
  bool darkMode = false;

  //
  // colors
  //
  Color colorGrey = const Color.fromARGB(255, 209, 210, 205);

  // Color colorPrimary = Color(0xff009688);
  Color colorPrimary = const Color(0xFF24d9d9);
  Color colorCompanion = const Color(0xff374137);
  Color colorCompanion2 = const Color(0xff6fffff);
  Color colorCompanion3 = const Color(0xffb6e9d1);
  Color colorCompanion4 = Colors.green;

  late Color colorBackground;
  late Color colorBackgroundGray;
  late Color colorDefaultText;
  late Color colorBackgroundDialog;
  late MaterialColor primarySwatch;
  List<Color> colorsGradient = [];
  Color colorDarkModeLight = const Color.fromARGB(255, 40, 40, 40); // for dialog background in dark mode

  //
  TextStyle? text10white;
  TextStyle? text12bold;
  TextStyle? text12grey;
  TextStyle? text14;
  TextStyle? text14primary;
  TextStyle? text14purple;
  TextStyle? text14grey;
  TextStyle? text14bold;
  TextStyle? text14boldPimary;
  TextStyle? text14boldWhite;
  TextStyle? text14boldWhiteShadow;
  TextStyle? text16;
  TextStyle? text16white;
  TextStyle? text16bold;
  TextStyle? text16boldPrimary;
  TextStyle? text16boldWhite;
  TextStyle? text18;
  TextStyle? text18white;
  TextStyle? text18boldPrimary;
  TextStyle? text18bold;
  TextStyle? text20;
  TextStyle? text20bold;
  TextStyle? text20boldPrimary;
  TextStyle? text20boldWhite;
  TextStyle? text20negative;
  TextStyle? text22;
  TextStyle? text22primaryShadow;
  TextStyle? pageHeadingBlack;

  changeDarkMode(){
    darkMode = !darkMode;
    init();
  }

  init(){
    if (darkMode) {
      colorBackground = _backgroundDarkColor;
      colorDefaultText = _backgroundColor;
      colorBackgroundGray = Colors.white.withOpacity(0.1);
      primarySwatch = black;
      colorBackgroundDialog = colorDarkModeLight;
      Color _color2 = const Color.fromARGB(80, 80, 80, 80);
      colorsGradient = [_color2, Colors.black];
    } else {
      Color _color2 = Color.fromARGB(80, colorPrimary.red, colorPrimary.green, colorPrimary.blue);
      colorsGradient = [_color2, colorPrimary];
      colorBackgroundDialog = _backgroundColor;
      colorBackgroundGray = Colors.black.withOpacity(0.01);
      colorBackground = _backgroundColor;
      colorDefaultText = _backgroundDarkColor;
      primarySwatch = white;
    }

    text10white = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 10,
    );

    text12bold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      fontSize: 12,
    );

    text12grey = const TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.w400,
      fontSize: 12,
    );

    text14 = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );

    text14primary = TextStyle(
      color: colorPrimary,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );

    text14purple = const TextStyle(
      color: Colors.purple,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );
    text14bold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      fontSize: 14,
    );

    text14boldPimary = TextStyle(
      color: colorPrimary,
      fontWeight: FontWeight.w800,
      fontSize: 14,
    );

    text14grey = const TextStyle(
      color: Colors.grey,
      fontWeight: FontWeight.w400,
      fontSize: 14,
    );

    text14boldWhite = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 14,
    );

    text14boldWhiteShadow = const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w800,
        fontSize: 14,
        shadows: [
          Shadow(
              offset: Offset(1, 1),
              color: Colors.black,
              blurRadius: 1
          ),
        ]
    );

    text16bold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      fontSize: 16,
    );

    text16boldPrimary = TextStyle(
      color: colorPrimary,
      fontWeight: FontWeight.w800,
      fontSize: 16,
    );

    text16boldWhite = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 16,
    );

    text16 = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w400,
      fontSize: 16,
    );

    text16white = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 16,
    );

    text18 = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w400,
      fontSize: 18,
    );

    text18white = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w400,
      fontSize: 18,
    );

    text18boldPrimary = TextStyle(
      color: colorPrimary,
      fontWeight: FontWeight.w800,
      fontSize: 18,
    );

    text18bold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      fontSize: 18,
    );

    text20bold = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w800,
      fontSize: 20,
    );

    text20boldPrimary = TextStyle(
      color: colorPrimary,
      fontWeight: FontWeight.w800,
      fontSize: 20,
    );

    text20 = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w400,
      fontSize: 20,
    );

    text20boldWhite = const TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w800,
      fontSize: 20,
    );

    text20negative = TextStyle(      // text negative color
      color: colorBackground,
      fontWeight: FontWeight.w400,
      fontSize: 20,
    );

    text22 = TextStyle(
      color: colorDefaultText,
      fontWeight: FontWeight.w400,
      fontSize: 20,
    );

    text22primaryShadow = TextStyle(      // text negative color
        color: colorPrimary,
        fontWeight: FontWeight.w800,
        fontSize: 22,
        shadows: const [
          Shadow(
              offset: Offset(1, 1),
              color: Colors.black,
              blurRadius: 1
          ),
        ]
    );

    pageHeadingBlack = const TextStyle(      // text negative color
        color: Colors.black,
        fontSize: 24,
        fontWeight: FontWeight.w600
    );
  }
}

//
// Colors
//
var _backgroundColor = Colors.white;
var _backgroundDarkColor = Colors.black;

const MaterialColor white = MaterialColor(
  0xFFFFFFFF,
  <int, Color>{
    50: Color(0xFFFFFFFF),
    100: Color(0xFFFFFFFF),
    200: Color(0xFFFFFFFF),
    300: Color(0xFFFFFFFF),
    400: Color(0xFFFFFFFF),
    500: Color(0xFFFFFFFF),
    600: Color(0xFFFFFFFF),
    700: Color(0xFFFFFFFF),
    800: Color(0xFFFFFFFF),
    900: Color(0xFFFFFFFF),
  },
);

const MaterialColor black = MaterialColor(
  0xFF000000,
  <int, Color>{
    50: Color(0xFF000000),
    100: Color(0xFF000000),
    200: Color(0xFF000000),
    300: Color(0xFF000000),
    400: Color(0xFF000000),
    500: Color(0xFF000000),
    600: Color(0xFF000000),
    700: Color(0xFF000000),
    800: Color(0xFF000000),
    900: Color(0xFF000000),
  },
);