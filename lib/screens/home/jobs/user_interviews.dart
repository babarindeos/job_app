import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_app/models/interview.dart';
import 'package:job_app/screens/home/jobs/shortlisted.dart';
import 'package:job_app/screens/home/your_jobs_applied.dart';
import 'package:job_app/shared/constants.dart';

class UserInterviews extends StatefulWidget {
  String currentUserId;
  UserInterviews({this.currentUserId});
  @override
  _UserInterviewsState createState() => _UserInterviewsState();
}

class _UserInterviewsState extends State<UserInterviews> {
  List interviews = [];
  String companyName = '';
  String jobPosition = '';
  String jobLocation = '';
  Interview interviewData;
  List visibleInterviews = [];
  bool isLoading = true;
//------------------------------------------------------------------------------
  Future<String> _getCompanyName(String companyDocId) async {
    return Firestore.instance
        .collection("Company")
        .document(companyDocId)
        .get()
        .then((value) => value['name']);
  }
//------------------------------------------------------------------------------

  Future<String> _getJobPosition(String jobDocId) async {
    return Firestore.instance
        .collection("Job_Postings")
        .document(jobDocId)
        .get()
        .then((value) => value['position']);
  }

//------------------------------------------------------------------------------

  Future<String> _getJobLocation(String jobDocId) async {
    return Firestore.instance
        .collection("Job_Postings")
        .document(jobDocId)
        .get()
        .then((value) => value['location']);
  }

//------------------------------------------------------------------------------

  Future<void> _getUserInterviews() async {
    print(widget.currentUserId);
    try {
      var query = Firestore.instance
          .collection("Interview_Schedule")
          .where("candidate_docid", isEqualTo: widget.currentUserId);
      var querysnapshot = await query.getDocuments().then((value) => value);
      querysnapshot.documents.forEach((element) async {
        companyName = await _getCompanyName(element['company_docid']);
        jobPosition = await _getJobPosition(element['job_docid']);
        jobLocation = await _getJobLocation(element['job_docid']);

        interviewData = Interview(
            uid: element['uid'],
            applicationDocId: element['application_docid'],
            candidateDocId: element['candidate_docid'],
            companyDocId: element['company_docid'],
            companyName: companyName,
            comment: element['comment'],
            jobDocId: element['job_docid'],
            jobPosition: jobPosition,
            jobLocation: jobLocation,
            scheduleDate: element['schedule_date'],
            scheduledDateDtFmt: element['schedule_date_dtfmt'],
            scheduledDateUnFmt: element['schedule_date_unfmt'],
            scheduleTime: element['schedule_time'],
            shortlistedDocId: element['shortlisted_docid']);
        interviews.add(interviewData);
        setState(() {
          visibleInterviews = interviews;
          print('List length' + visibleInterviews.length.toString());
          print('Scheduled Time: ' + element['schedule_time'].toString());
          isLoading = false;
        });
      });
    } catch (e) {
      print(e.code);
      print(e.message);
    } finally {
      setState(() {
        visibleInterviews = interviews;
        isLoading = false;
      });
    }
  }

//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
  @override
  void initState() {
    // TODO: implement initState
    _getUserInterviews();
    super.initState();
  }

//------------------------------------------------------------------------------
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
                  "Scheduled Interviews",
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
                            builder: (context) => YourJobsApplied(
                                currentUserId: widget.currentUserId),
                          ),
                          ModalRoute.withName('/'));
                    },
                    child: Container(
                      decoration: BoxDecoration(
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
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ShortedListed(
                              currentUserId: widget.currentUserId),
                        ),
                        ModalRoute.withName('/'),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 15.0),
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
                      color: Colors.blue,
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15.0),
                      ),
                    ),
                    child: Text(
                      'Interviews',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10.0,
              ),
              Container(
                alignment: Alignment.center,
                child: TextFormField(
                  decoration: searchTextInputDecoration.copyWith(
                      labelText: 'Search Interviews',
                      prefixIcon: Icon(Icons.search)),
                  onChanged: (value) {
                    //jobsAppliedName = jobsAppliedName.toSet().toList();
                    visibleInterviews = interviews
                        .where(
                          (element) =>
                              element.jobPosition.toLowerCase().contains(
                                    value.toLowerCase(),
                                  ) ||
                              element.companyName.toLowerCase().contains(
                                    value.toLowerCase(),
                                  ) ||
                              element.scheduleDate
                                  .toLowerCase()
                                  .contains(value.toLowerCase()),
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
                        'No of Interviews: ${visibleInterviews.length.toString()}',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
              ),
              !isLoading
                  ? ListView.builder(
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: visibleInterviews.length,
                      itemBuilder: (context, index) {
                        return UserInterviewItem(
                          currentUserId: widget.currentUserId,
                          uid: visibleInterviews[index].uid,
                          applicationDocId:
                              visibleInterviews[index].applicationDocId,
                          candidateDocId:
                              visibleInterviews[index].candidateDocId,
                          scheduleDate: visibleInterviews[index].scheduleDate,
                          scheduleTime: visibleInterviews[index].scheduleTime,
                          comment: visibleInterviews[index].comment,
                          jobPosition: visibleInterviews[index].jobPosition,
                          companyName: visibleInterviews[index].companyName,
                        );
                      },
                    )
                  : Center(
                      child: LinearProgressIndicator(),
                    )
            ]),
      ),
    );
  }
}

//------------------------------------------------------------------------------

class UserInterviewItem extends StatefulWidget {
  String currentUserId,
      uid,
      applicationDocId,
      candidateDocId,
      scheduleDate,
      scheduleTime,
      comment,
      jobPosition,
      companyName;
  UserInterviewItem(
      {this.currentUserId,
      this.uid,
      this.applicationDocId,
      this.candidateDocId,
      this.scheduleDate,
      this.scheduleTime,
      this.comment,
      this.jobPosition,
      this.companyName});
  @override
  _UserInterviewItemState createState() => _UserInterviewItemState();
}

class _UserInterviewItemState extends State<UserInterviewItem> {
  @override
  Widget build(BuildContext context) {
    print(widget.scheduleDate);
    return Container(
      padding: const EdgeInsets.fromLTRB(2.0, 5.0, 5.0, 2.0),
      child: Card(
        elevation: 7.0,
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: const EdgeInsets.fromLTRB(1.0, 2.0, 3.0, 1.0),
                    child: Text(
                      widget.jobPosition,
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                ],
              ),
              Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: const EdgeInsets.fromLTRB(2.0, 0.0, 3.0, 10.0),
                    child: Text(
                      widget.companyName,
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                  )
                ],
              ),
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
                          widget.scheduleDate.toString(),
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
                          widget.scheduleTime.toString(),
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
              SizedBox(height: 7.0),
              // Container(
              //   padding: const EdgeInsets.fromLTRB(12.0, 10.0, 3.0, 2.0),
              //   decoration: BoxDecoration(
              //     border: Border(
              //       top: BorderSide(width: 1.0, color: Colors.grey.shade300),
              //     ),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
