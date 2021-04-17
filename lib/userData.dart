import 'package:flutter/material.dart';

class userData extends StatefulWidget {
  @override
  _userDataState createState() => _userDataState();
}

class _userDataState extends State<userData> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
            Container(
              height: 50,
              color: Colors.amber[600],
              child: const Center(child: Text('Entry A')),
            ),
            Container(
              height: 50,
              color: Colors.amber[500],
              child: const Center(child: Text('Entry B')),
            ),
            Container(
              height: 50,
              color: Colors.amber[100],
              child: const Center(child: Text('Entry C')),
            ),
            TextButton.icon(onPressed: () {
              Navigator.pop(context);
            },
              icon: Icon(Icons.close),
              label: Text("Close"),
            )
          ],
        ),
      ),
    );
  }
}
