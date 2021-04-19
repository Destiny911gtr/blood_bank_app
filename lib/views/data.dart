import 'package:blood_bank_app/views/userData.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipPath(
                      clipper: DrawClip(),
                      child: Container(
                        height: size.height / 3,
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
                        image: AssetImage('assets/lottie/blood-bank.png'),
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: size.width * 0.1),
                  child: Text(
                    "SIGN IN",
                    style: GoogleFonts.mukta(
                        color: Color(0xffff5f6d),
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.1, vertical: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        fillColor: Colors.grey[200],
                        hintText: 'Email Address',
                        filled: true),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.1, vertical: 10),
                  child: TextFormField(
                    decoration: InputDecoration(
                        border:
                            UnderlineInputBorder(borderSide: BorderSide.none),
                        fillColor: Colors.grey[200],
                        hintText: 'Password',
                        suffixIcon: Icon(Icons.remove_red_eye),
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                        filled: true),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 210),
                  child: Text(
                    "Forgot Password?",
                    style: GoogleFonts.mukta(
                        color: Colors.grey[500],
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.1, vertical: 10),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => userData()),
                      );
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
                          style: GoogleFonts.mukta(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    "Don,t have an account?",
                    style: GoogleFonts.mukta(
                        fontSize: 18,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500),
                  ),
                ),
                Center(
                  child: Text(
                    "Sign Up",
                    style: GoogleFonts.mukta(
                        fontSize: 18,
                        color: Color(0xffff5f6d),
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DrawClip extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    //TODO: implement getClip
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width * 0.1, size.height - 50);
    path.lineTo(size.width * 0.9, size.height - 50);
    path.lineTo(size.width, size.height - 100);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldCliper) {
    return true;
  }
}
