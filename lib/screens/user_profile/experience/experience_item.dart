import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_app/models/education.dart';
import 'package:job_app/models/experience.dart';
import 'package:job_app/screens/user_profile/experience/experience_details.dart';

class ExperienceItem extends StatefulWidget {
  final String uuid;
  final String docId;
  final String owner;
  final String fromDate;
  final String toDate;
  final String organisation;
  final String position;
  final String duties;
  final DocumentSnapshot documentSnapshot;

  ExperienceItem(
      {@required this.docId,
      @required this.uuid,
      @required this.owner,
      @required this.fromDate,
      @required this.toDate,
      @required this.organisation,
      @required this.position,
      @required this.duties,
      @required this.documentSnapshot});

  @override
  _ExperienceItemState createState() => _ExperienceItemState();
}

class _ExperienceItemState extends State<ExperienceItem> {
  Experience data;

  void deleteEducation(String docId) async {
    DocumentReference docRef =
        Firestore.instance.collection('Education').document(docId);
    await docRef.delete().then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 0.0),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.grey.shade300))),
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
                          widget.fromDate + " - " + widget.toDate,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0, top: 3.0),
                      child: Text(widget.organisation),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: FlatButton(
                  onPressed: () {
                    data = Experience(
                      docId: widget.docId,
                      uuid: widget.uuid,
                      owner: widget.owner,
                      fromDate: widget.fromDate,
                      toDate: widget.toDate,
                      organisation: widget.organisation,
                      position: widget.position,
                      duties: widget.duties,
                    );

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ExperienceDetails(data: data)));
                  },
                  child: Icon(Icons.chevron_right)),
            ),
          ],
        ),
      ),
    );
  }
}
