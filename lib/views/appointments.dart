import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';

class Appointments extends StatefulWidget {
  const Appointments({Key key}) : super(key: key);

  @override
  _AppointmentsState createState() => _AppointmentsState();
}

class _AppointmentsState extends State<Appointments>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    final Size size = MediaQuery.of(context).size;
    TabController _tabController =
        TabController(initialIndex: 0, length: 2, vsync: this);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Container(
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
              unselectedLabelColor: Colors.white54,
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: TabBarView(
          controller: _tabController,
          children: [
            SingleChildScrollView(
                child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Requests",
                      style: GoogleFonts.montserrat(
                          color: Color(0xffff5f6d), fontSize: 70),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * 0.1,
                ),
                Container(
                  child: Material(
                    elevation: 10,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Color(0xffff5f6d), Color(0xffffc371)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight),
                          borderRadius: BorderRadius.circular(8)),
                      height: size.width * 0.5,
                      width: size.width * 0.5,
                      child: Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              DateTime.now().day.toString(),
                              style: GoogleFonts.montserrat(
                                  fontSize: 80, color: Colors.white),
                            ),
                            Text(
                              DateFormat('MMMM')
                                  .format(DateTime.now())
                                  .toString(),
                              style: GoogleFonts.montserrat(
                                  fontSize: 40, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            )),
            SingleChildScrollView(
              child: Text(
                "Donations",
                style: GoogleFonts.montserrat(
                    color: Color(0xffff5f6d), fontSize: 70),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
