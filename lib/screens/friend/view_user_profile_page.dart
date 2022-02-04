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

class ViewUserProfilePage extends StatefulWidget {
  String userId;

  ViewUserProfilePage({
    this.userId,
  });

  @override
  _ViewUserProfilePageState createState() => _ViewUserProfilePageState();
}

class _ViewUserProfilePageState extends State<ViewUserProfilePage> {
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
    videoPlayerController.pause();

    // TODO: implement dispose
    super.dispose();
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
