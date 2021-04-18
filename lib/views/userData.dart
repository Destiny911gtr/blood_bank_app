import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class userData extends StatefulWidget {
  @override
  _userDataState createState() => _userDataState();
}

class _userDataState extends State<userData> {
  final databaseRef = FirebaseDatabase.instance.reference();

  void addData(String data) {
    databaseRef.push().set({'name': data, 'comment': 'A good season'});
  }

  void printFirebase() {
    databaseRef.once().then(
      (DataSnapshot snapshot) {
        //ynamic snapshot.exportVal();

        print('Data : ${snapshot.value}');
        print('TestData : ${snapshot.value["users"]}');
        //print('KeyValue': ${snapshot.getKey()});
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    printFirebase();
    return SafeArea(
      child: Scaffold(
        body: StreamBuilder(
          stream: databaseRef.child("users").onValue,
          builder: (context, AsyncSnapshot<Event> dataSnap) {
            if (dataSnap.connectionState == ConnectionState.active) {
              if (dataSnap.hasError) {
                return Text(dataSnap.error.toString());
              } else if (dataSnap.hasData) {
                Map<dynamic, dynamic> dataMap = dataSnap.data.snapshot.value;
                return ListView.builder(
                  itemCount: dataMap.keys.toList().length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      color: Colors.redAccent,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  dataMap.keys.toList()[index],
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Blood: ${dataMap.values.toList()[index]["blood"].toString()}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  "Email: ${dataMap.values.toList()[index]["email"].toString()}",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
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
              } else {
                return Text("No Data.");
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
