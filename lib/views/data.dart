import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:blood_bank_app/utils/style.dart';
import 'package:blood_bank_app/utils/utils.dart';
import 'package:blood_bank_app/views/registration.dart';
import 'package:blood_bank_app/views/userData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
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
        // initial: AdaptiveThemeMode.system,
        initial: savedThemeMode ?? AdaptiveThemeMode.system,
        builder: (theme, darkTheme) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: theme,
          darkTheme: darkTheme,
          home: MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _hidePass = true;
  bool _success;
  String _userEmail;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final Future<FirebaseApp> _fireInit = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return FutureBuilder(
      future: _fireInit,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Icon(Icons.error),
            ),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            body: SingleChildScrollView(
              child: Container(
                width: size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        ClipPath(
                          clipper: DrawClip(),
                          child: Container(
                            height: size.height / 2,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: [
                                  Color(0xffff5f6d),
                                  Color(0xffffc371)
                                ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight)),
                          ),
                        ),
                        Container(
                          height: size.height / 3,
                          width: double.infinity,
                          child: Image(
                            image: AssetImage('assets/lottie/blood-bank.png'),
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.1),
                            child: Text(
                              "SIGN IN",
                              style: GoogleFonts.openSans(
                                  color: Color(0xffff5f6d),
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: size.width * 0.1),
                          child: IconButton(
                            icon: Icon(
                              Icons.format_paint_rounded,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) => Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        AdaptiveTheme.of(context).setLight();
                                      },
                                      child: Text("Light Theme"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        AdaptiveTheme.of(context).setDark();
                                      },
                                      child: Text("Dark Theme"),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        AdaptiveTheme.of(context).setSystem();
                                      },
                                      child: Text("System Theme (Android 10+)"),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    ),
                    Form(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.1, vertical: 10),
                            child: TextFormField(
                              controller: _emailController,
                              decoration: InputDecoration(
                                hintText: 'Email Address',
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.1, vertical: 10),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: _hidePass,
                              decoration: InputDecoration(
                                hintText: 'Password',
                                suffixIcon: InkWell(
                                  onTap: _togglePasswordView,
                                  child: Icon(Icons.visibility_rounded),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 15, horizontal: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 240),
                      child: Text(
                        "Forgot Password?",
                        style: GoogleFonts.openSans(
                          color: Colors.grey[500],
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size.width * 0.1, vertical: 10),
                      child: TextButton(
                        onPressed: () async {
                          try {
                            UserCredential userCredential = await FirebaseAuth
                                .instance
                                .signInWithEmailAndPassword(
                                    email: _emailController.text,
                                    password: _passwordController.text);
                            if (userCredential != null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Welcome back!")));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        userData(userCredential.user.uid)),
                              );
                            }
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                      content: Text(
                                          "No user found for that email.")));
                            } else if (e.code == 'wrong-password') {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                  content: Text(
                                      "Wrong password provided for that user.")));
                            }
                          }
                        },
                        child: Material(
                          elevation: 10,
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xffff5f6d),
                                borderRadius: BorderRadius.circular(8)),
                            height: 50,
                            child: Center(
                              child: Text(
                                "SIGN IN",
                                style: GoogleFonts.openSans(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Text(
                        "Don't have an account?",
                        style: GoogleFonts.openSans(
                            fontSize: 18,
                            color: Colors.grey,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Center(
                      child: TextButton(
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.openSans(
                              fontSize: 18,
                              color: Color(0xffff5f6d),
                              fontWeight: FontWeight.bold),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Registration()),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }

  void _togglePasswordView() {
    setState(
      () {
        _hidePass = !_hidePass;
      },
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
