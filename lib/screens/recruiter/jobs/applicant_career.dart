import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class ApplicantCareer extends StatefulWidget {
  String userId;
  ApplicantCareer({this.userId});
  @override
  _ApplicantCareerState createState() => _ApplicantCareerState();
}

class _ApplicantCareerState extends State<ApplicantCareer> {
//------------------------------------------------------------------------------
// launch Facebook Url
  _launchUrl(BuildContext context, String url) async {
    if (await canLaunch(url)) {
      await launch(url.toString());
    } else {
      cannotLaunchUrl(context, 'Could not launch $url');
    }
  }

//------------------------------------------------------------------------------
// show dialog box
  void cannotLaunchUrl(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Text('Cannot Launch Url'),
              content: Text(message),
              actions: <Widget>[
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Ok',
                    style: Theme.of(context).textTheme.caption.copyWith(
                        fontWeight: FontWeight.w600, color: Colors.blue),
                  ),
                )
              ]);
        });
  }

//------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10.0, 15.0, 5.0, 5.0),
      child: Column(
        children: <Widget>[
          StreamBuilder(
              stream: Firestore.instance
                  .collection("CareerDetails")
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
                        padding: const EdgeInsets.all(1.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Profession',
                              style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              snapshot.data['field'].toString(),
                            ),
                            SizedBox(height: 15.0),
                            Text(
                              'Experience',
                              style: TextStyle(
                                fontFamily: 'SourceSansPro',
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            Text(
                              snapshot.data['experience'].toString() + ' years',
                            ),
                          ],
                        ),
                      );
              }),
          SizedBox(
            height: 15.0,
          ),
          StreamBuilder(
              stream: Firestore.instance
                  .collection("SocialMedia")
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Facebook',
                              style: TextStyle(
                                fontFamily: 'SourceSansPro',
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            snapshot.data['facebook'].toString().isEmpty
                                ? Text('')
                                : InkWell(
                                    onTap: () {
                                      _launchUrl(
                                          context, snapshot.data['facebook']);
                                    },
                                    child: Text(
                                      snapshot.data['facebook'].toString(),
                                      style: TextStyle(
                                        decoration: TextDecoration.none,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                            SizedBox(height: 15.0),
                            Text(
                              'Instagram',
                              style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                            snapshot.data['instagram'].toString().isEmpty
                                ? Text('')
                                : InkWell(
                                    onTap: () {
                                      _launchUrl(
                                          context, snapshot.data['instagram']);
                                    },
                                    child: Text(
                                      snapshot.data['instagram'].toString(),
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Colors.blue),
                                    ),
                                  ),
                            SizedBox(height: 15.0),
                            Text(
                              'LinkedIn',
                              style: TextStyle(
                                fontFamily: 'SourceSansPro',
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(
                              height: 5.0,
                            ),
                            snapshot.data['linkedin'].toString().isEmpty
                                ? Text('')
                                : InkWell(
                                    onTap: () {
                                      _launchUrl(context,
                                          snapshot.data['linkedin'].toString());
                                    },
                                    child: Text(
                                      snapshot.data['linkedin'].toString(),
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Colors.blue),
                                    ),
                                  ),
                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              'Snapchat',
                              style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                            SizedBox(height: 5.0),
                            snapshot.data['snapchat'].toString().isEmpty
                                ? Text('')
                                : InkWell(
                                    onTap: () {
                                      _launchUrl(
                                          context, snapshot.data['snapchat']);
                                    },
                                    child: Text(
                                      snapshot.data['snapchat'].toString(),
                                      style: TextStyle(
                                          decoration: TextDecoration.none,
                                          color: Colors.blue),
                                    ),
                                  ),
                          ],
                        ),
                      );
              })
        ],
      ),
    );
  }
}
