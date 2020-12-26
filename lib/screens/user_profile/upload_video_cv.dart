import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_app/models/career.dart';
import 'package:job_app/models/user.dart';
import 'package:job_app/screens/user_profile/pdf_viewer.dart';
import 'package:job_app/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

final GlobalKey<FormState> _formKey =
    new GlobalKey<FormState>(debugLabel: '_loginFormKey');

class UploadVideoCV extends StatefulWidget {
  String pageState;
  UploadVideoCV({Key key, this.pageState}) : super(key: key);

  @override
  _UploadVideoCVState createState() => _UploadVideoCVState();
}

class _UploadVideoCVState extends State<UploadVideoCV> {
  bool isLoading = false;
  dynamic resultUpdate = '';
  String _userId;
  String statusMsg = '';
  String uploadFileUrl = '';
  String errorFlag = '';
  File videoFile;
  String videoURL;
  String videoSource;

//-------------------------------------------------------------------------------
  Career _career = Career();

//-------------------------------------------------------------------------------

//-------------------------------------------------------------------------------

  @override
  void initState() {
    isLoading = true;
    retrieveVideoCV();
    super.initState();

    //getUserSocialMedia();
    //isLoading = false;
  }

//-------------------------------------------------------------------------------

  Future<void> retrieveVideoCV() async {
    try {
      FirebaseAuth _auth = FirebaseAuth.instance;
      dynamic user = await _auth.currentUser().then((value) => value.uid);

      DocumentReference documentRef =
          Firestore.instance.collection('Video_CV').document(user);

      await documentRef.get().then((dataSnapshot) {
        if (dataSnapshot.exists) {
          if (this.mounted) {
            setState(() {
              videoURL = (dataSnapshot).data['url'];
              videoSource = 'network';
              isLoading = false;
              print(videoURL);
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

//-------------------------------------------------------------------------------

  Future getVideoAndUpload(BuildContext context) async {
    if (this.mounted) {
      setState(() {
        statusMsg = "Please Wait, Uploading Video CV...";
      });
    }

    var rng = new Random();
    String randomName = "";
    for (var i = 0; i < 20; i++) {
      print(rng.nextInt(100));
      randomName += rng.nextInt(100).toString();
      print(randomName);
    }
    File file;
    //file = await FilePicker.getFile(type: FileType.custom, allowedExtensions: ['mp4']);
    String fileName = '${randomName}.mp4';
    print("**************** File name: " + fileName);
    saveVideo(videoFile, fileName, context);
  }

  //------------------------------------------------------------------------------

  _video() async {
    try {
      File theVid = await ImagePicker.pickVideo(source: ImageSource.gallery);
      if (this.mounted) {
        if (theVid != null) {
          setState(() {
            videoFile = theVid;
            videoSource = 'file';
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //--------------------------------------------------------------------------------

  _record() async {
    try {
      File theVid = await ImagePicker.pickVideo(source: ImageSource.camera);
      if (this.mounted) {
        if (theVid != null) {
          setState(() {
            videoFile = theVid;
            videoSource = 'file';
          });
        }
      }
    } catch (e) {
      print(e.toString());
    }
  }

  //--------------------------------------------------------------------------------

  saveVideo(File asset, String name, BuildContext context) async {
    print('*************************** Put Filename : ');
    StorageReference reference = FirebaseStorage.instance.ref().child(name);
    StorageUploadTask uploadTask =
        reference.putFile(asset, StorageMetadata(contentType: 'video/mp4'));
    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    uploadFileUrl = url;
    documentFileUpload(url, context);
  }

  //------------------------------------------------------------------------------
  void documentFileUpload(String str, BuildContext context) {
    var data = {
      'url': str,
    };

    DocumentReference documentReference =
        Firestore.instance.collection('Video_CV').document(_userId);
    documentReference.setData(data).whenComplete(() {
      print("Your Video CV has been Uploaded.");
      if (this.mounted) {
        setState(() {
          statusMsg = "Your Video CV has been Uploaded.";
          isLoading = false;
          errorFlag = '0';
        });
        showInSnackBar(statusMsg, context);
      }
    }).catchError(() {
      print("An error occurred Uploading the Video.");
      if (this.mounted) {
        setState(() {
          statusMsg = "An error occurred Uploading the Video.";
          errorFlag = '1';
          showInSnackBar(statusMsg, context);
        });
      }
    });
  }

  //------------------------------------------------------------------------

  void showPDFViewer(BuildContext context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ViewPDF(),
            settings: RouteSettings(arguments: uploadFileUrl)));
  }

  ///------------------------------------------------------------------------

  @override
  void dispose() {
    //videoPlayerController.dispose();
    //chewieController.dispose();
    super.dispose();
  }
  //--------------------------------------------------------------------------

  //-----------------------------------------------------------------------------------------
  // Snackbar function
  void showInSnackBar(String value, BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(value,
          style: TextStyle(
            color: Colors.white,
          )),
      //backgroundColor: Theme.of(context).backgroundColor,
      backgroundColor: Colors.black,
    ));
  }
  // -----------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    _userId = user.uid;
    return SafeArea(
      child: Scaffold(
        body: Builder(builder: (BuildContext context) {
          return ListView(
            children: <Widget>[
              isLoading ? LinearProgressIndicator() : Text(''),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      widget.pageState.isEmpty
                          ? Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 5.0, horizontal: 10.0),
                              child: Image(
                                image: AssetImage('images/step-2-mini.png'),
                                width: 150.0,
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.only(top: 14.0),
                            ),
                      Text(
                        'Career Details',
                        style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceSansPro'),
                      ),
                      Text(
                        'Upload Video CV',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceSansPro'),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 1.0),
                        height: 260,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(height: 5.0),
                            isLoading ? Text(statusMsg) : Text(''),
                            SizedBox(
                              height: 5.0,
                            ),
                            Container(
                              color: Colors.black,
                              height: MediaQuery.of(context).size.height *
                                  (40 / 100),
                              width: MediaQuery.of(context).size.width *
                                  (100 / 100),
                              child: videoSource == null
                                  ? Center(
                                      child: Icon(Icons.videocam,
                                          color: Colors.white, size: 80.0),
                                    )
                                  : FittedBox(
                                      fit: BoxFit.contain,
                                      child: mounted
                                          ? Chewie(
                                              controller: ChewieController(
                                                videoPlayerController:
                                                    videoSource == 'file'
                                                        ? VideoPlayerController
                                                            .file(videoFile)
                                                        : VideoPlayerController
                                                            .network(videoURL),
                                                aspectRatio: 5 / 4,
                                                autoPlay: true,
                                                looping: false,
                                              ),
                                            )
                                          : Container(),
                                    ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        alignment: Alignment.topCenter,
                        margin: EdgeInsets.only(top: 1.0, bottom: 1.0),
                        child: videoFile == null
                            ? null
                            : ButtonTheme(
                                minWidth: 150.0,
                                height: 40.0,
                                child: RaisedButton(
                                    color: Colors.green,
                                    child: Text('SAVE',
                                        style: TextStyle(color: Colors.white)),
                                    onPressed: () {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      getVideoAndUpload(context);
                                    }),
                              ),
                      ),
                      SizedBox(
                        height: 3.0,
                      ),
                      Container(
                          alignment: Alignment.center,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Container(
                                child: Material(
                                  color: Colors.grey.shade300,
                                  shadowColor: Colors.lightGreen,
                                  elevation: 7.0,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                  child: MaterialButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    minWidth: 50,
                                    height: 52,
                                    child: Icon(
                                      Icons.chevron_left,
                                      size: 29.0,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: 90.5,
                                alignment: Alignment.center,
                                margin: EdgeInsets.only(left: 5.0),
                                child: Material(
                                  color: Colors.blue,
                                  shadowColor: Colors.lightGreen,
                                  elevation: 7.0,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  child: MaterialButton(
                                    onPressed: () async {
                                      _video();
                                    },
                                    child: Text(
                                      'UPLOAD                                                                                                                           ',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    minWidth: 70,
                                    height: 52,
                                  ),
                                ),
                              ),
                              Container(
                                width: 90.0,
                                margin: EdgeInsets.only(left: 5.0),
                                alignment: Alignment.center,
                                child: Material(
                                  color: Colors.green,
                                  shadowColor: Colors.lightGreen,
                                  elevation: 7.0,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0)),
                                  child: MaterialButton(
                                    onPressed: () async {
                                      _record();
                                    },
                                    child: Text(
                                      'RECORD                                                                                                                          ',
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                    minWidth: 70,
                                    height: 52,
                                  ),
                                ),
                              ),
                            ],
                          ))
                    ],
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
