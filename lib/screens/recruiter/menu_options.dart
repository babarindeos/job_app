import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_app/screens/interview/candidate_list.dart';
import 'package:job_app/screens/recruiter/jobs/jobs_tracker.dart';

class MenuOptions extends StatefulWidget {
  @override
  _MenuOptionsState createState() => _MenuOptionsState();
}

class _MenuOptionsState extends State<MenuOptions> {
  String displayUsername = '';
  String displayCompanyName = '';
  bool isfetching = false;

  @override
  Future<void> retrieveUserInfo() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    dynamic currentUser = await _auth.currentUser().then((value) => value.uid);

    DocumentReference docReference =
        Firestore.instance.collection("BioData").document(currentUser);
    await docReference.get().then((dataSnapshot) {
      if (dataSnapshot.exists) {
        setState(() {
          displayUsername = dataSnapshot.data['name'];
        });
      }
    });
  }

  Future<void> retrieveCompanyInfo() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    dynamic currentUser = await _auth.currentUser().then((value) => value.uid);
    DocumentReference docReference =
        Firestore.instance.collection("Company").document(currentUser);
    await docReference.get().then((dataSnapshot) {
      if (dataSnapshot.exists) {
        setState(() {
          displayCompanyName = dataSnapshot.data['name'];
          isfetching = false;
        });
      }
    });
  }

  void initState() {
    // TODO: implement initState

    super.initState();
    isfetching = true;
    retrieveUserInfo();
    retrieveCompanyInfo();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print("am here");
      },
      child: Scaffold(
        body: isfetching
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Container(
                padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Welcome ${displayUsername}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 18.0),
                    ),
                    Text(displayCompanyName),
                    SizedBox(height: 55.0),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => JobTracker()),
                                );
                              },
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    width: 130.0,
                                    height: 120.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage(
                                            'images/jobs_tracker1.jpg'),
                                      ),
                                      border: Border.all(color: Colors.blue),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 5,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Jobs',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'SourceSansPro',
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10.0),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CandidateList(),
                                  ),
                                );
                              },
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    alignment: Alignment.center,
                                    width: 130.0,
                                    height: 120.0,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image:
                                            AssetImage('images/interviews.jpg'),
                                      ),
                                      border: Border.all(color: Colors.blue),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(20.0)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 5,
                                          blurRadius: 5,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        )
                                      ],
                                    ),
                                    //child: Text('Manage Interviews'),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Interviews',
                                      style: TextStyle(
                                          fontFamily: 'SourceSansPro',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  width: 130.0,
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                      image:
                                          AssetImage('images/manage_cvs.jpg'),
                                      fit: BoxFit.cover,
                                    ),
                                    border: Border.all(color: Colors.blue),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 5,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      )
                                    ],
                                  ),
                                  //child: Text('Manage CVs'),
                                ),
                                Container(
                                  child: Text(
                                    'CVs',
                                    style: TextStyle(
                                      fontFamily: 'SourceSansPro',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 10.0),
                            Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  width: 130.0,
                                  height: 120.0,
                                  decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: AssetImage('images/search.jpg'),
                                        fit: BoxFit.cover),
                                    border: Border.all(color: Colors.blue),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20.0)),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 5,
                                        offset: Offset(
                                            0, 3), // changes position of shadow
                                      )
                                    ],
                                  ),
                                  //child: Text('Manage Interviews'),
                                ),
                                Container(
                                  child: Text(
                                    'Search',
                                    style: TextStyle(
                                        fontFamily: 'SourceSansPro',
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
