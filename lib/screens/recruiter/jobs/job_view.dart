import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_app/models/jobposted.dart';

class JobView extends StatefulWidget {
  final JobPosted data;
  JobView({this.data});

  @override
  _JobViewState createState() => _JobViewState();
}

class _JobViewState extends State<JobView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Job View'),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
          children: <Widget>[
            Text(
              widget.data.position,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 23.0,
                  fontFamily: 'SourceSansPro'),
            ),
            SizedBox(height: 5.0),
            Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.room,
                        color: Colors.blue,
                        size: 21.0,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(widget.data.location),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.attach_money,
                        size: 21.0,
                        color: Colors.blue,
                      ),
                      Text(widget.data.payment),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Row(
              children: <Widget>[
                Icon(
                  Icons.person_outline,
                  size: 21.0,
                  color: Colors.blue,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(widget.data.area),
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              color: Colors.grey.shade300,
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Date Posted',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.data.postedFmt,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(width: 1.0, color: Colors.grey),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Date Closing',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.data.expiration,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
              child: Text(
                'List of Candidates:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: CircleAvatar(
                    radius: 31.0,
                    backgroundColor: Colors.blue,
                    child: CircleAvatar(
                      radius: 30.0,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: SizedBox(
                          width: 50,
                          height: 50,
                          child: Image(
                            image: AssetImage('images/henry_smith.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'John Smith',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17.0,
                              fontFamily: 'SourceSansPro'),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Computer Scientist',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    children: <Widget>[
                      Text('Profile'),
                      Icon(Icons.chevron_right),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
