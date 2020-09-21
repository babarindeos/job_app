import 'package:flutter/material.dart';

class JobTracker extends StatefulWidget {
  @override
  _JobTrackerState createState() => _JobTrackerState();
}

class _JobTrackerState extends State<JobTracker> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Job Tracker'),
        actions: <Widget>[Icon(Icons.add), SizedBox(width: 15.0)],
      ),
      body: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    print("Post Job");
                  },
                  child: Icon(Icons.keyboard_arrow_left))
            ],
          )
        ],
      ),
    ));
  }
}
