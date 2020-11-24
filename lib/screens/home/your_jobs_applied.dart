import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_app/models/jobposted.dart';
import 'package:job_app/models/user.dart';
import 'package:job_app/screens/home/jobs/shortlisted.dart';
import 'package:job_app/services.dart/auth.dart';
import 'package:job_app/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:simple_tooltip/simple_tooltip.dart';

import 'jobs/job_details.dart';

class YourJobsApplied extends StatefulWidget {
  YourJobsApplied({Key key}) : super(key: key);

  @override
  _YourJobsAppliedState createState() => _YourJobsAppliedState();
}

class _YourJobsAppliedState extends State<YourJobsApplied> {
  bool isLoading = true;
  String currentUserId;
  List applicationList = [];
  List appliedJobList = [];
  List appliedJobsUid = [];
  List visibleApplicationList = [];
  AuthService _auth;
  JobPosted jobsApplied;
  List jobsAppliedName = [];

//------------------------------------------------------------------------------
  Future<void> _getCurrentUserInfo() async {
    currentUserId = await _auth.getCurrentUser();
    setState(() {});
  }

//------------------------------------------------------------------------------
  Future<void> _getApplicationList() async {
    final FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    currentUserId = _user.uid;
    Query collectionRef = Firestore.instance
        .collection("Job_Applications")
        .where("user_id", isEqualTo: currentUserId);
    await collectionRef.getDocuments().then((querySnapshot) {
      //querySnapshot
      querySnapshot.documents.forEach((element) async {
        if (element.exists) {
          applicationList.add(element.documentID);
          appliedJobList.add(element['job_id']);
          await _getAppliedJobUid(element['job_id']);
          //print(appliedJobsUid);
          setState(() {
            visibleApplicationList = applicationList;
            isLoading = false;
          });
        }
      });
      //end of querySnapshot
    });
  }

//------------------------------------------------------------------------------
  Future<void> _getAppliedJobUid(String jobDocId) async {
    DocumentReference docRef =
        Firestore.instance.collection("Job_Postings").document(jobDocId);
    await docRef.get().then((dataSnapshot) {
      if (dataSnapshot.exists) {
        appliedJobsUid.add(dataSnapshot['uid']);
        setState(() {});
      }
    });
  }

//------------------------------------------------------------------------------

  @override
  void initState() {
    _getApplicationList();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 5.0),
              alignment: Alignment.center,
              child: Text(
                "Your Jobs",
                style: TextStyle(
                    fontFamily: 'Pacifico-Regular',
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                InkWell(
                  onTap: () {
                    print("Applied");
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                      ),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    child: Text(
                      'Applied',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ShortedListed(currentUserId: currentUserId),
                        ),
                        ModalRoute.withName('/'));
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.blue),
                        bottom: BorderSide(color: Colors.blue),
                      ),
                    ),
                    child: Text(
                      'Shortlisted',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15.0),
                      ),
                    ),
                    child: Text(
                      'Interviews',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
              ],
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              alignment: Alignment.center,
              child: TextFormField(
                decoration: searchTextInputDecoration.copyWith(
                    labelText: 'Search for Applications',
                    prefixIcon: Icon(Icons.search)),
                onChanged: (value) {
                  jobsAppliedName = jobsAppliedName.toSet().toList();
                },
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: isLoading
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Text(
                      'No of Applications: ${applicationList.length.toString()}'),
            ),
            appliedJobList.length > 0
                ? StreamBuilder(
                    stream: Firestore.instance
                        .collection("Job_Postings")
                        .where("uid", whereIn: appliedJobsUid)
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
                                DocumentSnapshot data =
                                    snapshot.data.documents[index];
                                return YourJobsAppliedItem(
                                  currentUserId: currentUserId,
                                  documentSnapshot: data,
                                  docId: data.documentID,
                                  jobUid: data['job_uid'],
                                  applicationUid: data['uid'],
                                  position: data['position'],
                                  area: data['area'],
                                  location: data['location'],
                                  owner: data['owner'],
                                  payment: data['payment'],
                                  expiration: data['expiration'],
                                  posted: data['posted'],
                                  postedFmt: data['postedFmt'],
                                  datePosted: data['date_posted'],
                                  jobsAppliedName: jobsAppliedName,
                                );
                              });
                    })
                : Text(''),
          ],
        ),
      ),
    );
  }
}

//------------------------------------------------------------------------------

class YourJobsAppliedItem extends StatefulWidget {
  String currentUserId,
      docId,
      jobUid,
      applicationUid,
      position,
      area,
      location,
      owner,
      payment,
      expiration,
      posted,
      postedFmt;
  List jobsAppliedName;

  DocumentSnapshot documentSnapshot;
  Timestamp datePosted;
  YourJobsAppliedItem({
    this.currentUserId,
    this.docId,
    this.jobUid,
    this.applicationUid,
    this.position,
    this.area,
    this.location,
    this.owner,
    this.payment,
    this.expiration,
    this.posted,
    this.postedFmt,
    this.datePosted,
    this.documentSnapshot,
    this.jobsAppliedName,
  });

  @override
  _YourJobsAppliedItemState createState() => _YourJobsAppliedItemState();
}

class _YourJobsAppliedItemState extends State<YourJobsAppliedItem> {
  JobPosted passData;

  DateTime result;
  Timestamp date_applied;
  String formattedDate;

  //------------------------------------------------------------------------------
  Future _getCompanyInfo(String companyId) async {
    widget.jobsAppliedName.add(widget.position);
    widget.jobsAppliedName = widget.jobsAppliedName.toSet().toList();
    print(widget.jobsAppliedName);
    return Firestore.instance
        .collection("Company")
        .document(companyId)
        .get()
        .then((dataSnapshot) => dataSnapshot);
  }

//------------------------------------------------------------------------------
// Get Application Date

  Future _getApplicationDate() async {
    var query = Firestore.instance
        .collection("Job_Applications")
        .where("uid", isEqualTo: widget.jobUid);
    var querySnapshot = await query.getDocuments().then((value) => value);
    querySnapshot.documents.forEach((element) {
      date_applied = element.data['date_applied'];
      result = date_applied.toDate();
      formattedDate = DateFormat.yMMMEd().format(result);
      //formattedDate = DateFormat.yMMMd().format(result.toDate());
      //date_applied = DateTime.fromMillisecondsSinceEpoch(result);
    });

    return formattedDate;
  }

//------------------------------------------------------------------------------
  Future _checkShortlistStatus() async {
    //print(widget.jobUid);
    var query = Firestore.instance
        .collection("Shortlist")
        .where("job_uid", isEqualTo: widget.jobUid)
        .where("candidate_id", isEqualTo: widget.currentUserId);
    var querySnapshot = await query.getDocuments().then((value) => value);
    return querySnapshot.documents.length;
  }

//------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    //print(widget.jobUid);
    //print(widget.currentUserId);
    //print(widget.owner);

    return Container(
      child: Card(
        elevation: 7.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 3.0, 7.0),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.position,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.business,
                              size: 18.0,
                              color: Colors.blue.shade300,
                            ),
                            FutureBuilder(
                                future: _getCompanyInfo(widget.owner),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return Container(
                                      padding: const EdgeInsets.only(
                                          left: 3.0, top: 7.0, bottom: 5.0),
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(
                                        snapshot.data['name'].toString(),
                                        style: TextStyle(
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.pin_drop,
                              size: 18.0,
                              color: Colors.blue.shade300,
                            ),
                            Container(
                              padding: const EdgeInsets.only(left: 3.0),
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                widget.location,
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        passData = JobPosted(
                          docId: widget.docId,
                          uid: widget.jobUid,
                          position: widget.position,
                          owner: widget.owner,
                          area: widget.area,
                          description: widget.position,
                          location: widget.location,
                          payment: widget.payment,
                          expiration: widget.expiration,
                          posted: widget.posted,
                          postedFmt: widget.postedFmt,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JobDetails(data: passData),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Icon(Icons.chevron_right),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 6.0,
              ),
              Container(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        width: 1.0,
                        color: Colors.grey.shade300,
                      ),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.bottomLeft,
                          child: FutureBuilder(
                              future: _checkShortlistStatus(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return snapshot.data > 0
                                      ? Row(children: <Widget>[
                                          Icon(
                                            Icons.person_pin,
                                            color: Colors.green,
                                          ),
                                          Text(
                                            'Shortlisted',
                                            style: TextStyle(fontSize: 12.0),
                                          ),
                                        ])
                                      : Text('');
                                } else {
                                  return Text('');
                                }
                              }),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: FutureBuilder(
                              future: _getApplicationDate(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return Text(
                                    snapshot.data.toString(),
                                    style: TextStyle(
                                      fontSize: 12.0,
                                    ),
                                  );
                                } else {
                                  return Text('');
                                }
                              }),
                        ),
                      )
                    ],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
