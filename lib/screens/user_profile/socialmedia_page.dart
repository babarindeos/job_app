import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:job_app/models/career.dart';
import 'package:job_app/models/user.dart';
import 'package:job_app/shared/constants.dart';
import 'package:provider/provider.dart';

final GlobalKey<FormState> _formKey =
    new GlobalKey<FormState>(debugLabel: '_loginFormKey');

class SocialMediaPage extends StatefulWidget {
  SocialMediaPage({Key key}) : super(key: key);

  @override
  _SocialMediaPageState createState() => _SocialMediaPageState();
}

class _SocialMediaPageState extends State<SocialMediaPage> {
  bool isLoading = false;
  dynamic resultUpdate;
  String processOutcome;

  Career _career = Career();

//-------------------------------------------------------------------------------

  getUserSocialMedia() async {
    resultUpdate = await _career.getUserSocialMedia();

    setState(() {
      _facebookController.text = _career.uFacebook;
      _instagramController.text = _career.uInstagram;
      _linkedInController.text = _career.uLinkedIn;
      _snapchatController.text = _career.uSnapchat;

      isLoading = false;
    });
  }

  //-----------------------------------------------------------------------

//-------------------------------------------------------------------------

  TextEditingController _facebookController = TextEditingController();
  TextEditingController _instagramController = TextEditingController();
  TextEditingController _linkedInController = TextEditingController();
  TextEditingController _snapchatController = TextEditingController();

//-------------------------------------------------------------------------
  Future<String> updateSocialMedia(String userId, BuildContext context) async {
    _career.uFacebook = _facebookController.text;
    _career.uInstagram = _instagramController.text;
    _career.uLinkedIn = _linkedInController.text;
    _career.uSnapchat = _snapchatController.text;

    resultUpdate = await _career.updateSocialMedia(userId);
    processOutcome = _career.updateStatus;

    setState(() {
      isLoading = false;
    });
    showInSnackBar(processOutcome, context);
    return resultUpdate;
  }

//------------------------------------------------------------------------------

  void showInSnackBar(String value, BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        duration: Duration(seconds: 3),
      ),
    );
  }

//------------------------------------------------------------------------------

  @override
  void initState() {
    isLoading = true;
    getUserSocialMedia();
    super.initState();
  }
//-----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return SafeArea(
      child: Scaffold(
        body: Builder(builder: (BuildContext context) {
          return ListView(
            children: <Widget>[
              isLoading ? LinearProgressIndicator() : Container(),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
                child: Form(
                  child: Column(
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
                      Text(
                        'Social Media Handles',
                        style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceSansPro'),
                      ),
                      SizedBox(height: 20.0),
                      Container(
                        child: TextFormField(
                          controller: _facebookController,
                          decoration: profileTextInputDecoration.copyWith(
                              labelText: 'Facebook'),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        child: TextFormField(
                          controller: _instagramController,
                          decoration: profileTextInputDecoration.copyWith(
                              labelText: 'Instagram'),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                        child: TextFormField(
                          controller: _linkedInController,
                          decoration: profileTextInputDecoration.copyWith(
                              labelText: 'LinkedIn'),
                        ),
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Container(
                        child: TextFormField(
                          controller: _snapchatController,
                          decoration: profileTextInputDecoration.copyWith(
                              labelText: 'Snapchat'),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Container(
                          child: Row(
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
                                  dynamic outcome = await updateSocialMedia(
                                      user.uid, context);
                                },
                                child: Text(
                                  'SAVE',
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
              ),
            ],
          );
        }),
      ),
    );
  }
}
