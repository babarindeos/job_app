import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'package:video_player/video_player.dart';

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
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    print("--------------" + widget.userId);

    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Container(
                  color: Colors.blue,
                  height: MediaQuery.of(context).size.height * (35 / 100),
                  width: MediaQuery.of(context).size.width * (100 / 100),
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
                                        VideoPlayerController.network(videoURL),
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
                  height: 400,
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
                          child: Image(
                            fit: BoxFit.cover,
                            image: AssetImage('images/henry_smith.jpg'),
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
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return Row(children: <Widget>[
                            Icon(
                              Icons.person,
                              color: Colors.blue[700],
                            ),
                            SizedBox(
                              width: 3.0,
                            ),
                            Text(
                              snapshot.data['name'].toString().substring(0, 18),
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
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return Row(
                            children: <Widget>[
                              Icon(
                                Icons.business_center,
                                color: Colors.blue[700],
                              ),
                              SizedBox(width: 3.0),
                              Text(
                                snapshot.data['field']
                                    .toString()
                                    .substring(0, 18),
                                style: TextStyle(color: Colors.blue[700]),
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
                      builder: (BuildContext context, AsyncSnapshot snapShot) {
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
                          return Text('Text');
                        }
                      }),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
