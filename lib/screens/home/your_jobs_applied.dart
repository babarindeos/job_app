import 'package:flutter/material.dart';

class YourJobsApplied extends StatefulWidget {
  YourJobsApplied({Key key}) : super(key: key);

  @override
  _YourJobsAppliedState createState() => _YourJobsAppliedState();
}

class _YourJobsAppliedState extends State<YourJobsApplied> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 5.0),
              alignment: Alignment.center,
              child: Text(
                "Your Jobs",
                style: TextStyle(
                    fontFamily: 'Pacifico-Regular',
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    border: Border.all(color: Colors.blue),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  child: Text(
                    'Applied',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                  ),
                  child: Text(
                    'Saved',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.blue),
                        bottom: BorderSide(color: Colors.blue),
                        right: BorderSide(color: Colors.blue),
                      ),
                    ),
                    child: Text(
                      'Skipped',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
