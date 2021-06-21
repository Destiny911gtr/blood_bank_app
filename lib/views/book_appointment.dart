import 'package:blood_bank_app/utils/globals.dart';
import 'package:blood_bank_app/utils/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

final mainReference = FirebaseDatabase.instance.reference();

class BookAppointment extends StatefulWidget {
  const BookAppointment({Key key}) : super(key: key);

  @override
  _BookAppointmentState createState() => _BookAppointmentState();
}

class _BookAppointmentState extends State<BookAppointment> {
  void refreshList() {
    setState(() {});
  }

  @override
  initState() {
    super.initState();
    refreshData().whenComplete(() => refreshList());
  }

  @override
  Widget build(BuildContext scaffold) {
    Size size = MediaQuery.of(scaffold).size;
    return SafeArea(
      top: false,
      child: Scaffold(
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
                slivers: [
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
                                  "Book Appointments",
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
                    height: 8,
                  )),
                  SliverGrid(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        childAspectRatio: size.aspectRatio < 1 ? 0.93 : 1.35,
                        maxCrossAxisExtent: size.aspectRatio < 1
                            ? size.width * 0.5
                            : size.width / 3,
                        mainAxisSpacing: 0,
                        crossAxisSpacing: 0),
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      if (snapshot.hasData) {
                        List dataMapKeys = dataMap.keys.toList();
                        return Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: InkWell(
                            child: Card(
                              elevation: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 100,
                                      width: size.aspectRatio < 1
                                          ? size.width * 0.5
                                          : size.width / 3,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.asset(
                                          imageAssetGenerator(index),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    MarqueeWidget(
                                      direction: Axis.horizontal,
                                      child: Text(
                                        "${dataMap[dataMapKeys[index].toString()]['hospital_or_bloodbank_name'].toString()}",
                                        overflow: TextOverflow.fade,
                                        style: GoogleFonts.openSans(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    Text(
                                      dataMap[dataMapKeys[index].toString()]
                                              ['city']
                                          .toString(),
                                      style: GoogleFonts.openSans(fontSize: 15),
                                    ),
                                    Text(
                                      dataMap[dataMapKeys[index].toString()]
                                              ['mobile']
                                          .toString(),
                                      style: GoogleFonts.openSans(fontSize: 15),
                                    ),
                                    Text(
                                      "${dataMap[dataMapKeys[index].toString()]['donation_timing'].toString()}",
                                      style: GoogleFonts.openSans(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            onTap: () {
                              showDialog<void>(
                                context: context,
                                builder: (BuildContext context) {
                                  return _TimePicker(
                                      dataMap[dataMapKeys[index].toString()]
                                              ['hospital_or_bloodbank_name']
                                          .toString(),
                                      scaffold);
                                },
                              );
                            },
                          ),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                        childCount: snapshot.hasData
                            ? dataMap.keys.toList().length
                            : 1),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _TimePicker extends StatelessWidget {
  _TimePicker(this.hospital, this.scaffoldContext);

  final String hospital;
  final BuildContext scaffoldContext;
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext dialog) {
    Size size = MediaQuery.of(dialog).size;

    return SimpleDialog(
      contentPadding: const EdgeInsets.all(0),
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
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
                            'assets/images/hospital.png',
                            color: Colors.black12,
                            height: size.width / 2.5,
                            width: size.width / 2.5,
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                          child: Text(
                            '$hospital',
                            style: GoogleFonts.openSans(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                          child: Container(
                            height: 135,
                            width: size.aspectRatio < 1
                                ? size.width * 1
                                : size.width / 3,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                imageAssetGenerator(1),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                          child: Text(
                            'Book an appointment or request',
                            style: GoogleFonts.openSans(fontSize: 15),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: AppointmentPageView(
                              _formKey, hospital, dialog, scaffoldContext),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class AppointmentPageView extends StatefulWidget {
  GlobalKey<FormState> _formKey;
  String hospital;
  BuildContext dialog;
  BuildContext scaffoldContext;
  AppointmentPageView(
      this._formKey, this.hospital, this.dialog, this.scaffoldContext);

  @override
  _AppointmentPageViewState createState() => _AppointmentPageViewState();
}

class _AppointmentPageViewState extends State<AppointmentPageView>
    with TickerProviderStateMixin {
  final List _bloodSel = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];
  final Map<String, dynamic> _donationFormData = {
    'name': null,
    'hosp_name': null,
    'appointment_time': null,
    'appointment_date': null,
    'blood_grp': null,
  };
  final Map<String, dynamic> _requestFormData = {
    'name': null,
    'hosp_name': null,
    'phone_no': null,
    'blood_grp': null,
    'status': 'Pending',
  };

  void requestListPush() {
    mainReference.child("request_length").once().then((DataSnapshot snapshot) {
      int length = snapshot.value + 1;
      mainReference.child("request_length").set(length);
      mainReference.child("request/$length").set(_requestFormData);
      Navigator.of(widget.dialog).pop();
      ScaffoldMessenger.of(widget.scaffoldContext).showSnackBar(SnackBar(
          content: Text("Requested blood. Please wait a reply soon!")));
    });
  }

  void donateListPush() {
    mainReference.child("donate_length").once().then((DataSnapshot snapshot) {
      int length = snapshot.value + 1;
      mainReference.child("donate_length").set(length);
      mainReference.child("donation/$length").set(_donationFormData);
      Navigator.of(widget.dialog).pop();
      showDialog<void>(
        context: widget.dialog,
        builder: (BuildContext context) {
          return _Congratulate(widget.scaffoldContext);
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    TabController _tabController =
        TabController(initialIndex: 0, length: 2, vsync: this);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Container(
            height: 50,
            width: MediaQuery.of(widget.dialog).size.width,
            child: Container(
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
                      height: 40,
                      child: Center(
                        child: Text("Request"),
                      ),
                    ),
                    Container(
                      width: 100,
                      height: 40,
                      child: Center(
                        child: Text("Donate"),
                      ),
                    ),
                  ],
                  unselectedLabelColor: Colors.grey[500],
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
        ),
        Container(
          height: 300,
          width: MediaQuery.of(widget.dialog).size.width,
          child: TabBarView(
            controller: _tabController,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 10, 8, 16),
                child: Column(
                  children: [
                    TextFormField(
                      onSaved: (value) {
                        _requestFormData['name'] = value;
                      },
                      initialValue: userData.get('fname').toString() +
                          " " +
                          userData.get('lname').toString(),
                      validator: (String value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FormBuilderDropdown(
                      name: 'blood',
                      decoration: InputDecoration(
                        labelText: 'Blood group',
                      ),
                      initialValue: userData.get('blood').toString(),
                      allowClear: false,
                      hint: Text('Select group'),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select your blood type';
                        }
                        return null;
                      },
                      items: _bloodSel
                          .map((blood) => DropdownMenuItem(
                                value: blood,
                                child: Text('$blood'),
                              ))
                          .toList(),
                      onSaved: (value) {
                        _requestFormData['blood_grp'] = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: userData.get('mobileno'),
                      autofillHints: [AutofillHints.telephoneNumber],
                      decoration: InputDecoration(
                          labelText: 'Phone',
                          hintText: 'Enter number without +91'),
                      keyboardType: TextInputType.phone,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      validator: (String value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid number';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        _requestFormData['phone_no'] = value;
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Color(0xffff5f6d),
                              ),
                              child: TextButton(
                                child: Text(
                                  'Request blood',
                                  style:
                                      GoogleFonts.openSans(color: Colors.white),
                                ),
                                onPressed: () {
                                  if (widget._formKey.currentState.validate()) {
                                    try {
                                      _requestFormData['hosp_name'] =
                                          widget.hospital;
                                      widget._formKey.currentState.save();
                                      requestListPush();
                                    } catch (e) {
                                      print(e.toString());
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 10, 8, 16),
                child: Column(
                  children: [
                    TextFormField(
                      onSaved: (value) {
                        _donationFormData['name'] = value;
                      },
                      initialValue: userData.get('fname').toString() +
                          " " +
                          userData.get('lname').toString(),
                      validator: (String value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a valid name';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FormBuilderDropdown(
                      name: 'blood',
                      decoration: InputDecoration(
                        labelText: 'Blood group',
                      ),
                      initialValue: userData.get('blood').toString(),
                      allowClear: false,
                      hint: Text('Select group'),
                      validator: (value) {
                        if (value == null) {
                          return 'Please select your blood type';
                        }
                        return null;
                      },
                      items: _bloodSel
                          .map((blood) => DropdownMenuItem(
                                value: blood,
                                child: Text('$blood'),
                              ))
                          .toList(),
                      onSaved: (value) {
                        _donationFormData['blood'] = value;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FormBuilderDateTimePicker(
                      name: 'time',
                      inputType: InputType.both,
                      decoration: InputDecoration(
                        labelText: 'Pick a suitable date and time',
                      ),
                      validator: (value) {
                        if (value == null) {
                          return 'Please enter date and time';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _donationFormData['appointment_date'] =
                            value.toString().split(' ').first.toString();
                        _donationFormData['appointment_time'] = value
                            .toString()
                            .split(' ')
                            .last
                            .split('.')
                            .first
                            .split(' ')
                            .last
                            .toString();
                      },
                      initialDate: DateTime.now(),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(30.0),
                                color: Color(0xffff5f6d),
                              ),
                              child: TextButton(
                                child: Text(
                                  'Donate blood',
                                  style:
                                      GoogleFonts.openSans(color: Colors.white),
                                ),
                                onPressed: () {
                                  if (widget._formKey.currentState.validate()) {
                                    try {
                                      _donationFormData['hosp_name'] =
                                          widget.hospital;
                                      widget._formKey.currentState.save();
                                      donateListPush();
                                    } catch (e) {
                                      print(e.toString());
                                    }
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _Congratulate extends StatelessWidget {
  _Congratulate(this.scaffoldContext);

  final BuildContext scaffoldContext;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: EdgeInsets.zero,
      elevation: 0,
      backgroundColor: Colors.black38,
      child: Container(
        height: MediaQuery.of(scaffoldContext).size.height,
        width: MediaQuery.of(scaffoldContext).size.width,
        child: Stack(
          alignment: Alignment.center,
          children: [
            AspectRatio(
                aspectRatio: MediaQuery.of(scaffoldContext).size.aspectRatio,
                child: Lottie.asset('assets/lottie/confetti.json',
                    fit: BoxFit.fitHeight, repeat: false)),
            Text(
              "Thank You, Hero!",
              style: GoogleFonts.openSans(
                  fontSize: MediaQuery.of(scaffoldContext).size.width / 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 100),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    splashColor: Colors.white60,
                    onTap: () => Navigator.of(context).pop(),
                    child: Ink(
                      decoration: BoxDecoration(
                          color: Colors.grey, shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Icon(Icons.close),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
