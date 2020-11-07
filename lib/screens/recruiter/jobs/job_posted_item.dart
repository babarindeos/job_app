import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:job_app/models/jobposted.dart';
import 'package:job_app/screens/recruiter/jobs/job_details.dart';

class JobPostedItem extends StatefulWidget {
  final String uid,
      docId,
      owner,
      position,
      area,
      description,
      location,
      payment,
      expiration,
      posted,
      postedFmt;
  final DocumentSnapshot documentSnapshot;

  JobPostedItem(
      {@required this.uid,
      @required this.docId,
      @required this.owner,
      @required this.position,
      @required this.area,
      @required this.description,
      @required this.location,
      @required this.payment,
      @required this.expiration,
      @required this.posted,
      @required this.postedFmt,
      @required this.documentSnapshot});
  @override
  _JobPostedItemState createState() => _JobPostedItemState();
}

class _JobPostedItemState extends State<JobPostedItem> {
  JobPosted data;
  DateFormat _newformat;
  DateTime posted;
  String applicationCount = '';
//------------------------------------------------------------------------------
  Future<void> _applicationCount(String jobId) async {
    CollectionReference collRef =
        Firestore.instance.collection("Job_Applications");

    await collRef
        .where("job_id", isEqualTo: jobId)
        .orderBy('date_applied', descending: false)
        .getDocuments()
        .then((QuerySnapshot docs) {
      if (docs.documents.isNotEmpty) {
        applicationCount = docs.documents.length.toString();
      }
    });
  }

//------------------------------------------------------------------------------

  Future _getApplicationCount() async {
    return Firestore.instance
        .collection("Job_Applications")
        .where("job_id", isEqualTo: widget.docId)
        .getDocuments();
  }

//------------------------------------------------------------------------------
  Widget getApplicationCount() {
    return Text(applicationCount);
  }

//------------------------------------------------------------------------------
  @override
  void initState() {
    _applicationCount(widget.docId);
    super.initState();
  }

//-----------------------------------------------------------------------------
  Future<void> deletePostItem(String docId) async {
    DocumentReference docReference =
        Firestore.instance.collection('Job_Postings').document(docId);

    await docReference.delete().then((value) => {});
  }

  //----------------------------------------------------------------------------

  void confirmDeletePostItem(BuildContext context, String docId) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirm Delete'),
            content: Text(
                'Do you wish to Delete the Job Post? This action is irreversible.'),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: Theme.of(context).textTheme.caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.blue,
                      ),
                ),
              ),
              FlatButton(
                  onPressed: () {
                    deletePostItem(docId);
                  },
                  child: Text(
                    'Delete',
                    style: Theme.of(context).textTheme.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                  )),
            ],
          );
        });
  }

  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    //_newformat = DateFormat("MMM. d, yyyy");
    //posted = DateFormat("MMM. d, yyyy").parse((widget.posted));

    return Container(
      padding: const EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),
      child: Card(
        elevation: 7.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    widget.position,
                    style:
                        TextStyle(fontSize: 15.0, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.timer,
                    size: 15.0,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(right: 5.0, left: 5.0),
                    child: Text(
                      '${widget.postedFmt}  -- ',
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.expiration,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                children: <Widget>[
                  Icon(
                    Icons.person,
                    size: 15.0,
                  ),
                  Container(
                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                    child: Text(
                      'No. of Applicants',
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: FutureBuilder(
                      future: _getApplicationCount(),
                      builder: (context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return Container(
                            alignment: Alignment.centerRight,
                            child:
                                Text(snapshot.data.documents.length.toString()),
                          );
                        } else {
                          return Text('0');
                        }
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 3.0),
              Container(
                  padding: const EdgeInsets.fromLTRB(12.0, 5.0, 3.0, 2.0),
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 1.0, color: Colors.grey.shade300),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: InkWell(
                          onTap: () async {
                            confirmDeletePostItem(context, widget.docId);
                          },
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.delete, size: 15.0, color: Colors.red),
                              Text(
                                'Delete',
                                style: TextStyle(
                                    color: Colors.red, fontSize: 11.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () {
                              data = JobPosted(
                                uid: widget.uid,
                                docId: widget.docId,
                                owner: widget.owner,
                                position: widget.position,
                                area: widget.area,
                                description: widget.description,
                                location: widget.location,
                                payment: widget.payment,
                                expiration: widget.expiration,
                                posted: widget.posted,
                                postedFmt: widget.postedFmt,
                              );
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JobDetails(data: data),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Icon(Icons.book,
                                    size: 15.0, color: Colors.green),
                                Text(
                                  'Details',
                                  style: TextStyle(
                                      color: Colors.green, fontSize: 11.0),
                                )
                              ],
                            ),
                          ),
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
