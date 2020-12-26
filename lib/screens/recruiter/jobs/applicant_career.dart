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
  String facebookUrl = '';
  String instagramUrl = '';
  String linkedinUrl = '';
  String snapchatUrl = '';
  bool isLoadingSocialMediaUrls = true;
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
  Future _getSocialMedia(String userId) async {
    print("User Id -------------- " + userId.toString());
    DocumentReference docRef =
        Firestore.instance.collection("SocialMedia").document(userId);
    await docRef.get().then((dataSnapshot) {
      if (dataSnapshot.exists) {
        setState(() {
          facebookUrl = dataSnapshot['facebook'];
          instagramUrl = dataSnapshot['instagram'];
          linkedinUrl = dataSnapshot['linkedin'];
          snapchatUrl = dataSnapshot['snapchat'];
        });
      }
    });
    isLoadingSocialMediaUrls = false;
    setState(() {});
    return;
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
          Container(
            alignment: Alignment.bottomLeft,
            child: Text(
              'Facebook',
              style: TextStyle(
                fontFamily: 'SourceSansPro',
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
          ),
          SizedBox(
            height: 5.0,
          ),
          FutureBuilder(
              future: _getSocialMedia(widget.userId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!isLoadingSocialMediaUrls) {
                  return Container(
                    alignment: Alignment.topLeft,
                    child: facebookUrl.isNotEmpty
                        ? InkWell(
                            onTap: () {
                              _launchUrl(context, facebookUrl);
                            },
                            child: Text(
                              facebookUrl,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.blue),
                            ),
                          )
                        : Container(),
                  );
                } else {
                  return Container(
                    child: LinearProgressIndicator(),
                  );
                }
              }),
          SizedBox(height: 15.0),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Instagram',
              style: TextStyle(
                  fontFamily: 'SourceSansPro',
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          ),
          SizedBox(height: 5.0),
          FutureBuilder(
              future: _getSocialMedia(widget.userId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!isLoadingSocialMediaUrls) {
                  return Container(
                    alignment: Alignment.topLeft,
                    child: instagramUrl.isNotEmpty
                        ? InkWell(
                            onTap: () {
                              _launchUrl(context, instagramUrl);
                            },
                            child: Text(
                              instagramUrl,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.blue),
                            ),
                          )
                        : Container(),
                  );
                } else {
                  return Container(
                    child: LinearProgressIndicator(),
                  );
                }
              }),
          SizedBox(height: 15.0),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'LinkedIn',
              style: TextStyle(
                  fontFamily: 'SourceSansPro',
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          ),
          SizedBox(height: 5.0),
          FutureBuilder(
              future: _getSocialMedia(widget.userId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!isLoadingSocialMediaUrls) {
                  return Container(
                    alignment: Alignment.topLeft,
                    child: instagramUrl.isNotEmpty
                        ? InkWell(
                            onTap: () {
                              _launchUrl(context, linkedinUrl);
                            },
                            child: Text(
                              linkedinUrl,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.blue),
                            ),
                          )
                        : Container(),
                  );
                } else {
                  return Container(
                    child: LinearProgressIndicator(),
                  );
                }
              }),
          SizedBox(height: 15.0),
          Container(
            alignment: Alignment.centerLeft,
            child: Text(
              'Snapchat',
              style: TextStyle(
                  fontFamily: 'SourceSansPro',
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
          ),
          SizedBox(height: 5.0),
          FutureBuilder(
              future: _getSocialMedia(widget.userId),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!isLoadingSocialMediaUrls) {
                  return Container(
                    alignment: Alignment.topLeft,
                    child: instagramUrl.isNotEmpty
                        ? InkWell(
                            onTap: () {
                              _launchUrl(context, snapchatUrl);
                            },
                            child: Text(
                              snapchatUrl,
                              style: TextStyle(
                                  decoration: TextDecoration.none,
                                  color: Colors.blue),
                            ),
                          )
                        : Container(),
                  );
                } else {
                  return Container(
                    child: LinearProgressIndicator(),
                  );
                }
              }),
        ],
      ),
    );
  }
}
