import 'package:flutter/material.dart';

ThemeData lightThemeData() {
  return ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xffff5f6d),
    primarySwatch: Colors.red,
    accentColor: Color(0xffff5f6d),
    focusColor: Color(0xffff5f6d),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.red,
      selectionHandleColor: Color(0xffff5f6d),
      selectionColor: Color(0xffff5f6d),
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      buttonColor: Color(0xffff5f6d),
      textTheme: ButtonTextTheme.accent,
    ),
    buttonBarTheme: ButtonBarThemeData(
      buttonHeight: 40,
      buttonPadding: EdgeInsets.symmetric(horizontal: 10),
      alignment: MainAxisAlignment.center,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: UnderlineInputBorder(borderSide: BorderSide.none),
      fillColor: Colors.grey[200],
      filled: true,
    ),
    fixTextFieldOutlineLabel: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    snackBarTheme: SnackBarThemeData(
      contentTextStyle: TextStyle(color: Colors.black),
      backgroundColor: Colors.white,
    ),
  );
}

ThemeData darkThemeData() {
  return ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xffff5f6d),
    primarySwatch: Colors.red,
    accentColor: Color(0xffff5f6d),
    focusColor: Color(0xffff5f6d),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.red,
      selectionHandleColor: Color(0xffff5f6d),
      selectionColor: Color(0xffff5f6d),
    ),
    buttonTheme: ButtonThemeData(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      buttonColor: Color(0xffff5f6d),
      textTheme: ButtonTextTheme.accent,
    ),
    buttonBarTheme: ButtonBarThemeData(
      buttonHeight: 40,
      buttonPadding: EdgeInsets.symmetric(horizontal: 10),
      alignment: MainAxisAlignment.center,
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: UnderlineInputBorder(borderSide: BorderSide.none),
      hintStyle: TextStyle(color: Colors.grey),
      fillColor: Colors.grey[1000],
      filled: true,
    ),
    fixTextFieldOutlineLabel: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    snackBarTheme: SnackBarThemeData(
      contentTextStyle: TextStyle(color: Colors.white),
      backgroundColor: Color(-14540254),
    ),
  );
}
