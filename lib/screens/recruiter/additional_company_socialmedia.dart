import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:job_app/models/career.dart';
import 'package:job_app/models/company.dart';
import 'package:job_app/models/user.dart';
import 'package:job_app/screens/user_profile/career_details.dart';
import 'package:provider/provider.dart';
import 'package:job_app/shared/constants.dart';

class AdditionalCompanySocialMedia extends StatefulWidget {
  String pageState;
  AdditionalCompanySocialMedia({this.pageState});
  @override
  _AdditionalCompanySocialMediaState createState() =>
      _AdditionalCompanySocialMediaState();
}

class _AdditionalCompanySocialMediaState
    extends State<AdditionalCompanySocialMedia> {
  @override
  bool isloading = false;
  dynamic result;
  String processOutcome = '';

  Career _career = Career();
  Company _company = Company();

  final _formKey = GlobalKey<FormState>();

  //----------------------------------------------------------------------------
  void updateAddCompanySocialMedia(String userId, BuildContext context) async {
    print(userId.toString());

    result = await _company.updateCompanySocialMediaInfo(
        userId,
        _facebookController.text,
        _twitterController.text,
        _linkedInController.text,
        _instagramController.text);
    processOutcome = _company.updateStatus.toString();
    showInSnackBar(processOutcome, context);
    setState(() {
      isloading = false;
    });
  }

  //---------------------------------------------------------------------------

  Widget showLoader() {
    return Center(
      child: Container(
        child: SpinKitChasingDots(
          color: Colors.blueAccent,
        ),
      ),
    );
  }

  //----------------------------------------------------------------------------

  TextEditingController _facebookController = TextEditingController();
  TextEditingController _twitterController = TextEditingController();
  TextEditingController _linkedInController = TextEditingController();
  TextEditingController _instagramController = TextEditingController();

  //----------------------------------------------------------------------------
  void showInSnackBar(String value, BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value,
          style: TextStyle(color: Colors.white),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }

  //----------------------------------------------------------------------------

  Future<void> retrieveAboutCompanyInfo() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    dynamic _currentUser = await _auth.currentUser().then((value) => value.uid);

    DocumentReference documentRef =
        Firestore.instance.collection("Company").document(_currentUser);
    await documentRef.get().then((dataSnapshot) {
      if (dataSnapshot.exists) {
        _facebookController.text = (dataSnapshot).data['facebook'];
        _twitterController.text = (dataSnapshot).data['twitter'];
        _linkedInController.text = (dataSnapshot).data['linkedin'];
        _instagramController.text = (dataSnapshot).data['instagram'];
        //print(dataSnapshot.data['']);
      }
    });

    setState(() {
      isloading = false;
    });
  }

  //----------------------------------------------------------------------------

  @override
  void initState() {
    isloading = true;
    retrieveAboutCompanyInfo();
    super.initState();
  }

  //----------------------------------------------------------------------------

  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return SafeArea(
      child: Scaffold(
        body: Builder(builder: (BuildContext context) {
          return ListView(children: <Widget>[
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
                          widget.pageState.isEmpty
                              ? Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 10.0),
                                  child: Image(
                                    image: AssetImage('images/step-3-mini.png'),
                                    width: 150.0,
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.only(top: 30.0),
                                ),
                          Text(
                            'Additional Information',
                            style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SourceSansPro'),
                          ),
                          Text(
                            'Social Media',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SourceSansPro'),
                          ),
                          SizedBox(height: 10.0),
                          SizedBox(height: 20.0),
                          TextFormField(
                            controller: _facebookController,
                            keyboardType: TextInputType.text,
                            decoration: profileTextInputDecoration.copyWith(
                                labelText: 'Facebook'),
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            controller: _twitterController,
                            keyboardType: TextInputType.text,
                            decoration: profileTextInputDecoration.copyWith(
                                labelText: 'Twitter'),
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            controller: _linkedInController,
                            keyboardType: TextInputType.text,
                            decoration: profileTextInputDecoration.copyWith(
                                labelText: 'LinkedIn'),
                          ),
                          SizedBox(height: 10.0),
                          TextFormField(
                            controller: _instagramController,
                            keyboardType: TextInputType.text,
                            decoration: profileTextInputDecoration.copyWith(
                                labelText: 'Instagram'),
                          ),
                          SizedBox(
                            height: 15.0,
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
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        setState(() {
                                          isloading = true;
                                        });

                                        updateAddCompanySocialMedia(
                                            user.uid, context);
                                      }
                                    },
                                    child: Text(
                                      'SAVE',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.0),
                                    ),
                                    minWidth: 120.0,
                                    height: 52.0,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]),
                  ),
                ],
              ),
            ),
          ]);
        }),
      ),
    );
  }
}
