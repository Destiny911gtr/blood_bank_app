import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:blood_bank_app/utils/style.dart';
import 'package:blood_bank_app/views/appointments.dart';
import 'package:blood_bank_app/views/book_appointment.dart';
import 'package:blood_bank_app/views/rules.dart';
import 'package:blood_bank_app/views/homepage.dart';
import 'package:blood_bank_app/views/login.dart';
import 'package:blood_bank_app/views/registration.dart';
import 'package:blood_bank_app/views/splash.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await Hive.openBox('userData');
  await Hive.openLazyBox('bankData');
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatelessWidget {
  final AdaptiveThemeMode savedThemeMode;

  const MyApp({Key key, this.savedThemeMode}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AdaptiveTheme(
        light: lightThemeData(),
        dark: darkThemeData(),
        initial: savedThemeMode ?? AdaptiveThemeMode.system,
        builder: (theme, darkTheme) => MaterialApp(
          routes: {
            '/login': (context) => LoginPage(),
            '/register': (context) => Registration(),
            '/home': (context) => HomePage(),
            '/rules': (context) => Rules(),
            '/donate': (context) => BookAppointment(),
            '/appointments': (context) => Appointments(),
          },
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: darkTheme,
          home: SplashScreen(),
        ),
      ),
    );
  }
}
