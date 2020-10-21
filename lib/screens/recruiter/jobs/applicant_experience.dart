import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicantExperience extends StatefulWidget {
  String userId;
  ApplicantExperience({this.userId});

  @override
  _ApplicantExperienceState createState() => _ApplicantExperienceState();
}

class _ApplicantExperienceState extends State<ApplicantExperience> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          StreamBuilder(
            stream: Firestore.instance
                .collection("Experience")
                .where("owner", isEqualTo: widget.userId.toString())
                .snapshots(),
            builder: (context, snapshot) {
              return !snapshot.hasData
                  ? Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data.documents.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot data = snapshot.data.documents[index];
                        return ApplicantExperienceItem(
                          documentSnapshot: data,
                          docId: data.documentID,
                          uuid: data['uuid'],
                          position: data['position'],
                          fromDate: data['from_date'],
                          toDate: data['to_date'],
                          organisation: data['organisation'],
                        );
                      });
            },
          )
        ],
      ),
    );
  }
}

class ApplicantExperienceItem extends StatefulWidget {
  String docId, uuid, position, fromDate, toDate, organisation;
  DocumentSnapshot documentSnapshot;

  ApplicantExperienceItem(
      {this.docId,
      this.uuid,
      this.position,
      this.fromDate,
      this.toDate,
      this.organisation,
      this.documentSnapshot});

  @override
  _ApplicantExperienceItemState createState() =>
      _ApplicantExperienceItemState();
}

class _ApplicantExperienceItemState extends State<ApplicantExperienceItem> {
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
                      widget.position,
                      style: TextStyle(
                        fontFamily: 'SourceSansPro',
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.organisation,
                      style: TextStyle(
                        fontSize: 13.0,
                      ),
                    ),
                    Text(
                      widget.fromDate + ' - ' + widget.toDate,
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
