import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:job_app/models/career.dart';
import 'package:job_app/models/user.dart';
import 'package:job_app/screens/user_profile/socialmedia_page.dart';
import 'package:job_app/screens/user_profile/upload_pdf_cv.dart';
import 'package:job_app/screens/user_profile/upload_video_cv.dart';
import 'package:job_app/shared/constants.dart';
import 'package:provider/provider.dart';
//import 'package:flutter/widgets.dart';

class FormKeys {
  static final frmKey1 = GlobalKey<FormState>();
  static final frmKey2 = const Key('__R1KEY2__');
  static final frmKey3 = const Key('__R1KEY3__');
}

//final GlobalKey<FormState> _formKeyCareer = new GlobalKey<FormState>();
final _formKeyCareer = GlobalKey<FormState>();

class CareerDetails extends StatefulWidget {
  @override
  _CareerDetailsState createState() => _CareerDetailsState();
}

class _CareerDetailsState extends State<CareerDetails> {
  bool isLoading = true;
  Career _career = Career();
  bool isloading = false;
  bool isbtnForwardEnabled = false;

  //----------------------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    isloading = true;
    print("Retrieve Career Details");
    retrieveCareerDetails();
  }

  //----------------------------------------------------------------------------------------
  // Retrieve career Details
  Future<void> retrieveCareerDetails() async {
    print("********************* RETRIEVING CAREER DETAILS.....");
    FirebaseAuth _auth = FirebaseAuth.instance;
    dynamic user = await _auth.currentUser().then((value) => value.uid);

    print(user);

    DocumentReference documentRef =
        Firestore.instance.collection("CareerDetails").document(user);
    await documentRef.get().then((dataSnapshot) {
      if (dataSnapshot.exists) {
        setState(() {
          _fieldController.text = (dataSnapshot.data['field']);
          _experienceController.text = (dataSnapshot.data['experience']);
          _bioController.text = (dataSnapshot.data['bio']);

          isbtnForwardEnabled = true;
        });
      }
    });

    setState(() {
      isloading = false;
    });
  }

  //-----------------------------------------------------------------------------------------

  TextEditingController _fieldController = TextEditingController();
  TextEditingController _experienceController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  //-----------------------------------------------------------------------------------------

  void processForm(String userId, BuildContext context) async {
    setState(() {
      isloading = true;
    });
    _career.uField = _fieldController.text;
    _career.uExperience = _experienceController.text;
    _career.uBio = _bioController.text;

    dynamic result = await _career.updateCareerDetails(userId);
    String message = '';
    if (_career.updateStatus == 'success') {
      message = "Career Details has been Updated.";
    } else {
      message = "Update failed..check your Internet Connection";
    }
    showInSnackBar(message, context);
    //print("**************** result " + _career.updateStatus);
    setState(() {
      isloading = false;
      isbtnForwardEnabled = true;
    });
  }

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

  Widget showLoader() {
    return Center(
      child: SpinKitDoubleBounce(
        color: Colors.blueAccent,
        size: 100.0,
      ),
    );
  }
//-----------------------------------------------------------------------------------------------

  void loadSocialMediaPage(BuildContext ctx) {
    Navigator.push(
      ctx,
      MaterialPageRoute(builder: (ctx) => SocialMediaPage()),
    );
  }

//-----------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return SafeArea(
      child: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            return ListView(
              children: <Widget>[
                isloading ? LinearProgressIndicator() : Text(''),
                Container(
                  alignment: Alignment.center,
                  padding:
                      EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
                  child: Form(
                    key: _formKeyCareer,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(
                              vertical: 5.0, horizontal: 10.0),
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
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: EdgeInsets.only(right: 5.0),
                                child: TextFormField(
                                  controller: _fieldController,
                                  validator: (value) => value.isEmpty
                                      ? 'Field is required'
                                      : null,
                                  decoration: profileTextInputDecoration
                                      .copyWith(labelText: 'Profession'),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Container(
                                child: TextFormField(
                                  controller: _experienceController,
                                  keyboardType: TextInputType.number,
                                  validator: (value) => value.isEmpty
                                      ? 'Experience is required'
                                      : null,
                                  decoration: profileTextInputDecoration
                                      .copyWith(labelText: 'Experience'),
                                ),
                              ),
                            )
                          ],
                        ),
                        SizedBox(height: 5.0),
                        Row(
                          children: <Widget>[
                            Expanded(
                                flex: 4,
                                child: Container(
                                  padding: EdgeInsets.only(right: 0.0),
                                  child: TextFormField(
                                    controller: _bioController,
                                    keyboardType: TextInputType.multiline,
                                    maxLines: 2,
                                    validator: (value) => value.isEmpty
                                        ? 'Career Interests is required'
                                        : null,
                                    decoration:
                                        profileTextInputDecoration.copyWith(
                                            labelText:
                                                'Career Interests & Specialty'),
                                  ),
                                )),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Text('CV',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17.0,
                                    )),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 2.0),
                        Card(
                          elevation: 5.0,
                          child: Container(
                            padding: EdgeInsets.all(0.0),
                            child: Column(
                              children: <Widget>[
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UploadPdfCV()));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(7.0),
                                    decoration: BoxDecoration(
                                        border: Border(
                                      bottom: BorderSide(
                                        width: 1.0,
                                        color: Colors.grey.shade300,
                                      ),
                                    )),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 3,
                                          child: Text('Upload Resume',
                                              style: TextStyle(
                                                  color: Colors.blue.shade700,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Icon(Icons.file_upload,
                                              color: Colors.grey.shade700),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                UploadVideoCV()));
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(7.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 3,
                                          child: Text('Video CV',
                                              style: TextStyle(
                                                  color: Colors.blue.shade700,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Icon(Icons.chevron_right,
                                              color: Colors.grey.shade700),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Text('Social Media',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    )),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 1.0),
                        InkWell(
                          onTap: () {
                            loadSocialMediaPage(context);
                          },
                          child: Card(
                            elevation: 5.0,
                            child: Container(
                              padding: EdgeInsets.all(1.0),
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            children: <Widget>[
                                              Icon(
                                                FontAwesomeIcons.facebookF,
                                                size: 15.0,
                                                color: Colors.grey.shade600,
                                              ),
                                              SizedBox(width: 3.0),
                                              Text(
                                                'Facebook',
                                                style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                  FontAwesomeIcons
                                                      .instagramSquare,
                                                  size: 15.0,
                                                  color: Colors.grey.shade600),
                                              SizedBox(width: 3.0),
                                              Text(
                                                'Instagram',
                                                style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            children: <Widget>[
                                              Icon(FontAwesomeIcons.linkedin,
                                                  size: 15.0,
                                                  color: Colors.grey.shade600),
                                              SizedBox(width: 3.0),
                                              Text('LinkedIn',
                                                  style: TextStyle(
                                                      color:
                                                          Colors.grey.shade700,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          flex: 2,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                  FontAwesomeIcons
                                                      .snapchatSquare,
                                                  color: Colors.grey.shade700,
                                                  size: 15.0),
                                              SizedBox(width: 3.0),
                                              Text(
                                                'Snapchat',
                                                style: TextStyle(
                                                    color: Colors.grey.shade600,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: Material(
                                  color: Colors.grey[200],
                                  shadowColor: Colors.lightGreen,
                                  elevation: 7.0,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                  child: MaterialButton(
                                    minWidth: 70,
                                    height: 52,
                                    child: Icon(
                                      Icons.arrow_back_ios,
                                      size: 29.0,
                                    ),
                                    onPressed: () {
                                      //Navigator.pushNamed(context, '/profile');
                                      //moveToCareerDetails(context);
                                      Navigator.popAndPushNamed(
                                          context, '/profile');
                                    },
                                  )),
                            ),
                            Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                width: 135.0,
                                child: Material(
                                  color: Colors.green,
                                  shadowColor: Colors.lightGreen,
                                  elevation: 7.0,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                  child: MaterialButton(
                                    minWidth: 135,
                                    height: 52,
                                    child: Text(
                                      'SAVE',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () {
                                      if (_formKeyCareer.currentState
                                          .validate()) {
                                        setState(() {
                                          isloading = true;
                                        });
                                        processForm(user.uid, context);
                                      }
                                    },
                                  ),
                                )),
                            Container(
                              child: Material(
                                color: Colors.grey[200],
                                shadowColor: Colors.lightGreen,
                                elevation: 7.0,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(5.0),
                                ),
                                child: MaterialButton(
                                    minWidth: 70,
                                    height: 52,
                                    child: Icon(
                                      Icons.arrow_forward_ios,
                                      size: 29.0,
                                    ),
                                    onPressed: isbtnForwardEnabled
                                        ? () {
                                            Navigator.pushNamed(
                                                context, '/additionalInfo');
                                          }
                                        : null),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
