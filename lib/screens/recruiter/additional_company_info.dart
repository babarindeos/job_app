import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:job_app/models/education.dart';
import 'package:job_app/models/user.dart';
import 'package:job_app/screens/user_profile/additional_info_bio.dart';
import 'package:job_app/screens/user_profile/experience/additional_info_experience.dart';
import 'package:job_app/screens/user_profile/portfolio/additional_info_portfolio.dart';
import 'package:provider/provider.dart';

class FormKeys {
  static final frmKey1 = GlobalKey<FormState>();
  static final frmKey2 = const Key('__R1KEY2__');
  static final frmKey3 = const Key('__R1KEY3__');
}

final GlobalKey<FormState> _formKey =
    new GlobalKey<FormState>(debugLabel: '_loginFormKey');

class AdditionalCompanyInfo extends StatefulWidget {
  @override
  _AdditionalCompanyInfoState createState() => _AdditionalCompanyInfoState();
}

class _AdditionalCompanyInfoState extends State<AdditionalCompanyInfo> {
  bool isloading = false;
  bool isfetching = false;
  String _companyName = '';
  dynamic _currentUser;
  String _profession = '';

//------------------------------------------------------------------------------
  Widget showLoader() {
    return Center(
      child: SpinKitDoubleBounce(
        color: Colors.blueAccent,
        size: 100.0,
      ),
    );
  }

// -----------------------------------------------------------------------------
  Future<void> getCurrentUser() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    _currentUser = await _auth.currentUser().then((value) => value.uid);
    print(_currentUser.toString());

    retrieveCompanyInfo();
    retrieveUserProfession();
  }
//------------------------------------------------------------------------------

  Future<void> retrieveCompanyInfo() async {
    // Get User Bio
    DocumentReference documentRef =
        Firestore.instance.collection("Company").document(_currentUser);

    await documentRef.get().then((dataSnapshot) {
      if (dataSnapshot.exists) {
        setState(() {
          _companyName = (dataSnapshot).data['name'];
          print(_companyName);
        });
      } else {
        setState(() {
          _companyName = '';
        });
      }
    });
  }

//------------------------------------------------------------------------------

  Future<void> retrieveUserProfession() async {
    DocumentReference documentRef =
        Firestore.instance.collection("CareerDetails").document(_currentUser);
    await documentRef.get().then((dataSnapshot) {
      if (dataSnapshot.exists) {
        setState(() {
          _profession = (dataSnapshot).data['field'];
          isfetching = false;
        });
      } else {
        setState(() {
          _profession = '';
          isfetching = false;
        });
      }
    });
  }

//------------------------------------------------------------------------------
  @override
  void initState() {
    // TODO: implement initState
    print(
        "******************************Retrieve User Bio-Data ***************************");
    isfetching = true;
    getCurrentUser();

    super.initState();
  }

//------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return SafeArea(
        child: Scaffold(
      body: isfetching
          ? Center(child: CircularProgressIndicator())
          : ListView(children: <Widget>[
              isloading ? LinearProgressIndicator() : Container(),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
                child: Stack(
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            child: Image(
                              image: AssetImage('images/step-3-mini.png'),
                              width: 150.0,
                            ),
                          ),
                          Text(
                            'Additional Information',
                            style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SourceSansPro'),
                          ),
                          SizedBox(height: 20.0),
                          SizedBox(height: 20.0),
                          Card(
                            elevation: 5.0,
                            child: Container(
                              padding: EdgeInsets.only(top: 10.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    height: 95.0,
                                    padding: EdgeInsets.all(7.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        Text(
                                          _companyName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22.0,
                                            fontFamily: 'SourceSansPro',
                                          ),
                                        ),
                                        Text('')
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AdditionalInfoBio()),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.all(7.0),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                width: 1.0,
                                                color: Colors.grey.shade300,
                                              ),
                                              top: BorderSide(
                                                width: 1.0,
                                                color: Colors.grey.shade300,
                                              ))),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: 5.0, bottom: 5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: Icon(Icons.person,
                                                  color: Colors.blue.shade700),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Text(
                                                'About',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Icon(Icons.chevron_right,
                                                  color: Colors.grey.shade700),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AdditionalInfoPortfolio()),
                                      );
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          top: 5.0, bottom: 5.0),
                                      decoration: BoxDecoration(
                                          border: Border(
                                        bottom: BorderSide(
                                          width: 1.0,
                                          color: Colors.grey.shade300,
                                        ),
                                      )),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: Icon(
                                                  Icons.insert_drive_file,
                                                  color: Colors.blue.shade700),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Text(
                                                'Contact',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Icon(Icons.chevron_right,
                                                  color: Colors.grey.shade700),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {},
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          top: 5.0, bottom: 5.0),
                                      decoration: BoxDecoration(
                                          border: Border(
                                        bottom: BorderSide(
                                          width: 1.0,
                                          color: Colors.grey.shade300,
                                        ),
                                      )),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: Icon(Icons.business_center,
                                                  color: Colors.blue.shade700),
                                            ),
                                            Expanded(
                                              flex: 4,
                                              child: Text(
                                                'Social Media',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16.0),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Icon(Icons.chevron_right,
                                                  color: Colors.grey.shade700),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 10.0),
                        ],
                      ),
                    ),
                    Positioned(
                      top: 80.0,
                      right: 50.0,
                      left: 50.0,
                      child: Center(
                        child: Container(
                          alignment: Alignment.center,
                          child: CircleAvatar(
                            radius: 40.0,
                            backgroundColor: Colors.blue,
                            child: CircleAvatar(
                              radius: 39.0,
                              child: ClipOval(
                                child: SizedBox(
                                  width: 100,
                                  height: 180,
                                  child: Image(
                                    fit: BoxFit.cover,
                                    image: AssetImage(
                                      'images/company_logo.jpg',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Material(
                      color: Colors.grey[400],
                      shadowColor: Colors.lightGreen,
                      elevation: 7.0,
                      borderRadius: BorderRadius.all(
                        Radius.circular(6.0),
                      ),
                      child: MaterialButton(
                          child: Icon(
                            Icons.chevron_left,
                            size: 40.0,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          minWidth: 70.0,
                          height: 52.0),
                    ),
                    SizedBox(
                      width: 6.0,
                    ),
                    Material(
                      color: Colors.green,
                      shadowColor: Colors.lightGreen,
                      elevation: 7.0,
                      borderRadius: BorderRadius.all(
                        Radius.circular(6.0),
                      ),
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                              context, '/recruiterHome');
                        },
                        child: Text(
                          'SKIP',
                          style: TextStyle(color: Colors.white, fontSize: 16.0),
                        ),
                        minWidth: 120.0,
                        height: 52.0,
                      ),
                    ),
                  ],
                ),
              )
            ]),
    ));
  }
}
