import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
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
  UploadVideoCV({Key key}) : super(key: key);

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
//-------------------------------------------------------------------------------
  Career _career = Career();

//------------------------------------------------------------------------------

  Future getPdfAndUpload() async {
    setState(() {
      statusMsg = "Please Wait, Uploading CV...";
    });

    var rng = new Random();
    String randomName = "";
    for (var i = 0; i < 20; i++) {
      print(rng.nextInt(100));
      randomName += rng.nextInt(100).toString();
      print(randomName);
    }
    File file;
    file = await FilePicker.getFile(
      type: FileType.custom,
    );
    String fileName = '${randomName}.pdf';
    savePdf(file.readAsBytesSync(), fileName);
  }

  //------------------------------------------------------------------------------

  _video() async {
    File theVid = await ImagePicker.pickVideo(source: ImageSource.gallery);
    if (theVid != null) {
      setState(() {
        videoFile = theVid;
      });
    }
  }

  //--------------------------------------------------------------------------------

  _record() async {
    File theVid = await ImagePicker.pickVideo(source: ImageSource.camera);
    if (theVid != null) {
      setState(() {
        videoFile = theVid;
      });
    }
  }

  //--------------------------------------------------------------------------------

  savePdf(List<int> asset, String name) async {
    StorageReference reference = FirebaseStorage.instance.ref().child(name);
    StorageUploadTask uploadTask = reference.putData(asset);
    String url = await (await uploadTask.onComplete).ref.getDownloadURL();
    uploadFileUrl = url;
    documentFileUpload(url);
  }

  //------------------------------------------------------------------------------
  void documentFileUpload(String str) {
    var data = {
      'url': str,
    };

    DocumentReference documentReference =
        Firestore.instance.collection('Pdf_CV').document(_userId);
    documentReference.setData(data).whenComplete(() {
      print("Your PDF CV has been Uploaded.");
      setState(() {
        statusMsg = "Your PDF CV has been Uploaded.";
        isLoading = false;
        errorFlag = '0';
      });
    }).catchError(() {
      print("An error occurred Uploading the file.");
      setState(() {
        statusMsg = "An error occurred Uploading the file.";
        errorFlag = '1';
      });
    });
  }

  //-----------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    //isLoading = true;
    //getUserSocialMedia();
    //isLoading = false;
  }

  //-------------------------------------------------------------------------

  TextEditingController _facebookController = TextEditingController();
  TextEditingController _instagramController = TextEditingController();
  TextEditingController _linkedInController = TextEditingController();
  TextEditingController _snapchatController = TextEditingController();

  //-------------------------------------------------------------------------
  Future<String> updateSocialMedia(String userId) async {
    _career.uFacebook = _facebookController.text;
    _career.uInstagram = _instagramController.text;
    _career.uLinkedIn = _linkedInController.text;
    _career.uSnapchat = _snapchatController.text;

    resultUpdate = await _career.updateSocialMedia(userId);
    return resultUpdate;
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
  ///

  @override
  void dispose() {
    //videoPlayerController.dispose();
    //chewieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    _userId = user.uid;
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            //isLoading ? LinearProgressIndicator() : Text(''),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      child: Image(
                        image: AssetImage('images/step-2-mini.png'),
                        width: 150.0,
                      ),
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
                      height: 250,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          isLoading
                              ? SpinKitCircle(
                                  color: Colors.blueAccent,
                                  size: 20.0,
                                )
                              : Text(''),
                          Container(
                            color: Colors.black,
                            height:
                                MediaQuery.of(context).size.height * (40 / 100),
                            width:
                                MediaQuery.of(context).size.width * (100 / 100),
                            child: videoFile == null
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
                                                  VideoPlayerController.file(
                                                      videoFile),
                                              aspectRatio: 5 / 4,
                                              autoPlay: true,
                                              looping: true,
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
                            : RaisedButton(
                                color: Colors.green,
                                child: Text('SAVE',
                                    style: TextStyle(color: Colors.white)),
                                onPressed: () {
                                  setState(() {
                                    isLoading = true;
                                  });
                                })),
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
        ),
      ),
    );
  }
}
