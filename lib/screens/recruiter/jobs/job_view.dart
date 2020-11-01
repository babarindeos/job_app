import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_app/models/jobposted.dart';
import 'package:job_app/screens/recruiter/jobs/job_view_candidate_item.dart';

class JobView extends StatefulWidget {
  final JobPosted data;
  JobView({this.data});

  @override
  _JobViewState createState() => _JobViewState();
}

class _JobViewState extends State<JobView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Job View'),
        ),
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    widget.data.position,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 23.0,
                        fontFamily: 'SourceSansPro'),
                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.room,
                              color: Colors.blue,
                              size: 21.0,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.35,
                                  child: Text(widget.data.location)),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: <Widget>[
                            Icon(
                              Icons.attach_money,
                              size: 21.0,
                              color: Colors.blue,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: Text(widget.data.payment),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.person_outline,
                        size: 21.0,
                        color: Colors.blue,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(widget.data.area)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5.0,
            ),
            Container(
              color: Colors.grey.shade300,
              padding:
                  const EdgeInsets.symmetric(vertical: 15.0, horizontal: 5.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      children: <Widget>[
                        Text(
                          'Date Posted',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          widget.data.postedFmt,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border(
                          left: BorderSide(width: 1.0, color: Colors.grey),
                        ),
                      ),
                      child: Column(
                        children: <Widget>[
                          Text(
                            'Date Closing',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            widget.data.expiration,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
              child: Text(
                'List of Candidates:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            StreamBuilder(
                stream: Firestore.instance
                    .collection("Job_Applications")
                    .where("job_id", isEqualTo: widget.data.docId)
                    .snapshots(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? Center(child: CircularProgressIndicator())
                      : ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot data =
                                snapshot.data.documents[index];
                            return JobViewCandidateItem(
                              documentSnapshot: data,
                              docId: data.documentID,
                              userId: data['user_id'],
                              jobId: data['job_id'],
                              dateApplied: data['date_applied'],
                            );
                          });
                }),
          ],
        ),
      ),
    );
  }
}
