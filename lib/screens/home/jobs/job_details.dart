import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_app/models/jobposted.dart';
import 'package:job_app/models/user.dart';
import 'package:job_app/screens/home/company/company_information.dart';
import 'package:provider/provider.dart';

class JobDetails extends StatefulWidget {
  JobPosted data;
  JobDetails({this.data});

  @override
  _JobDetailsState createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  String companyName = '';
  String companyId;
  bool companyInfoLoaded = false;
  DateTime applied;
  String processOutcome;
  bool userApplicationStatus = false;
  bool isLoadingUserApplicationStatus = false;
  String currentUserId;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<void> getCompany(String docId) async {
    DocumentReference docReference =
        Firestore.instance.collection("Company").document(widget.data.owner);
    await docReference.get().then((dataSnapshot) {
      if (dataSnapshot.exists) {
        setState(() {
          companyName = (dataSnapshot.data['name']);
          companyInfoLoaded = true;
        });
      }
    });
  }

//-----------------------------------------------------------------------------
  @override
  void initState() {
    getCompany(widget.data.docId);
    isLoadingUserApplicationStatus = true;
    // TODO: implement initState
    super.initState();
  }

  //----------------------------------------------------------------------------
  Future<void> _confirmJobApplication(
      BuildContext context, String userId, String jobId) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Submit Application'),
            content: Text('Do you wish to submit an application for this Job?'),
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
                  onPressed: () async {
                    _applyForJob(context, userId, jobId);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Apply',
                    style: Theme.of(context).textTheme.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                  )),
            ],
          );
        });
  } // end of function

  //---------------------------------------------------------------------------
  Future<void> _applyForJob(
      BuildContext context, String userId, String jobId) async {
    DocumentReference docReference =
        Firestore.instance.collection("Job_Applications").document();

    Map<String, dynamic> application = {
      'job_id': jobId,
      'user_id': userId,
      'date_applied': DateTime.now().toString(),
    };
    await docReference.setData(application).whenComplete(() {
      processOutcome = 'Your application has been submitted for this Job';
      showInSnackBar(processOutcome, context);
    });
  }

  //----------------------------------------------------------------------------
  Future<void> _getUserApplicationStatus(
      String currentUserId, String jobId) async {
    final Query collectionRef =
        Firestore.instance.collection("Job_Applications");
    await collectionRef
        .where("job_id", isEqualTo: jobId)
        .where("user_id", isEqualTo: currentUserId)
        .getDocuments()
        .then((value) {
      //-------------Result of get User Application Status -----------------
      if (value.documents.length > 0) {
        userApplicationStatus = true;
      } else {
        userApplicationStatus = false;
      }
      isLoadingUserApplicationStatus = false;
      if (mounted) {
        setState(() {});
      }

      //-------------End of get User Application Status ---------------------
    });
  }

  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------

  void showInSnackBar(String processOutcome, BuildContext context) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          processOutcome,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        duration: Duration(seconds: 6),
      ),
    );
  }

  //-----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    currentUserId = user.uid;
    _getUserApplicationStatus(currentUserId, widget.data.docId);

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Job Details'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        children: <Widget>[
          isLoadingUserApplicationStatus
              ? Column(
                  children: <Widget>[
                    LinearProgressIndicator(),
                    Text('Loading Application Status...')
                  ],
                )
              : userApplicationStatus
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Text(
                        'You have submitted an application for this Job.',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ))
                  : Material(
                      color: Colors.green,
                      shadowColor: Colors.lightGreen,
                      elevation: 7.0,
                      borderRadius: BorderRadius.all(
                        Radius.circular(5.0),
                      ),
                      child: MaterialButton(
                          onPressed: () {
                            _confirmJobApplication(
                                context, user.uid, widget.data.docId);
                            //_applyForJob(context, user.uid, widget.data.docId);
                          },
                          child: Text(
                            'Apply for this Job',
                            style: TextStyle(color: Colors.white),
                          ),
                          minWidth: 10.0,
                          height: 20.0),
                    ),
          SizedBox(height: 20.0),
          Text(
            "Company",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5.0,
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(companyName),
                Expanded(
                  child: companyInfoLoaded
                      ? InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CompanyInformation(
                                    companyId: widget.data.owner),
                              ),
                            );
                          },
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 5.0),
                                child: Icon(Icons.info, color: Colors.blue),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 3.0),
                                child: Text(
                                  'Details',
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Container(
                          child: LinearProgressIndicator(),
                        ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20.0),
          Text(
            "Position",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.0),
          Text(widget.data.position),
          SizedBox(
            height: 20.0,
          ),
          Text(
            "Industry",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.0),
          Text(widget.data.area),
          SizedBox(
            height: 20.0,
          ),
          Text(
            "Location",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(widget.data.location),
          SizedBox(
            height: 20.0,
          ),
          Text(
            "Payment",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(widget.data.payment),
          SizedBox(
            height: 20.0,
          ),
          Text(
            "Job Description",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5.0,
          ),
          Text(widget.data.description),
        ],
      ),
    );
  }
}
