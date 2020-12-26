import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:job_app/models/user.dart';
import 'package:job_app/screens/recruiter/jobs/applicant_bio.dart';
import 'package:job_app/screens/recruiter/jobs/applicant_career.dart';
import 'package:job_app/screens/recruiter/jobs/applicant_education.dart';
import 'package:job_app/screens/recruiter/jobs/applicant_experience.dart';
import 'package:job_app/screens/recruiter/jobs/applicant_portfolio.dart';
import 'package:job_app/screens/recruiter/message/messages.dart';
import 'package:job_app/screens/user_profile/pdf_viewer.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:tabbar/tabbar.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class ApplicantsInformation extends StatefulWidget {
  String userId, jobUid, jobId, docId;
  Timestamp dateApplied;
  DocumentSnapshot documentSnapshot;

  ApplicantsInformation(
      {this.userId,
      this.jobUid,
      this.jobId,
      this.docId,
      this.dateApplied,
      this.documentSnapshot});

  @override
  _ApplicantsInformationState createState() => _ApplicantsInformationState();
}

class _ApplicantsInformationState extends State<ApplicantsInformation> {
  String videoSource;
  String videoURL;
  bool isLoading;
  String userAvatar;
  String recruiterAvatar;
  String recruiterName;
  String userName;
  String companyId;
  String candidateId;
  String recruiterId;
  String applicationId;
  String jobId;
  dynamic videoPlayerController;
  bool shortlisted = false;
  String uploadFileUrl = '';

//--------------------------------------------------------------------------------
  Future<void> retrieveAvatar() async {
    try {
      DocumentReference docReference =
          Firestore.instance.collection('BioData').document(widget.userId);
      await docReference.get().then((dataSnapshot) {
        if (dataSnapshot.exists) {
          setState(() {
            userAvatar = dataSnapshot['avatar'];
            userName = dataSnapshot['name'];
          });
        }
      });
    } catch (e) {} finally {
      setState(() {
        isLoading = false;
      });
    }
  }

//------------------------------------------------------------------------------
// retrieveRecruiterAvatar
  Future<void> retrieveRecruiterAvatar() async {
    final FirebaseUser _recruiter = await FirebaseAuth.instance.currentUser();
    recruiterId = _recruiter.uid.toString();
    try {
      DocumentReference docReference =
          Firestore.instance.collection("BioData").document(recruiterId);
      await docReference.get().then((dataSnapshot) {
        if (dataSnapshot.exists) {
          setState(() {
            recruiterAvatar = dataSnapshot['avatar'];
            recruiterName = dataSnapshot['name'];
          });
        }
      });
    } catch (e) {}
  }

//------------------------------------------------------------------------------

  Future<void> retrieveVideoCV() async {
    try {
      DocumentReference documentRef =
          Firestore.instance.collection('Video_CV').document(widget.userId);

      await documentRef.get().then((dataSnapshot) {
        if (dataSnapshot.exists) {
          if (this.mounted) {
            setState(() {
              videoURL = (dataSnapshot).data['url'];
              videoSource = 'network';
              videoPlayerController = VideoPlayerController.network(videoURL);
              isLoading = false;
              //print("*------------------------------------" + videoURL);
            });
          }
        }
      });
    } catch (e) {
      print(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

//------------------------------------------------------------------------------
// retrive shortlist Status
  Future<void> retrieveShortlistStatus(
      String jobId, String applicationId, String candidateId) async {
    print("*************************************************** " + candidateId);
    final Query collectionRef = Firestore.instance
        .collection("Shortlist")
        .where("job_id", isEqualTo: jobId)
        .where("application_id", isEqualTo: applicationId)
        .where("candidate_id", isEqualTo: candidateId);
    await collectionRef.getDocuments().then((dataSnapshot) {
      dataSnapshot.documents.forEach((element) {
        if (element.exists) {
          print(
              "*********************************** Candidate has been shortlisted");
          setState(() {
            shortlisted = true;
          });
        }
      });
    });
  }

//------------------------------------------------------------------------------
// retrievePDFCV
  Future<void> retrievePDFCV() async {
    DocumentReference docRef =
        Firestore.instance.collection("Pdf_CV").document(widget.userId);
    await docRef.get().then((dataSnapshot) {
      if (dataSnapshot.exists) {
        setState(() {
          uploadFileUrl = dataSnapshot['url'];
        });
      }
    });
  }

//------------------------------------------------------------------------------

  @override
  void initState() {
    // TODO: implement initState
    isLoading = true;
    super.initState();

    // parameters
    jobId = widget.jobId;
    applicationId = widget.docId;
    candidateId = widget.userId;

    retrieveShortlistStatus(jobId, applicationId, candidateId);
    retrieveAvatar();
    retrieveVideoCV();
    retrievePDFCV();
    retrieveRecruiterAvatar();
  }

//------------------------------------------------------------------------------
  Future _getUserBioData(String userId) async {
    return Firestore.instance
        .collection("BioData")
        .document(userId)
        .get()
        .then((value) => value);
  }

//------------------------------------------------------------------------------
  Future _getCareerDetails(String userId) async {
    return Firestore.instance
        .collection("CareerDetails")
        .document(userId)
        .get()
        .then((value) => value);
  }

//------------------------------------------------------------------------------

  final controller = PageController();
//------------------------------------------------------------------------------
  @override
  void dispose() {
    //videoPlayerController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

//------------------------------------------------------------------------------
//_shortlisting function
  Future<void> _shortlisting(BuildContext context, String companyId,
      String candidateId, String jobId, String appId) async {
    // -------------- Not Shortlisted ------------------------------
    if (shortlisted == false) {
      try {
        var uuid = Uuid();
        var uid = uuid.v4();
        DocumentReference docRef =
            Firestore.instance.collection("Shortlist").document();
        DateTime now = DateTime.now();
        Map<String, dynamic> data = {
          "uid": uid,
          "job_uid": widget.jobUid,
          "job_id": jobId,
          "job_docId": jobId,
          "application_id": appId,
          "candidate_id": candidateId,
          "company_id": companyId,
          "date": now
        };

        await docRef.setData(data).whenComplete(() {
          String message = "The Candidate has been Shortlisted";
          showInSnackBar(message, context);
          setState(() {
            shortlisted = !(shortlisted);
          });
        });
      } catch (e) {
        String message = e.message.toString();
        showInSnackBar(message, context);
      }
    }
    //--------------------------------------------------------------------------
  }

//------------------------------------------------------------------------------
// Snackbar function
  void showInSnackBar(String value, BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
    );
  }

//------------------------------------------------------------------------------
//
//------------------------------------------------------------------------------

  void confirmDelisting(BuildContext context, String companyId, String jobId,
      String appId, candidateId) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Delist Candidate'),
            content: Text('Do you wish to remove the candidate from the list?'),
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
                    await _delistCandidate(
                        context, companyId, jobId, appId, candidateId);
                    Navigator.pop(context);
                  },
                  child: Text(
                    'Remove',
                    style: Theme.of(context).textTheme.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                  )),
            ],
          );
        });
  }

//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// delistCandidate
  Future<void> _delistCandidate(BuildContext context, String companyId,
      String jobId, String appId, String candidateId) async {
    try {
      final Query collectionReference = Firestore.instance
          .collection("Shortlist")
          .where("company_id", isEqualTo: companyId)
          .where("job_id", isEqualTo: jobId)
          .where("application_id", isEqualTo: appId)
          .where("candidate_id", isEqualTo: candidateId);

      print("Company_id: " + companyId);
      print("job_id: " + jobId);
      print("job_id: " + jobId);

      await collectionReference.getDocuments().then((dataSnapshot) {
        dataSnapshot.documents.forEach((element) {
          print(
              "**************************** " + element.documentID.toString());
          if (element.exists) {
            String docId = element.documentID.toString();
            Firestore.instance
                .collection("Shortlist")
                .document(docId)
                .delete()
                .then((value) {
              setState(() {
                shortlisted = !(shortlisted);
              });
              String message = "The candidate has been delisted";
              showInSnackBar(message, context);
            });
          } else {
            print('Does not exist');
          }
        });
      });
    } catch (e) {
      String message = e.message.toString();
      showInSnackBar(message, context);
    }
  }

//------------------------------------------------------------------------------
// showPDFViewer
  void showPDFViewer(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewPDF(),
            settings: RouteSettings(arguments: uploadFileUrl)));
  }

//------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final myCompanyId = Provider.of<User>(context).uid;
    print(widget.jobUid);

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : SafeArea(
            child: Scaffold(
              body: Builder(builder: (BuildContext context) {
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Container(
                            color: Colors.blue,
                            height: MediaQuery.of(context).size.height * 0.45,
                            width:
                                MediaQuery.of(context).size.width * (100 / 100),
                            child: videoSource == null
                                ? Center(
                                    child: Icon(Icons.videocam,
                                        color: Colors.white, size: 80),
                                  )
                                : FittedBox(
                                    fit: BoxFit.contain,
                                    child: mounted
                                        ? Chewie(
                                            controller: ChewieController(
                                              videoPlayerController:
                                                  videoPlayerController,
                                              aspectRatio: 7.4 / 5.9,
                                              autoPlay: true,
                                              looping: false,
                                            ),
                                          )
                                        : Container(
                                            child: Icon(Icons.videocam),
                                          ),
                                  ),
                          ),
                          Container(
                            width: 200,
                            height: 280,
                          ),
                          Positioned(
                            top: 195.0,
                            right: 7.0,
                            left: 11.0,
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: CircleAvatar(
                                radius: 35.0,
                                backgroundColor: Colors.blue,
                                child: ClipOval(
                                  child: SizedBox(
                                    width: 100,
                                    height: 180,
                                    child: userAvatar == null
                                        ? Image(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                                'images/profile_avatar.jpg'),
                                          )
                                        : Image.network(
                                            userAvatar,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            child: FutureBuilder(
                                future: _getUserBioData(widget.userId),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return Row(
                                      children: <Widget>[
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                        Icon(
                                          Icons.person,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(
                                          width: 3.0,
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          padding:
                                              const EdgeInsets.only(left: 3.0),
                                          child: Text(
                                            snapshot.data['name'].toString(),
                                            style: TextStyle(
                                                fontFamily: 'SourceSansPro',
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.blue[700]),
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Text('');
                                  }
                                }),
                          ),
                          // Profession
                          Container(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: FutureBuilder(
                                future: _getCareerDetails(widget.userId),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.business_center,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(width: 3.0),
                                        Container(
                                          padding:
                                              const EdgeInsets.only(left: 3.0),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.9,
                                          child: Text(
                                            snapshot.data['field'].toString(),
                                            style: TextStyle(
                                              color: Colors.blue[700],
                                            ),
                                          ),
                                        )
                                      ],
                                    );
                                  } else {
                                    return Text('');
                                  }
                                }),
                          ),

                          // Location
                          Container(
                            padding: const EdgeInsets.only(left: 6.0),
                            child: FutureBuilder(
                                future: _getUserBioData(widget.userId),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapShot) {
                                  if (snapShot.hasData) {
                                    return Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.location_on,
                                          size: 20.0,
                                          color: Colors.blue,
                                        ),
                                        SizedBox(width: 9.0),
                                        Text(
                                          snapShot.data['state'] +
                                              ', ' +
                                              snapShot.data['country'],
                                          style: TextStyle(
                                            color: Colors.blue[700],
                                          ),
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Text('');
                                  }
                                }),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        padding:
                            const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 20.0),
                        child: FutureBuilder(
                            future: _getCareerDetails(widget.userId),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return Align(
                                    alignment: Alignment.center,
                                    child: Text(snapshot.data['bio']));
                              } else {
                                return Center(
                                    child: CircularProgressIndicator());
                              }
                            }),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          uploadFileUrl.isNotEmpty
                              ? InkWell(
                                  onTap: () {
                                    showPDFViewer(context);
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blue,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(50.0),
                                      ),
                                      color: Colors.white,
                                    ),
                                    height: 30.0,
                                    width: 80.0,
                                    child: Text(
                                      'PDF CV',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            width: 5.0,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Messages(
                                      senderId: myCompanyId.toString(),
                                      candidateId: candidateId,
                                      candidateName: userName,
                                      candidateAvatar: userAvatar,
                                      senderName: recruiterName,
                                      senderAvatar: recruiterAvatar),
                                ),
                              );
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.blue,
                                ),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(50.0)),
                                color: Colors.white,
                              ),
                              height: 30.0,
                              width: 100.0,
                              child: Text(
                                'Message',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 5.0,
                          ),
                          shortlisted == true
                              ? InkWell(
                                  onTap: () {
                                    confirmDelisting(
                                        context,
                                        myCompanyId,
                                        widget.jobId,
                                        widget.docId,
                                        widget.userId);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5.0),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.green,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      color: Colors.green,
                                    ),
                                    height: 30.0,
                                    width: 100.0,
                                    child: Text(
                                      'Shortlisted',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                              : InkWell(
                                  onTap: () {
                                    _shortlisting(
                                        context,
                                        myCompanyId,
                                        widget.userId,
                                        widget.jobId,
                                        widget.docId);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(5.0),
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.blue,
                                      ),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(50.0)),
                                      color: Colors.blue,
                                    ),
                                    height: 30.0,
                                    width: 100.0,
                                    child: Text(
                                      'Shortlist',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      SizedBox(height: 15.0),
                      Container(
                        child: DefaultTabController(
                          length: 5,
                          child: Column(
                            children: <Widget>[
                              TabBar(
                                isScrollable: true,
                                labelColor: Colors.black,
                                labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 11),
                                unselectedLabelColor: Colors.grey[400],
                                unselectedLabelStyle: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 10),
                                tabs: <Widget>[
                                  Tab(
                                    icon: Icon(
                                      Icons.person,
                                      color: Colors.blue,
                                    ),
                                    child: Text('Bio'),
                                  ),
                                  Tab(
                                    icon: Icon(Icons.build, color: Colors.blue),
                                    child: Text('Career'),
                                  ),
                                  Tab(
                                    icon: Icon(Icons.work, color: Colors.blue),
                                    child: Text('Experience'),
                                  ),
                                  Tab(
                                    icon:
                                        Icon(Icons.school, color: Colors.blue),
                                    child: Text('Education'),
                                  ),
                                  Tab(
                                    icon: Icon(Icons.info, color: Colors.blue),
                                    child: Text('Portfolio'),
                                  ),
                                ],
                              ),
                              Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
                                child: TabBarView(children: <Widget>[
                                  ApplicantBio(userId: widget.userId),
                                  ApplicantCareer(userId: widget.userId),
                                  ApplicantExperience(
                                      userId: widget.userId,
                                      userAvatar: userAvatar,
                                      userName: userName),
                                  ApplicantEducation(userId: widget.userId),
                                  ApplicantPortfolio(
                                    userId: widget.userId,
                                    userAvatar: userAvatar,
                                    userName: userName,
                                  ),
                                ]),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          );
  }
}
