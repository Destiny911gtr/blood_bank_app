import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData lightThemeData() {
  return ThemeData(
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: SharedAxisPageTransitionsBuilder(
          transitionType: SharedAxisTransitionType.vertical,
        ),
        TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
          transitionType: SharedAxisTransitionType.vertical,
        ),
      },
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateColor.resolveWith(
        (states) {
          if (states.contains(MaterialState.selected)) {
            return Color(0xffff5f6d);
          }
          return Colors.grey;
        },
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
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
      hintStyle: GoogleFonts.openSans(color: Colors.grey),
      fillColor: Colors.grey[200],
      filled: true,
    ),
    cardColor: Colors.grey[200],
    fixTextFieldOutlineLabel: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      contentTextStyle: GoogleFonts.openSans(color: Colors.black),
      backgroundColor: Colors.white,
    ),
  );
}

ThemeData darkThemeData() {
  return ThemeData(
    pageTransitionsTheme: PageTransitionsTheme(
      builders: {
        TargetPlatform.android: SharedAxisPageTransitionsBuilder(
          transitionType: SharedAxisTransitionType.vertical,
        ),
        TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
          transitionType: SharedAxisTransitionType.vertical,
        ),
      },
    ),
    checkboxTheme: CheckboxThemeData(
      fillColor: MaterialStateColor.resolveWith(
        (states) {
          if (states.contains(MaterialState.selected)) {
            return Color(0xffff5f6d);
          }
          return Colors.grey;
        },
      ),
    ),
    bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.transparent),
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
      hintStyle: GoogleFonts.openSans(color: Colors.grey),
      fillColor: Colors.grey[1000],
      filled: true,
    ),
    fixTextFieldOutlineLabel: true,
    visualDensity: VisualDensity.adaptivePlatformDensity,
    snackBarTheme: SnackBarThemeData(
      behavior: SnackBarBehavior.floating,
      contentTextStyle: GoogleFonts.openSans(color: Colors.white),
      backgroundColor: Color(-14540254),
    ),
  );
}
