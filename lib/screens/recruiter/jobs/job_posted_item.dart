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

  Future<void> deletePostItem(String docId) async {
    DocumentReference docReference =
        Firestore.instance.collection('Job_Postings').document(docId);

    await docReference.delete().then((value) => {});
  }

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
                  Expanded(
                    child: Text(
                      widget.position,
                      style: TextStyle(
                          fontSize: 17.0, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      alignment: Alignment.centerRight,
                      child: Text(widget.postedFmt,
                          style: TextStyle(
                            color: Colors.grey,
                          )),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.timer,
                      size: 20.0,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text('Closes By'),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(widget.expiration)),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Icon(
                      Icons.person,
                      size: 20.0,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text('No. of Applicants'),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                        alignment: Alignment.centerRight, child: Text('0')),
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
                            deletePostItem(widget.docId);
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
