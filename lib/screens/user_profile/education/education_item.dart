import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_app/models/education.dart';

import 'education_details.dart';

class EducationItem extends StatefulWidget {
  final String uuid;
  final String docId;
  final String owner;
  final String dateStarted;
  final String dateEnded;
  final String institution;
  final String courseOfStudy;
  final String level;
  final String classOfDegree;
  final String pageState;
  final DocumentSnapshot documentSnapshot;

  EducationItem(
      {@required this.docId,
      @required this.uuid,
      @required this.owner,
      @required this.dateStarted,
      @required this.dateEnded,
      @required this.institution,
      @required this.courseOfStudy,
      @required this.level,
      @required this.classOfDegree,
      this.pageState,
      @required this.documentSnapshot});

  @override
  _EducationItemState createState() => _EducationItemState();
}

class _EducationItemState extends State<EducationItem> {
  Education data;

  void deleteEducation(String docId) async {
    DocumentReference docRef =
        Firestore.instance.collection('Education').document(docId);
    await docRef.delete().then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.grey.shade300),
        ),
      ),
      child: Container(
        alignment: Alignment.centerLeft,
        width: double.infinity,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () async {
                  deleteEducation(widget.docId);
                },
                child: Container(
                  height: 50,
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(
                        widget.dateStarted + " - " + widget.dateEnded,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(widget.institution),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: FlatButton(
                  onPressed: () {
                    data = Education(
                        docId: widget.docId,
                        uuid: widget.uuid,
                        owner: widget.owner,
                        dateStarted: widget.dateStarted,
                        dateEnded: widget.dateEnded,
                        institution: widget.institution,
                        courseOfStudy: widget.courseOfStudy,
                        level: widget.level,
                        classOfDegree: widget.classOfDegree);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EducationDetails(
                            data: data, pageState: widget.pageState),
                      ),
                    );
                  },
                  child: Icon(Icons.chevron_right)),
            ),
          ],
        ),
      ),
    );
  }
}
