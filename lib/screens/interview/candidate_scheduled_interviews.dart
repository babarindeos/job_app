import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_app/screens/interview/schedule_interview.dart';

class CandidateSheduledInterviews extends StatefulWidget {
  String candidateId,
      candidateName,
      candidateAvatar,
      companyId,
      applicationId,
      jobId,
      jobPosition,
      shortlistedDocId;
  CandidateSheduledInterviews(
      {this.candidateId,
      this.candidateName,
      this.candidateAvatar,
      this.companyId,
      this.applicationId,
      this.jobId,
      this.jobPosition,
      this.shortlistedDocId});
  @override
  _CandidateSheduledInterviewsState createState() =>
      _CandidateSheduledInterviewsState();
}

class _CandidateSheduledInterviewsState
    extends State<CandidateSheduledInterviews> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Scheduled Interviews'),
        ),
        body: ListView(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(
                  left: 8.0, top: 10.0, right: 10.0, bottom: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    radius: 36.0,
                    backgroundColor: Colors.blue,
                    child: CircleAvatar(
                      radius: 35.0,
                      backgroundColor: Colors.white,
                      child: ClipOval(
                        child: SizedBox(
                          width: 100,
                          height: 180,
                          child: widget.candidateAvatar == null
                              ? Image(
                                  fit: BoxFit.cover,
                                  image:
                                      AssetImage('images/profile_avatar.jpg'),
                                )
                              : Image.network(
                                  widget.candidateAvatar,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(left: 8.0, top: 5.0),
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          widget.candidateName,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(left: 8.0, top: 6.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Text('Applied Job - ' + widget.jobPosition),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            StreamBuilder(
                stream: Firestore.instance
                    .collection("Interview_Schedule")
                    .where("company_docid", isEqualTo: widget.companyId)
                    .where("candidate_docid", isEqualTo: widget.candidateId)
                    .where("job_docid", isEqualTo: widget.jobId)
                    .orderBy("date_created", descending: true)
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
                            return CandidateScheduledInterviewsItem(
                                documentSnapshot: data,
                                scheduleInterviewDocId: data.documentID,
                                uid: data['uid'],
                                jobDocId: data['job_docid'],
                                applicationDocId: data['application_docid'],
                                candidateDocId: data['candidate_docid'],
                                companyDocId: data['company_docid'],
                                shortlistedDocId: data['shortlisted_docId'],
                                scheduleDate: data['schedule_date'],
                                scheduleTime: data['schedule_time'],
                                comment: data['comment'],
                                dateCreated: data['date_created']);
                          });
                })
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScheduleInterview(
                    candidateId: widget.candidateId,
                    candidateName: widget.candidateName,
                    candidateAvatar: widget.candidateAvatar,
                    companyId: widget.companyId,
                    applicationId: widget.applicationId,
                    jobId: widget.jobId,
                    jobPosition: widget.jobPosition,
                    shortlistedDocId: widget.shortlistedDocId),
              ),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}

class CandidateScheduledInterviewsItem extends StatefulWidget {
  String scheduleInterviewDocId,
      uid,
      jobDocId,
      applicationDocId,
      candidateDocId,
      companyDocId,
      shortlistedDocId,
      scheduleDate,
      scheduleTime,
      comment;
  Timestamp dateCreated;

  DocumentSnapshot documentSnapshot;

  CandidateScheduledInterviewsItem(
      {this.scheduleInterviewDocId,
      this.uid,
      this.jobDocId,
      this.applicationDocId,
      this.candidateDocId,
      this.companyDocId,
      this.shortlistedDocId,
      this.scheduleDate,
      this.scheduleTime,
      this.comment,
      this.dateCreated,
      this.documentSnapshot});

  @override
  _CandidateScheduledInterviewsItemState createState() =>
      _CandidateScheduledInterviewsItemState();
}

class _CandidateScheduledInterviewsItemState
    extends State<CandidateScheduledInterviewsItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),
      child: Card(
        elevation: 7.0,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          Icons.calendar_today,
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          widget.scheduleDate,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Icon(
                          Icons.timer,
                        ),
                        Text(
                          widget.scheduleTime,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 5.0),
              Row(
                children: <Widget>[
                  widget.comment.isNotEmpty
                      ? Icon(Icons.chat)
                      : Container(
                          height: 0.0,
                        ),
                  SizedBox(
                    width: 5.0,
                  ),
                  widget.comment.isNotEmpty
                      ? Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(widget.comment),
                          ),
                        )
                      : Container(),
                ],
              ),
              SizedBox(height: 6.0),
              Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.blue,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(50.0)),
                  color: Colors.white,
                ),
                height: 30.0,
                child: Text(
                  'Launch Interview Room',
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 3.0),
              Container(
                padding: const EdgeInsets.fromLTRB(12.0, 10.0, 3.0, 2.0),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.0, color: Colors.grey.shade300),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
