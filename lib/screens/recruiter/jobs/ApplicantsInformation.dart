import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:job_app/screens/recruiter/jobs/applicant_education.dart';
import 'package:job_app/screens/recruiter/jobs/applicant_experience.dart';
import 'package:video_player/video_player.dart';
import 'package:tabbar/tabbar.dart';

class ApplicantsInformation extends StatefulWidget {
  String userId, jobId, docId, dateApplied;
  DocumentSnapshot documentSnapshot;

  ApplicantsInformation(
      {this.userId,
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

//--------------------------------------------------------------------------------
  Future<void> retrieveAvatar() async {
    try {
      DocumentReference docReference =
          Firestore.instance.collection('BioData').document(widget.userId);
      await docReference.get().then((dataSnapshot) {
        if (dataSnapshot.exists) {
          setState(() {
            userAvatar = dataSnapshot['avatar'];
            print(userAvatar);
          });
        }
      });
    } catch (e) {} finally {
      setState(() {
        isLoading = false;
      });
    }
  }

//-------------------------------------------------------------------------------

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
              isLoading = false;
              print("*------------------------------------" + videoURL);
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

  @override
  void initState() {
    // TODO: implement initState
    isLoading = true;
    super.initState();
    retrieveAvatar();
    retrieveVideoCV();
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
  Widget build(BuildContext context) {
    print("--------------" + widget.userId);

    return isLoading
        ? Center(child: CircularProgressIndicator())
        : SafeArea(
            child: Scaffold(
              body: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          color: Colors.blue,
                          height:
                              MediaQuery.of(context).size.height * (35 / 100),
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
                                                VideoPlayerController.network(
                                                    videoURL),
                                            aspectRatio: 8 / 5,
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
                          top: 180.0,
                          right: 7.0,
                          left: 11.0,
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: CircleAvatar(
                              radius: 45.0,
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
                        Positioned(
                          top: 205.0,
                          left: 105.0,
                          right: 2.0,
                          child: FutureBuilder(
                              future: _getUserBioData(widget.userId),
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  return Row(children: <Widget>[
                                    Icon(
                                      Icons.person,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(
                                      width: 3.0,
                                    ),
                                    snapshot.data.toString().length > 18
                                        ? Text(
                                            snapshot.data['name']
                                                .toString()
                                                .substring(0, 18),
                                            style: TextStyle(
                                                fontFamily: 'SourceSansPro',
                                                fontSize: 17.0,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.blue[700]),
                                          )
                                        : Text(
                                            snapshot.data['name'],
                                            style: TextStyle(
                                              fontFamily: 'SourceSansPro',
                                              fontSize: 17.0,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.blue[700],
                                            ),
                                          ),
                                  ]);
                                } else {
                                  return Text('');
                                }
                              }),
                        ),
                        Positioned(
                          top: 226.0,
                          left: 105.0,
                          right: 2.0,
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
                                      Text(
                                        snapshot.data['field']
                                            .toString()
                                            .substring(0, 18),
                                        style:
                                            TextStyle(color: Colors.blue[700]),
                                      ),
                                    ],
                                  );
                                } else {
                                  return Text('');
                                }
                              }),
                        ),
                        SizedBox(
                          height: 20.0,
                        ),
                        Positioned(
                          top: 249.0,
                          left: 107.0,
                          right: 2.0,
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
                                      SizedBox(width: 5.0),
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
                        )
                      ],
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 20.0),
                      child: FutureBuilder(
                          future: _getCareerDetails(widget.userId),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return Align(
                                  alignment: Alignment.center,
                                  child: Text(snapshot.data['bio']));
                            } else {
                              return Center(child: CircularProgressIndicator());
                            }
                          }),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            print("Am here");
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
                        InkWell(
                          onTap: () {
                            print("Am here");
                          },
                          child: Container(
                            padding: const EdgeInsets.all(5.0),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.blue,
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50.0)),
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
                        length: 3,
                        child: Column(
                          children: <Widget>[
                            TabBar(
                              labelColor: Colors.black,
                              labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 11),
                              unselectedLabelColor: Colors.grey[400],
                              unselectedLabelStyle: TextStyle(
                                  fontWeight: FontWeight.normal, fontSize: 10),
                              tabs: <Widget>[
                                Tab(
                                  icon: Icon(Icons.work, color: Colors.blue),
                                  child: Text('Experience'),
                                ),
                                Tab(
                                  icon: Icon(Icons.school, color: Colors.blue),
                                  child: Text('Education'),
                                ),
                                Tab(
                                  icon: Icon(Icons.info, color: Colors.blue),
                                  child: Text('Portfolio'),
                                ),
                              ],
                            ),
                            Container(
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: TabBarView(children: <Widget>[
                                ApplicantExperience(userId: widget.userId),
                                ApplicantEducation(userId: widget.userId),
                                Text('Tab 3'),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
