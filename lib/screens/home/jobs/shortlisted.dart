import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:job_app/models/jobposted.dart';
import 'package:job_app/screens/home/jobs/user_interviews.dart';
import 'package:job_app/screens/home/your_jobs_applied.dart';
import 'package:job_app/shared/constants.dart';

import 'job_details.dart';

class ShortedListed extends StatefulWidget {
  String currentUserId;
  ShortedListed({this.currentUserId});
  @override
  _ShortedListedState createState() => _ShortedListedState();
}

class _ShortedListedState extends State<ShortedListed> {
  List shortListedList = [];
  List shortListedJobList = [];
  bool isLoading = true;
  JobPosted job;
  List visibleShortList = [];

//------------------------------------------------------------------------------
  Future<void> _getShortListedList() async {
    print("-----ShortListed------");
    try {
      Query collectionReference = Firestore.instance
          .collection("Shortlist")
          .where("candidate_id", isEqualTo: widget.currentUserId);
      await collectionReference.getDocuments().then((querySnapshot) {
        querySnapshot.documents.forEach((element) async {
          if (element.exists) {
            shortListedList.add(element.data['job_uid']);
            await _getShortedJobInfo(element['job_docId']);
          }
        });
      });

      // turn isLoading false
      setState(() {
        isLoading = false;
        visibleShortList = shortListedJobList;
      });
    } catch (e) {
      print(e.code);
      print(e.message);
    } finally {
      // turn isLoading false
      setState(() {
        isLoading = false;
        visibleShortList = shortListedJobList;
      });
    }
  }

//------------------------------------------------------------------------------
  Future<void> _getShortedJobInfo(String jobDocId) async {
    DocumentReference docRef =
        Firestore.instance.collection("Job_Postings").document(jobDocId);
    await docRef.get().then((dataSnapshot) {
      print(dataSnapshot.documentID);
      job = JobPosted(
        uid: dataSnapshot['uid'],
        docId: dataSnapshot.documentID,
        area: dataSnapshot['area'],
        description: dataSnapshot['description'],
        location: dataSnapshot['location'],
        owner: dataSnapshot['owner'],
        position: dataSnapshot['position'],
        payment: dataSnapshot['payment'],
        expiration: dataSnapshot['expiration'],
        posted: dataSnapshot['posted'],
        postedFmt: dataSnapshot['postedFmt'],
      );

      //----------------------------------------
      setState(() {
        shortListedJobList.add(job);
      });
      //----------------------------------------
    });
  }

//------------------------------------------------------------------------------
  @override
  void initState() {
    // TODO: implement initState
    _getShortListedList();
    super.initState();
  }

//------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    print("Current User " + widget.currentUserId);
    return SafeArea(
      child: Scaffold(
        body: ListView(
            padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 5.0),
                alignment: Alignment.center,
                child: Text(
                  "Shortlisted Jobs",
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
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => YourJobsApplied(),
                        ),
                        ModalRoute.withName('/'),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.blue),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      child: Text(
                        'Applied',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        border: Border(
                          top: BorderSide(color: Colors.blue),
                          bottom: BorderSide(color: Colors.blue),
                        ),
                      ),
                      child: Text(
                        'Shortlisted',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white),
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
                    child: InkWell(
                      onTap: () {
                        {
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => UserInterviews(
                                  currentUserId: widget.currentUserId),
                            ),
                            ModalRoute.withName('/'),
                          );
                        }
                      },
                      child: Text(
                        'Interviews',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                alignment: Alignment.center,
                child: TextFormField(
                  decoration: searchTextInputDecoration.copyWith(
                      labelText: 'Search Shortlisted Jobs',
                      prefixIcon: Icon(Icons.search)),
                  onChanged: (value) {
                    visibleShortList = shortListedJobList
                        .where(
                          (element) => element.position.toLowerCase().contains(
                                value.toLowerCase(),
                              ),
                        )
                        .toList();
                    setState(() {});
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
                        'No of Shortlisted Jobs: ${visibleShortList.length.toString()}',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
              !isLoading
                  ? ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: visibleShortList.length,
                      itemBuilder: (context, index) {
                        return ShortListedItem(
                          currentUserId: widget.currentUserId,
                          jobDocId: shortListedJobList[index].docId,
                          jobUid: shortListedJobList[index].uid,
                          area: shortListedJobList[index].area,
                          description: shortListedJobList[index].description,
                          expiration: shortListedJobList[index].expiration,
                          location: shortListedJobList[index].location,
                          owner: shortListedJobList[index].owner,
                          payment: shortListedJobList[index].payment,
                          position: shortListedJobList[index].position,
                          posted: shortListedJobList[index].posted,
                          postedFmt: shortListedJobList[index].postedFmt,
                        );
                      })
                  : Center(
                      child: LinearProgressIndicator(),
                    ),
            ]),
      ),
    );
  }
}

//------------------------------------------------------------------------------
// ShortListedItem
class ShortListedItem extends StatefulWidget {
  String currentUserId,
      shortListedDocId,
      jobDocId,
      jobUid,
      area,
      description,
      expiration,
      location,
      owner,
      payment,
      position,
      posted,
      postedFmt;

  ShortListedItem({
    this.currentUserId,
    this.shortListedDocId,
    this.jobDocId,
    this.jobUid,
    this.area,
    this.description,
    this.expiration,
    this.location,
    this.owner,
    this.payment,
    this.position,
    this.posted,
    this.postedFmt,
  });
  @override
  _ShortListedItemState createState() => _ShortListedItemState();
}

class _ShortListedItemState extends State<ShortListedItem> {
  JobPosted passData;

  DateTime result;
  Timestamp date_applied;
  String formattedDate;

  //------------------------------------------------------------------------------
  Future _getCompanyInfo(String companyId) async {
    return Firestore.instance
        .collection("Company")
        .document(companyId)
        .get()
        .then((dataSnapshot) => dataSnapshot);
  }

//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
// Get Application Date

  Future _getShortlistedDate() async {
    var query = Firestore.instance
        .collection("Shortlist")
        .where("job_uid", isEqualTo: widget.jobUid);
    var querySnapshot = await query.getDocuments().then((value) => value);
    querySnapshot.documents.forEach((element) {
      date_applied = element.data['date'];
      result = date_applied.toDate();
      formattedDate = DateFormat.yMMMEd().format(result);
      //formattedDate = DateFormat.yMMMd().format(result.toDate());
      //date_applied = DateTime.fromMillisecondsSinceEpoch(result);
    });

    return formattedDate;
  }

//------------------------------------------------------------------------------
  Future _checkInterviewStatus() async {
    var query = Firestore.instance
        .collection("Interview_Schedule")
        .where("candidate_docid", isEqualTo: widget.currentUserId)
        .where("job_docid", isEqualTo: widget.jobDocId);
    var querySnapshot = await query.getDocuments().then((value) => value);
    print(
        "Documents Length ----- " + querySnapshot.documents.length.toString());
    return querySnapshot.documents.length;
  }
//-------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    print("------ Job Uid ---" + widget.jobDocId);
    //print("Current User---------------" + widget.currentUserId);
    //print(widget.shortListedDocId);
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
                          docId: widget.jobDocId,
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
                      child: FutureBuilder(
                          future: _checkInterviewStatus(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return snapshot.data > 0
                                  ? Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.chat,
                                          color: Colors.green,
                                        ),
                                        Text(
                                          'Interview',
                                          style: TextStyle(fontSize: 12.0),
                                        ),
                                      ],
                                    )
                                  : Text('');
                            } else {
                              return Text('');
                            }
                          }),
                    ),
                    Expanded(
                      flex: 2,
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: FutureBuilder(
                            future: _getShortlistedDate(),
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
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
