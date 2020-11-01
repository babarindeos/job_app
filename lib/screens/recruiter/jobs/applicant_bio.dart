import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicantBio extends StatefulWidget {
  String userId;
  ApplicantBio({this.userId});
  @override
  _ApplicantBioState createState() => _ApplicantBioState();
}

class _ApplicantBioState extends State<ApplicantBio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          StreamBuilder(
              stream: Firestore.instance
                  .collection("BioData")
                  .document(widget.userId)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> snapshot) {
                return !snapshot.hasData
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Container(
                        alignment: Alignment.centerLeft,
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 10.0, 5.0, 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Name',
                              style: TextStyle(
                                fontFamily: 'SourceSansPro',
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(
                              height: 3.0,
                            ),
                            Text(
                              snapshot.data['name'],
                            ),
                            SizedBox(height: 16.0),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          'Gender',
                                          style: TextStyle(
                                              fontFamily: 'SourceSansPro',
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0),
                                        ),
                                        SizedBox(height: 5.0),
                                        Text(snapshot.data['gender'])
                                      ]),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Age',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'SourceSansPro',
                                            fontSize: 16.0),
                                      ),
                                      SizedBox(
                                        height: 5.0,
                                      ),
                                      Text(snapshot.data['age'] + ' years'),
                                    ],
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              'State',
                              style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                            SizedBox(height: 5.0),
                            Text(snapshot.data['state']),
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              'Country',
                              style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(snapshot.data['country']),
                            SizedBox(height: 15.0),
                            Text(
                              'Phone',
                              style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                            Text(snapshot.data['phone'])
                          ],
                        ),
                      );
              })
        ],
      ),
    );
  }
}
