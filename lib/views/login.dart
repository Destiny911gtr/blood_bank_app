import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:blood_bank_app/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var userData = Hive.box('userData');
  bool _hidePass = true;
  bool _loading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
                              colors: [Color(0xffff5f6d), Color(0xffffc371)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight)),
                    ),
                  ),
                  Container(
                    height: size.height / 3,
                    width: double.infinity,
                    child: Image(
                      image: AssetImage('assets/images/blood-bank.png'),
                    ),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: size.width * 0.1),
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
                    padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                    child: IconButton(
                      icon: Icon(
                        Icons.format_paint_rounded,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Center(
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  AdaptiveTheme.of(context)
                                                      .setLight();
                                                },
                                                child: Text("Light Theme"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  AdaptiveTheme.of(context)
                                                      .setDark();
                                                },
                                                child: Text("Dark Theme"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  AdaptiveTheme.of(context)
                                                      .setSystem();
                                                },
                                                child: Text(
                                                    "System Theme (Android 10+)"),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Row(
                                                mainAxisSize: MainAxisSize.max,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Image.asset(
                                                    'assets/images/paint-roller.png',
                                                    color: Colors.black12,
                                                    height: 120,
                                                    width: 120,
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  )
                ],
              ),
              Form(
                child: AutofillGroup(
                  onDisposeAction: AutofillContextAction.commit,
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.1, vertical: 10),
                        child: TextFormField(
                          controller: _emailController,
                          autofillHints: [AutofillHints.email],
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
                          autofillHints: [AutofillHints.password],
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
              ),
              Padding(
                padding: EdgeInsets.only(right: size.width * 0.1),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                      splashColor: Colors.white12,
                      onTap: () => Navigator.of(context).pushNamed('/home'),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 8.0),
                        child: Text(
                          "Anonymous login",
                          style: GoogleFonts.openSans(
                            color: Colors.grey[500],
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: size.width * 0.1, vertical: 10),
                child: TextButton(
                  onPressed: () async {
                    if (!_loading) {
                      setState(() {
                        _loading = true;
                      });
                      try {
                        UserCredential _userCredential = await FirebaseAuth
                            .instance
                            .signInWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text);
                        print('User is signed in!');
                        userData.put('logged_in', true);
                        userData.put('uid', _userCredential.user.uid);
                        Navigator.of(context).pushReplacementNamed('/home');
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("No user found for that email.")));
                        } else if (e.code == 'wrong-password') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Wrong password provided for that user.")));
                        } else if (e.code == 'network-request-failed') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  "Please check your internet connection.")));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text("Please enter your credentials.")));
                        }
                      }
                      setState(() {
                        _loading = false;
                      });
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
                        child: _signingIn(),
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
                    Navigator.of(context).pushNamed('/register');
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _signingIn() {
    if (!_loading) {
      return Text(
        "SIGN IN",
        style: GoogleFonts.openSans(
            color: Colors.white, fontWeight: FontWeight.bold),
      );
    } else {
      return Theme(
        data: ThemeData(accentColor: Colors.white),
        child: Container(child: CircularProgressIndicator()),
      );
    }
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
