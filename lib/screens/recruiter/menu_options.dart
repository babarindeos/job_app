import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_app/screens/recruiter/jobs/jobs_tracker.dart';

class MenuOptions extends StatefulWidget {
  @override
  _MenuOptionsState createState() => _MenuOptionsState();
}

class _MenuOptionsState extends State<MenuOptions> {
  String displayUsername = '';
  String displayCompanyName = '';
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
        });
      }
    });
  }

  void initState() {
    // TODO: implement initState
    super.initState();
    retrieveUserInfo();
    retrieveCompanyInfo();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 15.0),
          alignment: Alignment.center,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Welcome ${displayUsername}',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
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
                        child: Container(
                          alignment: Alignment.center,
                          width: 130.0,
                          height: 120.0,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('images/jobs_tracker1.jpg'),
                            ),
                            border: Border.all(color: Colors.blue),
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 5,
                                offset:
                                    Offset(0, 3), // changes position of shadow
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 10.0),
                      Container(
                        alignment: Alignment.center,
                        width: 130.0,
                        height: 120.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/interviews.jpg'),
                          ),
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            )
                          ],
                        ),
                        //child: Text('Manage Interviews'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        width: 130.0,
                        height: 120.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/manage_cvs.jpg'),
                            fit: BoxFit.cover,
                          ),
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            )
                          ],
                        ),
                        //child: Text('Manage CVs'),
                      ),
                      SizedBox(width: 10.0),
                      Container(
                        alignment: Alignment.center,
                        width: 130.0,
                        height: 120.0,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage('images/search.jpg'),
                              fit: BoxFit.cover),
                          border: Border.all(color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 5,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 3), // changes position of shadow
                            )
                          ],
                        ),
                        //child: Text('Manage Interviews'),
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