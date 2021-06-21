import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'globals.dart';

final List hospImg = [
  "assets/images/hospital1.png",
  "assets/images/hospital2.png",
  "assets/images/hospital3.png",
  "assets/images/hospital4.png",
  "assets/images/hospital5.png",
];

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

class DrawBox extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    //TODO: implement getClip
    Path path = Path();
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldCliper) {
    return true;
  }
}

Future<void> refreshData() async {
  final databaseRef = FirebaseDatabase.instance.reference();
  Map<dynamic, dynamic> dataList;
  String _uid = userData.get('uid');
  if (userData.get('logged_in', defaultValue: false)) {
    databaseRef.child("users").child(_uid).once().then((DataSnapshot snapshot) {
      String dob = snapshot.value['dob'].toString();
      int year = int.parse(dob.split('-').first);
      int month = int.parse(dob.split('-').elementAt(2));
      int date = int.parse(dob.split('-').last);
      userData.put('fname', snapshot.value['firstname'].toString());
      userData.put('lname', snapshot.value['lastname'].toString());
      userData.put('blood', snapshot.value['blood'].toString());
      userData.put(
          'age',
          DateTimeRange(start: DateTime(year, month, date), end: DateTime.now())
              .toString());
      userData.put('weight', snapshot.value['weight'].toString());
      userData.put('mobileno', snapshot.value['mobileno'].toString());
    });
  }
  return databaseRef
      .child("hospitalsandbloodbanks")
      .once()
      .then((DataSnapshot snapshot) {
    dataList = snapshot.value;
    bankData.put('bank_list', dataList);
  });
}

// ignore: must_be_immutable
class ImageGenerator extends StatelessWidget {
  ImageGenerator(this.index);
  final int index;

  Image img() {
    int r = (index * 37) % 5;
    String imageName = hospImg[r].toString();
    return Image.asset(
      imageName,
      fit: BoxFit.fitHeight,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(borderRadius: BorderRadius.circular(5), child: img());
  }
}

String imageAssetGenerator(int index) {
  int r = (index * 37) % 5;
  String imageName = hospImg[r].toString();
  return imageName;
}

class MarqueeWidget extends StatefulWidget {
  final Widget child;
  final Axis direction;
  final Duration animationDuration, backDuration, pauseDuration;

  MarqueeWidget({
    @required this.child,
    this.direction: Axis.horizontal,
    this.animationDuration: const Duration(milliseconds: 3000),
    this.backDuration: const Duration(milliseconds: 800),
    this.pauseDuration: const Duration(milliseconds: 800),
  });

  @override
  _MarqueeWidgetState createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget> {
  ScrollController scrollController;

  @override
  void initState() {
    scrollController = ScrollController(initialScrollOffset: 50.0);
    WidgetsBinding.instance.addPostFrameCallback(scroll);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: widget.child,
      scrollDirection: widget.direction,
      controller: scrollController,
    );
  }

  void scroll(_) async {
    while (scrollController.hasClients) {
      await Future.delayed(widget.pauseDuration);
      if (scrollController.hasClients)
        await scrollController.animateTo(
            scrollController.position.maxScrollExtent,
            duration: widget.animationDuration,
            curve: Curves.ease);
      await Future.delayed(widget.pauseDuration);
      if (scrollController.hasClients)
        await scrollController.animateTo(0.0,
            duration: widget.backDuration, curve: Curves.easeOut);
    }
  }
}
