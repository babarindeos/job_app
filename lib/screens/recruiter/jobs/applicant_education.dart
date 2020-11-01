import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicantEducation extends StatefulWidget {
  String userId;
  ApplicantEducation({this.userId});
  @override
  _ApplicantEducationState createState() => _ApplicantEducationState();
}

class _ApplicantEducationState extends State<ApplicantEducation> {
  @override
  Widget build(BuildContext context) {
    print(widget.userId);
    return Scaffold(
        body: Column(
      children: <Widget>[
        StreamBuilder(
            stream: Firestore.instance
                .collection("Education")
                .where("owner", isEqualTo: widget.userId.toString())
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot data = snapshot.data.documents[index];
                        return ApplicantEducationItem(
                            documentSnapshot: data,
                            docId: data.documentID,
                            uuid: data['id'],
                            courseOfStudy: data['course_of_study'],
                            institution: data['institution'],
                            level: data['level'],
                            classOfDegree: data['class_of_degree'],
                            dateStarted: data['date_started'],
                            dateEnded: data['date_ended']);
                      });
            })
      ],
    ));
  }
}

class ApplicantEducationItem extends StatefulWidget {
  String docId,
      uuid,
      courseOfStudy,
      institution,
      level,
      classOfDegree,
      dateStarted,
      dateEnded;
  DocumentSnapshot documentSnapshot;
  ApplicantEducationItem(
      {this.docId,
      this.uuid,
      this.courseOfStudy,
      this.institution,
      this.level,
      this.classOfDegree,
      this.dateStarted,
      this.dateEnded,
      this.documentSnapshot});

  @override
  _ApplicantEducationItemState createState() => _ApplicantEducationItemState();
}

class _ApplicantEducationItemState extends State<ApplicantEducationItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Icon(
                  Icons.radio_button_checked,
                  color: Colors.blue,
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.institution,
                      style: TextStyle(
                        fontFamily: 'SourceSansPro',
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      widget.courseOfStudy +
                          " (" +
                          widget.level +
                          "),  " +
                          widget.classOfDegree,
                      style: TextStyle(fontSize: 13.0),
                    ),
                    Text(
                      widget.dateStarted + " -  " + widget.dateEnded,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
