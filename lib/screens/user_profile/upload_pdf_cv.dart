import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_app/models/career.dart';
import 'package:job_app/models/user.dart';
import 'package:job_app/screens/user_profile/pdf_viewer.dart';
import 'package:job_app/shared/constants.dart';
import 'package:provider/provider.dart';

final GlobalKey<FormState> _formKey =
    new GlobalKey<FormState>(debugLabel: '_loginFormKey');

class UploadPdfCV extends StatefulWidget {
  String pageState;
  UploadPdfCV({Key key, this.pageState}) : super(key: key);

  @override
  _UploadPdfCVState createState() => _UploadPdfCVState();
}

class _UploadPdfCVState extends State<UploadPdfCV> {
  bool isLoading = false;
  dynamic resultUpdate;
  String _userId;
  String statusMsg = '';
  String uploadFileUrl = '';
  String errorFlag = '';
  String opStatus = '';

//-------------------------------------------------------------------------------
  Career _career = Career();
  Future<void> getUserSocialMedia() async {
    resultUpdate = await _career.getUserSocialMedia();
    print("Result: " + resultUpdate.toString());
    _facebookController.text = _career.uFacebook;
    _instagramController.text = _career.uInstagram;
    _linkedInController.text = _career.uLinkedIn;
    _snapchatController.text = _career.uSnapchat;
  }
//------------------------------------------------------------------------------

  Future getPdfAndUpload() async {
    setState(() {
      statusMsg = "Please Wait, Uploading CV...";
    });

    try {
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
        allowedExtensions: ['pdf'],
      );
      String fileName = '${randomName}.pdf';
      savePdf(file.readAsBytesSync(), fileName);
    } catch (e) {
      setState(() {
        isLoading = false;
        statusMsg = '';
      });
    }
  }

  //------------------------------------------------------------------------------

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

    setState(() {
      isLoading = true;
    });
    print("Retrieve Uploaded PDF CV");
    retrieveUploadedPDFCV();
    //isLoading = true;
    //getUserSocialMedia();
    //isLoading = false;
  }

  //----------------------------------------------------------------------------

  // check and retrieve uploaded CV

  Future<void> retrieveUploadedPDFCV() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    dynamic user = await _auth.currentUser().then((value) => value.uid);

    DocumentReference documentRef =
        Firestore.instance.collection("Pdf_CV").document(user);

    await documentRef.get().then((dataSnapshot) {
      if (dataSnapshot.exists) {
        setState(() {
          uploadFileUrl = (dataSnapshot.data['url']);
          print(uploadFileUrl.toString());
          isLoading = false;
        });
      } else {
        setState(() {
          opStatus = 'You are yet to Upload a PDF CV';
          isLoading = false;
        });
      }
    });
  }

  //----------------------------------------------------------------------------

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

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    _userId = user.uid;
    return SafeArea(
      child: Scaffold(
        body: ListView(
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
                            padding: const EdgeInsets.only(top: 10.0),
                          ),
                    Text(
                      'Career Details',
                      style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SourceSansPro'),
                    ),
                    Text(
                      'Upload PDF CV',
                      style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SourceSansPro'),
                    ),
                    Container(
                      height: 120,
                      child: isLoading
                          ? SpinKitCircle(
                              color: Colors.blueAccent,
                              size: 100.0,
                            )
                          : null,
                    ),
                    Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
                        child: uploadFileUrl == ''
                            ? Text(opStatus)
                            : IconButton(
                                icon: FaIcon(
                                  FontAwesomeIcons.filePdf,
                                  color: Colors.red,
                                  size: 45.0,
                                ),
                                onPressed: () {
                                  showPDFViewer(context);
                                },
                              )),
                    Container(
                      alignment: Alignment.center,
                      child: Text(statusMsg),
                    ),
                    SizedBox(
                      height: 30.0,
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
                                  minWidth: 70,
                                  height: 52,
                                  child: Icon(
                                    Icons.chevron_left,
                                    size: 29.0,
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              width: 135.0,
                              alignment: Alignment.center,
                              margin: EdgeInsets.only(left: 5.0),
                              child: Material(
                                color: Colors.green,
                                shadowColor: Colors.lightGreen,
                                elevation: 7.0,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                child: MaterialButton(
                                  onPressed: () async {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    getPdfAndUpload();
                                  },
                                  child: Text(
                                    'UPLOAD CV                                                                                                                           ',
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
