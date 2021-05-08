import 'dart:collection';

import 'package:blood_bank_app/utils/utils.dart';
import 'package:blood_bank_app/views/donate.dart';
import 'package:blood_bank_app/views/request.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class userData extends StatefulWidget {
  var _uid;
  userData(var uid) {
    this._uid = uid;
  }

  @override
  _userDataState createState() => _userDataState();
}

class _userDataState extends State<userData> {
  final databaseRef = FirebaseDatabase.instance.reference();

  Future<dynamic> _fetchData(Map userData) async {
    var _box = await Hive.openBox('userDataBox');
    _box.putAll(userData);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
      top: false,
      child: Scaffold(
        body: StreamBuilder(
          stream: databaseRef.child("users/${widget._uid}/").onValue,
          builder: (context, AsyncSnapshot<Event> dataSnap) {
            if (dataSnap.connectionState == ConnectionState.active) {
              if (dataSnap.hasData) {
                Map<dynamic, dynamic> dataMap = dataSnap.data.snapshot.value;
                return CustomScrollView(
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
                      flexibleSpace: FlexibleSpaceBar(
                        titlePadding: EdgeInsets.zero,
                        title: SizedBox(
                          height: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.arrow_back,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                  Text(
                                    "${dataMap["firstname"].toString()} ${dataMap["lastname"].toString()}",
                                    style: GoogleFonts.openSans(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ],
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
                    SliverToBoxAdapter(
                      child: SizedBox(
                        height: 10,
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Donate()),
                                      );
                                    },
                                    child: Material(
                                      elevation: 10,
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xffff5f6d),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        height: 50,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Donate blood",
                                              style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => Request()),
                                      );
                                    },
                                    child: Material(
                                      elevation: 10,
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xffff5f6d),
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        height: 50,
                                        child: Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                              "Request blood",
                                              style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                        childCount: 1,
                      ),
                    )
                  ],
                );
              } else if (dataSnap.hasError) {
                return Center(child: Text(dataSnap.error.toString()));
              } else {
                return Center(child: Text("No Data."));
              }
            } else if (dataSnap.connectionState != ConnectionState.active) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text("Loading."),
                ],
              );
            } else {
              return Text("Error loading application.");
            }
          },
        ),
      ),
    );
  }
}
