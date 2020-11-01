import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicantExperienceDetails extends StatefulWidget {
  String userAvatar,
      userName,
      docId,
      uuid,
      position,
      organisation,
      duties,
      fromDate,
      toDate;

  ApplicantExperienceDetails(
      {this.userAvatar,
      this.userName,
      this.docId,
      this.uuid,
      this.position,
      this.organisation,
      this.duties,
      this.fromDate,
      this.toDate});
  @override
  _ApplicantExperienceDetailsState createState() =>
      _ApplicantExperienceDetailsState();
}

class _ApplicantExperienceDetailsState
    extends State<ApplicantExperienceDetails> {
  @override
  Widget build(BuildContext context) {
    print(widget.userAvatar);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Experience Details'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 31.0,
                  backgroundColor: Colors.blue,
                  child: CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child:
                            Image.network(widget.userAvatar, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    widget.userName,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 5.0,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.organisation,
                    style: TextStyle(
                        fontFamily: 'SourceSansPro',
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5.0),
                  Text(widget.position +
                      ', ' +
                      widget.fromDate +
                      ' - ' +
                      widget.toDate),
                  SizedBox(
                    height: 30.0,
                  ),
                  Text(
                    'Duties/Responsibilities',
                    style: TextStyle(
                      fontFamily: 'SourceSansPro',
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                    ),
                  ),
                  Text(widget.duties),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
