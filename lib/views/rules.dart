import 'package:blood_bank_app/utils/globals.dart';
import 'package:blood_bank_app/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

bool _skipRules = userData.get('rules_shown', defaultValue: false);

class Rules extends StatelessWidget {
  const Rules({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SafeArea(
      top: false,
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Color(0xffff5f6d),
              ),
              backgroundColor: Color(0xffff5f6d),
              automaticallyImplyLeading: false,
              pinned: true,
              snap: true,
              floating: true,
              expandedHeight: 160.0,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xffff5f6d), Color(0xffffc371)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: FlexibleSpaceBar(
                  titlePadding: EdgeInsets.zero,
                  title: SizedBox(
                    height: 55,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Rules before donating",
                            style: GoogleFonts.openSans(
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  background: ClipPath(
                    clipper: DrawBox(),
                    child: Container(
                      height: size.height,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Color(0xffff5f6d),
                            Color(0xffffc371),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 20,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                // ignore: missing_return
                (BuildContext context, int index) {
                  if (userData.get('logged_in', defaultValue: false)) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Before proceeding, please ensure you have the following conditions satisfied:",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context)
                                    .style
                                    .copyWith(fontSize: 15),
                                children: const <TextSpan>[
                                  TextSpan(text: '\n• You'),
                                  TextSpan(
                                      text: ' haven\'t',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          ' had any major surgery in 6 months.\n'),
                                  TextSpan(text: '\n• You'),
                                  TextSpan(
                                      text: ' haven\'t',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          ' taken any antibiotics within the 3 days of allotted date.\n'),
                                  TextSpan(
                                      text:
                                          '\n• Pregnant women, women who are breastfeeding, have a child under 1 years of age or have a miscarriage'),
                                  TextSpan(
                                      text:
                                          ' should wait for at least 6 months before donating.\n',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: '\n• You'),
                                  TextSpan(
                                      text: ' are not',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          ' undergoing treatment for cancer, diabetes, malaria, heart disease, jaundice (type B, C) or other similar disease\n'),
                                  TextSpan(text: '\n• You'),
                                  TextSpan(
                                      text: ' do not have',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(
                                      text:
                                          ' tuberculosis, AIDS, gynecology, typhoid, liver disease and rabies vaccine.\n'),
                                  TextSpan(
                                      text:
                                          '\nDo not donate blood with an empty stomach or immediately after eating.',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontStyle: FontStyle.italic)),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 30),
                            child: Row(
                              children: [
                                Text("Don't show me this again"),
                                DoNotShow(),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Center(
                      child: Text(
                        "Please log in to continue.",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    );
                  }
                },
                childCount: 1,
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (userData.get('logged_in', defaultValue: false)) {
              userData.put('rules_shown', _skipRules);
              Navigator.pushNamed(context, '/donate');
            } else {
              Navigator.of(context).pop();
            }
          },
          child: Icon(
            Icons.check,
            size: 30.0,
          ),
        ),
      ),
    );
  }
}

class DoNotShow extends StatefulWidget {
  const DoNotShow({Key key}) : super(key: key);

  @override
  _DoNotShowState createState() => _DoNotShowState();
}

class _DoNotShowState extends State<DoNotShow> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: _skipRules,
      onChanged: (bool value) {
        setState(() {
          _skipRules = value;
        });
      },
    );
  }
}
