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
    // TODO: implement initState
    super.initState();
  }

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

  void showInSnackBar(String processOutcome, BuildContext context) {
    Scaffold.of(context).showSnackBar(
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

    return Scaffold(
      appBar: AppBar(
        title: Text('Job Details'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        children: <Widget>[
          Material(
            color: Colors.green,
            shadowColor: Colors.lightGreen,
            elevation: 7.0,
            borderRadius: BorderRadius.all(
              Radius.circular(5.0),
            ),
            child: MaterialButton(
                onPressed: () {
                  _applyForJob(context, user.uid, widget.data.docId);
                },
                child: Text(
                  'Apply for this Job',
                  style: TextStyle(color: Colors.white),
                ),
                minWidth: 10.0,
                height: 20.0),
          ),
          SizedBox(height: 10.0),
          Text(
            "Company",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5.0,
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Text(companyName),
              ),
              Expanded(
                child: companyInfoLoaded
                    ? InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CompanyInformation(
                                      companyId: widget.data.owner)));
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
                    : Text(''),
              ),
            ],
          ),
          SizedBox(height: 15.0),
          Text(
            "Position",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.0),
          Text(widget.data.position),
          SizedBox(
            height: 15.0,
          ),
          Text(
            "Industry",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5.0),
          Text(widget.data.area),
          SizedBox(
            height: 15.0,
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
            height: 15.0,
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
            height: 15.0,
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
