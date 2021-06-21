import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:animations/animations.dart';
import 'package:blood_bank_app/main.dart';
import 'package:blood_bank_app/utils/globals.dart';
import 'package:blood_bank_app/utils/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool showFAB = true;
  String bloodType = 'Not Logged in';

  @override
  void initState() {
    super.initState();
    refreshData().whenComplete(() => refreshList());
  }

  @override
  void dispose() {
    super.dispose();
  }

  void refreshList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return SafeArea(
      top: false,
      child: StreamBuilder(
        stream: bankData.get('bank_list').asStream(),
        builder: (context, AsyncSnapshot dataSnap) {
          Map dataMap = dataSnap.data as Map;
          return ScrollView(dataMap);
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class ScrollView extends StatefulWidget {
  Map<dynamic, dynamic> dataMap;
  ScrollView(Map<dynamic, dynamic> dataMap) {
    this.dataMap = dataMap;
  }

  @override
  _ScrollViewState createState() => _ScrollViewState();
}

class _ScrollViewState extends State<ScrollView>
    with SingleTickerProviderStateMixin {
  var userData = Hive.box('userData');
  String bloodType = 'Not Logged in';
  ScrollController _hideButtonController;
  final databaseRef = FirebaseDatabase.instance.reference();
  bool _isVisible = true;
  AnimationController _controller;

  // ignore: missing_return
  bool get _isAnimationRunningForwardsOrComplete {
    switch (_controller.status) {
      case AnimationStatus.forward:
      case AnimationStatus.completed:
        return true;
      case AnimationStatus.reverse:
      case AnimationStatus.dismissed:
        return false;
    }
  }

  @override
  initState() {
    super.initState();
    _controller = AnimationController(
      value: 1.0,
      duration: const Duration(milliseconds: 150),
      reverseDuration: const Duration(milliseconds: 75),
      vsync: this,
    );
    _hideButtonController = new ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible == true) {
          if (_isAnimationRunningForwardsOrComplete) {
            _controller.reverse();
          }
          setState(() {
            _isVisible = false;
          });
        }
      } else {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisible == false) {
            if (!_isAnimationRunningForwardsOrComplete) {
              _controller.forward();
            }
            setState(() {
              _isVisible = true;
            });
          }
        }
      }
    });
  }

  void refreshList() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder(
        stream: bankData.get('bank_list').asStream(),
        // ignore: missing_return
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          Map dataMap = snapshot.data as Map;
          return RefreshIndicator(
            edgeOffset: 200,
            displacement: 45,
            onRefresh: () {
              return refreshData().whenComplete(() => refreshList());
            },
            child: CustomScrollView(
              controller: _hideButtonController,
              slivers: [
                SliverAppBar(
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarColor: Colors.transparent,
                  ),
                  backgroundColor: Color(0xffff5f6d),
                  automaticallyImplyLeading: false,
                  pinned: true,
                  snap: true,
                  floating: true,
                  expandedHeight: 160.0,
                  forceElevated: false,
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
                        width: size.width,
                        height: 55,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Hi, ${userData.get('fname', defaultValue: 'User')}",
                                            style: GoogleFonts.openSans(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                          Text(
                                            "Blood Type: ${userData.get('blood', defaultValue: 'Not logged in')}",
                                            style: GoogleFonts.openSans(
                                                color: Colors.white,
                                                fontSize: 8),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  InkWell(
                                    child: CircleAvatar(
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                      backgroundColor: Colors.grey[300],
                                      radius: 15,
                                    ),
                                    onTap: () {
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
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                                showModalBottomSheet(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return Padding(
                                                                      padding:
                                                                          const EdgeInsets.all(
                                                                              8.0),
                                                                      child:
                                                                          Card(
                                                                        child:
                                                                            Column(
                                                                          mainAxisSize:
                                                                              MainAxisSize.min,
                                                                          children: [
                                                                            Stack(
                                                                              alignment: Alignment.center,
                                                                              children: [
                                                                                Positioned.fill(
                                                                                  child: Column(
                                                                                    mainAxisAlignment: MainAxisAlignment.end,
                                                                                    children: [
                                                                                      Row(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                                                        children: [
                                                                                          Image.asset(
                                                                                            'assets/images/event.png',
                                                                                            color: Colors.black12,
                                                                                            height: 120,
                                                                                            width: 120,
                                                                                          )
                                                                                        ],
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Container(
                                                                                    height: 300,
                                                                                    child: AppointmentsView(),
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
                                                              child: Text(
                                                                  "Appointments"),
                                                            ),
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                  showModalBottomSheet(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (BuildContext
                                                                            context) {
                                                                      return Padding(
                                                                        padding:
                                                                            const EdgeInsets.all(8.0),
                                                                        child:
                                                                            Card(
                                                                          child:
                                                                              Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
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
                                                                                  ),
                                                                                  Positioned.fill(
                                                                                    child: Column(
                                                                                      mainAxisAlignment: MainAxisAlignment.end,
                                                                                      children: [
                                                                                        Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
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
                                                                child: Text(
                                                                    "Change theme")),
                                                            TextButton(
                                                              onPressed: () {
                                                                showDialog<
                                                                    void>(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return _LogOutDialog();
                                                                  },
                                                                );
                                                              },
                                                              child: Text(
                                                                  "Log out"),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Positioned.fill(
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Image.asset(
                                                                  'assets/images/blood.png',
                                                                  color: Colors
                                                                      .black12,
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
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                      // ignore: missing_return
                      (BuildContext context, int index) {
                    if (snapshot.hasData) {
                      List dataMapKeys = dataMap.keys.toList();
                      return Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: CardView(dataMap, dataMapKeys, index),
                      );
                    } else {
                      return Column(
                        children: [
                          LinearProgressIndicator(),
                        ],
                      );
                    }
                  },
                      childCount:
                          snapshot.hasData ? dataMap.keys.toList().length : 1),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget child) {
          return FadeScaleTransition(
            animation: _controller,
            child: child,
          );
        },
        child: Visibility(
          visible: _controller.status != AnimationStatus.dismissed,
          child: FloatingActionButton(
            onPressed: () => userData.get('rules_shown', defaultValue: false)
                ? Navigator.pushNamed(context, '/donate')
                : Navigator.pushNamed(context, '/rules'),
            child: Icon(FontAwesomeIcons.tint),
          ),
        ),
      ),
    );
  }
}

class CardView extends StatelessWidget {
  CardView(this.dataMap, this.dataMapKeys, this.index);

  final Map dataMap;
  final List dataMapKeys;
  final int index;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Container(
              height: 135,
              width: size.aspectRatio < 1 ? size.width : size.width,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(5),
                    child: Image.asset(
                      imageAssetGenerator(index),
                      color: Colors.black38,
                      colorBlendMode: BlendMode.darken,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          width: size.width,
                          child: MarqueeWidget(
                            direction: Axis.horizontal,
                            child: Text(
                              dataMap[dataMapKeys[index].toString()]
                                      ['hospital_or_bloodbank_name']
                                  .toString(),
                              style: GoogleFonts.openSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                        Container(
                          width: size.width,
                          child: MarqueeWidget(
                            direction: Axis.horizontal,
                            child: Text(
                              "${dataMap[dataMapKeys[index].toString()]['city'].toString()} - ${dataMap[dataMapKeys[index].toString()]['mobile'].toString()}",
                              style: GoogleFonts.openSans(
                                  fontSize: 15, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Container(
                    height: 40,
                    child: Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "AB-",
                                      style: GoogleFonts.openSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      dataMap[dataMapKeys[index].toString()]
                                              ['quantity_abnegative']
                                          .toString(),
                                      style: GoogleFonts.openSans(fontSize: 15),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "AB+",
                                      style: GoogleFonts.openSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      dataMap[dataMapKeys[index].toString()]
                                              ['quantity_abpositive']
                                          .toString(),
                                      style: GoogleFonts.openSans(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        VerticalDivider(
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "A-",
                                      style: GoogleFonts.openSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      dataMap[dataMapKeys[index].toString()]
                                              ['quantity_anegative']
                                          .toString(),
                                      style: GoogleFonts.openSans(fontSize: 15),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "A+",
                                      style: GoogleFonts.openSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      dataMap[dataMapKeys[index].toString()]
                                              ['quantity_apositive']
                                          .toString(),
                                      style: GoogleFonts.openSans(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        VerticalDivider(
                          width: 15,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "B-",
                                      style: GoogleFonts.openSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      dataMap[dataMapKeys[index].toString()]
                                              ['quantity_bnegative']
                                          .toString(),
                                      style: GoogleFonts.openSans(fontSize: 15),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "B+",
                                      style: GoogleFonts.openSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      dataMap[dataMapKeys[index].toString()]
                                              ['quantity_bpositive']
                                          .toString(),
                                      style: GoogleFonts.openSans(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        VerticalDivider(
                          width: 15,
                          color: Colors.grey,
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "O-",
                                      style: GoogleFonts.openSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      dataMap[dataMapKeys[index].toString()]
                                              ['quantity_onegative']
                                          .toString(),
                                      style: GoogleFonts.openSans(fontSize: 15),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "O+",
                                      style: GoogleFonts.openSans(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    Text(
                                      dataMap[dataMapKeys[index].toString()]
                                              ['quantity_opositive']
                                          .toString(),
                                      style: GoogleFonts.openSans(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LogOutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: FittedBox(
          fit: BoxFit.scaleDown,
          child: Center(child: const Text('Are you sure?'))),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            userData.put('logged_in', false);
            userData.put('rules_shown', false);
            userData.delete('fname');
            userData.delete('lname');
            userData.delete('blood');
            userData.delete('age');
            userData.delete('weight');
            userData.delete('uid');
            userData.delete('mobileno');
            bankData.delete('bank_list');
            Navigator.of(context).pop();
            Navigator.pushReplacement(
                context,
                new MaterialPageRoute(
                    builder: (BuildContext context) => new MyApp()));
          },
          child: const Text('Log Out'),
        ),
      ],
    );
  }
}

class AppointmentsView extends StatefulWidget {
  const AppointmentsView({Key key}) : super(key: key);

  @override
  _AppointmentsViewState createState() => _AppointmentsViewState();
}

class _AppointmentsViewState extends State<AppointmentsView>
    with TickerProviderStateMixin {
  final databaseRef = FirebaseDatabase.instance.reference();

  Color cardColor(String data) {
    if (data == 'Accepted') {
      return Colors.greenAccent[700];
    } else if (data == 'Rejected') {
      return Colors.redAccent[400];
    } else {
      return Colors.blueAccent[700];
    }
  }

  String cardIcon(String data) {
    if (data == 'Accepted') {
      return 'assets/images/checked.png';
    } else if (data == 'Rejected') {
      return 'assets/images/remove.png';
    } else {
      return 'assets/images/pending.png';
    }
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController =
        TabController(initialIndex: 0, length: 2, vsync: this);
    return Column(
      children: [
        Container(
          height: 250,
          child: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Requests",
                    style: GoogleFonts.montserrat(
                        color: Color(0xffff5f6d), fontSize: 50),
                  ),
                  StreamBuilder(
                      stream: databaseRef.child("request").onValue,
                      // ignore: missing_return
                      builder: (context, dataSnap) {
                        // print(dataSnap.data.snapshot.value);
                        if (dataSnap.connectionState ==
                            ConnectionState.active) {
                          if (dataSnap.hasData) {
                            List dataMap = dataSnap.data.snapshot.value;
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Container(
                                padding: EdgeInsets.zero,
                                height: 165,
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: dataMap.length,
                                  itemBuilder: (context, int index) {
                                    return Container(
                                      padding: EdgeInsets.zero,
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Card(
                                        color: cardColor(dataMap[index]
                                                ["status"]
                                            .toString()),
                                        elevation: 0,
                                        child: Stack(
                                          children: [
                                            Positioned.fill(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      Image.asset(
                                                        cardIcon(dataMap[index]
                                                                ["status"]
                                                            .toString()),
                                                        color: Colors.black12,
                                                        height: 120,
                                                        width: 120,
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  MarqueeWidget(
                                                    child: Text(
                                                      dataMap[index]
                                                              ["hosp_name"]
                                                          .toString(),
                                                      style:
                                                          GoogleFonts.openSans(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 25,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ),
                                                  MarqueeWidget(
                                                    child: Text(
                                                      "Blood Group: " +
                                                          dataMap[index]
                                                                  ["blood_grp"]
                                                              .toString(),
                                                      style:
                                                          GoogleFonts.openSans(
                                                              fontSize: 20,
                                                              color:
                                                                  Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      MarqueeWidget(
                                                        child: Text(
                                                          dataMap[index]
                                                                  ["status"]
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .openSans(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 40,
                                                                  color: Colors
                                                                      .white),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            );
                          } else {}
                        } else {
                          return Container(
                            height: 165,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                      }),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Donation",
                    style: GoogleFonts.montserrat(
                        color: Color(0xffff5f6d), fontSize: 50),
                  ),
                  StreamBuilder(
                    stream: databaseRef.child("donation").onValue,
                    // ignore: missing_return
                    builder: (context, dataSnap) {
                      // print(dataSnap.data.snapshot.value);
                      if (dataSnap.connectionState == ConnectionState.active) {
                        if (dataSnap.hasData) {
                          List dataMap = dataSnap.data.snapshot.value;
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Container(
                              padding: EdgeInsets.zero,
                              height: 165,
                              child: Container(
                                padding: EdgeInsets.zero,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Card(
                                  color: cardColor(
                                      dataMap[0]["status"].toString()),
                                  elevation: 0,
                                  child: Stack(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            MarqueeWidget(
                                              child: Text(
                                                dataMap[0]["hosp_name"]
                                                    .toString(),
                                                style: GoogleFonts.openSans(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 25,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            MarqueeWidget(
                                              child: Text(
                                                "Date: " +
                                                    dataMap[0]
                                                            ["appointment_date"]
                                                        .toString(),
                                                style: GoogleFonts.openSans(
                                                    fontSize: 20,
                                                    color: Colors.white),
                                              ),
                                            ),
                                            MarqueeWidget(
                                              child: Text(
                                                "Time: " +
                                                    dataMap[0]
                                                            ["appointment_time"]
                                                        .toString(),
                                                style: GoogleFonts.openSans(
                                                    fontSize: 20,
                                                    color: Colors.white),
                                              ),
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
                                                  MainAxisAlignment.end,
                                              children: [
                                                Image.asset(
                                                  'assets/images/clock.png',
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
                                ),
                              ),
                            ),
                          );
                        } else {}
                      } else {
                        return Container(
                          height: 165,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          height: 50,
          decoration: BoxDecoration(
            color: Colors.black12,
            borderRadius: BorderRadius.all(
              Radius.circular(50),
            ),
          ),
          child: Theme(
            data: ThemeData(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
            ),
            child: TabBar(
              controller: _tabController,
              indicatorPadding: const EdgeInsets.all(5.0),
              tabs: [
                Container(
                  width: 100,
                  height: 50,
                  child: Center(
                    child: Text("Request"),
                  ),
                ),
                Container(
                  width: 100,
                  height: 50,
                  child: Center(
                    child: Text("Donate"),
                  ),
                ),
              ],
              unselectedLabelColor: Colors.white70,
              labelColor: Colors.white,
              unselectedLabelStyle:
                  GoogleFonts.openSans(fontWeight: FontWeight.bold),
              labelStyle: GoogleFonts.openSans(fontWeight: FontWeight.bold),
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(50),
                color: Color(0xffff5f6d),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
