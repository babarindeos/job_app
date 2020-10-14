import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_app/models/career.dart';
import 'package:job_app/models/company.dart';
import 'package:job_app/models/storage.dart';
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

//final GlobalKey<FormState> _formKey =
//new GlobalKey<FormState>(debugLabel: '_loginFormKey');

final _formKey = GlobalKey<FormState>();

class AboutOrganisation extends StatefulWidget {
  String userType;
  AboutOrganisation({this.userType});
  @override
  _AboutOrganisationState createState() => _AboutOrganisationState();
}

class _AboutOrganisationState extends State<AboutOrganisation> {
  File _image, file;
  Career _career = Career();
  bool isloading = false;
  bool isfetching = false;
  bool isbtnForwardEnabled = false;
  String imageSource;
  String imageUrl;
  String processOutcome;

  final Storage _storage = Storage();
  final Company _company = Company();

  //----------------------------------------------------------------------------------------

  TextEditingController _companyNameController = TextEditingController();
  TextEditingController _sectorController = TextEditingController();
  TextEditingController _aboutCompanyController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  //-----------------------------------------------------------------------------------------

  void processForm(String userId, BuildContext context) async {
    _company.uCompanyName = _companyNameController.text;
    _company.uSector = _sectorController.text;
    _company.uAboutCompany = _aboutCompanyController.text;
    _company.uAddress = _addressController.text;
    _company.uPhone = _phoneController.text;
    _company.uEmail = _emailController.text;

    //dynamic result = await _career.updateCareerDetails(userId);
    dynamic result = await _company.updateCompanyInfo(userId);
    if (_company.updateStatus == "success") {
      processOutcome = "Company Information has been Updated.";
      setState(() {
        isbtnForwardEnabled = true;
      });
    } else {
      processOutcome = "An error has occurred updating Company Info";
    }

    setState(() {
      isloading = false;
    });

    showInSnackBar(processOutcome, context);
  }

  //-----------------------------------------------------------------------------------------

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

//-----------------------------------------------------------------------------------------------

  Widget showUploadedLogo() {
    if (imageSource == 'file' && imageUrl != null) {
      return Image.file(_image, fit: BoxFit.fill);
    } else if (imageSource == 'url' && imageUrl != null) {
      print(imageUrl);
      return Image.network(imageUrl, fit: BoxFit.fill);
    }

    return Image(
      image: AssetImage('images/company_logo.jpg'),
    );
  }

//-----------------------------------------------------------------------------------------------
  Future getImage() async {
    dynamic image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      _storage.pFile = image;
      imageSource = 'file';
    });
  }
//-----------------------------------------------------------------------------------------------

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

//-----------------------------------------------------------------------------------------------
  Future<void> retrieveCompanyInfo() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    dynamic user = await _auth.currentUser().then((value) => value.uid);
    print(user.toString());

    DocumentReference docReference =
        Firestore.instance.collection("Company").document(user);
    await docReference.get().then((dataSnapshot) {
      if (dataSnapshot.exists) {
        setState(() {
          _companyNameController.text = dataSnapshot.data['name'];
          _sectorController.text = dataSnapshot.data['sector'];
          // _aboutCompanyController.text = dataSnapshot.data['about'];
          _addressController.text = dataSnapshot.data['address'];
          // _phoneController.text = dataSnapshot.data['phone'];
          _emailController.text = dataSnapshot.data['email'];

          isbtnForwardEnabled = true;
        });
      }
    });

    setState(() {
      isfetching = false;
    });
  }
//-----------------------------------------------------------------------------------------------

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    isfetching = true;
    retrieveCompanyInfo();
  }

//------------------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return SafeArea(child: Scaffold(
      body: Builder(builder: (BuildContext context) {
        return isfetching
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: <Widget>[
                  isloading ? LinearProgressIndicator() : Container(),
                  Container(
                    alignment: Alignment.center,
                    padding:
                        EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
                    child: Form(
                      key: _formKey,
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
                            'About Company',
                            style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SourceSansPro'),
                          ),
                          SizedBox(height: 3.0),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                CircleAvatar(
                                  radius: 50.0,
                                  backgroundColor: Colors.blue,
                                  child: CircleAvatar(
                                    radius: 49,
                                    backgroundColor: Colors.white,
                                    child: ClipOval(
                                      child: SizedBox(
                                        width: 100,
                                        height: 180,
                                        child: imageSource != null
                                            ? showUploadedLogo()
                                            : Image(
                                                image: AssetImage(
                                                    'images/company_logo.jpg'),
                                              ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    top: 20.0,
                                  ),
                                  child: IconButton(
                                      icon: Icon(
                                        FontAwesomeIcons.camera,
                                        size: 30.0,
                                      ),
                                      onPressed: () {
                                        getImage();
                                      }),
                                ),
                              ]),
                          SizedBox(height: 10.0),
                          Container(
                            child: TextFormField(
                              controller: _companyNameController,
                              validator: (value) => value.isEmpty
                                  ? 'Company name is required'
                                  : null,
                              decoration: profileTextInputDecoration.copyWith(
                                  labelText: 'Company name'),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Container(
                            child: TextFormField(
                              controller: _sectorController,
                              keyboardType: TextInputType.text,
                              validator: (value) =>
                                  value.isEmpty ? 'Sector is required' : null,
                              decoration: profileTextInputDecoration.copyWith(
                                  labelText: 'Sector'),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Container(
                            child: TextFormField(
                              controller: _addressController,
                              validator: (value) =>
                                  value.isEmpty ? 'Address is required' : null,
                              decoration: profileTextInputDecoration.copyWith(
                                  labelText: 'Address'),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: TextFormField(
                              controller: _emailController,
                              validator: (value) =>
                                  value.isEmpty ? 'Email is required' : null,
                              decoration: profileTextInputDecoration.copyWith(
                                  labelText: 'Email'),
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
                                        Navigator.popAndPushNamed(
                                            context, '/profile');
                                        //moveToCareerDetails(context);
                                      },
                                    )),
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  padding:
                                      EdgeInsets.only(left: 5.0, right: 5.0),
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
                                        if (_formKey.currentState.validate()) {
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
                                              Navigator.pushNamed(context,
                                                  '/additionalCompanyInfo');
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
      }),
    ));
  }
}
