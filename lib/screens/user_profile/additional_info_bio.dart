import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:job_app/models/career.dart';
import 'package:job_app/models/user.dart';
import 'package:job_app/screens/user_profile/career_details.dart';
import 'package:provider/provider.dart';
import 'package:job_app/shared/constants.dart';

class AdditionalInfoBio extends StatefulWidget {
  String pageState;
  AdditionalInfoBio({this.pageState});
  @override
  _AdditionalInfoBioState createState() => _AdditionalInfoBioState();
}

class _AdditionalInfoBioState extends State<AdditionalInfoBio> {
  @override
  bool isloading = false;
  dynamic result;
  String processOutcome = '';

  Career _career = Career();

  final _formKey = GlobalKey<FormState>();

  //----------------------------------------------------------------------------
  void updateAddInfoBio(String userId, BuildContext context) async {
    print(userId.toString());
    _career.uBio = _bioController.text;
    result = await _career.updateAddInfoBio(userId);
    processOutcome = _career.updateStatus.toString();
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

  TextEditingController _bioController = TextEditingController();

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

  Future<void> retrieveUserBio() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    dynamic _currentUser = await _auth.currentUser().then((value) => value.uid);

    DocumentReference documentRef = Firestore.instance
        .collection("Addition_Info_Bio")
        .document(_currentUser);
    await documentRef.get().then((dataSnapshot) {
      if (dataSnapshot.exists) {
        _bioController.text = (dataSnapshot).data['bio'];
        print(dataSnapshot.data['bio']);
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
    retrieveUserBio();
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
                            'Bio-Data',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SourceSansPro'),
                          ),
                          SizedBox(height: 10.0),
                          SizedBox(height: 20.0),
                          TextFormField(
                            controller: _bioController,
                            validator: (value) =>
                                value.isEmpty ? 'Bio-Data is required' : null,
                            maxLines: 10,
                            keyboardType: TextInputType.multiline,
                            decoration: profileTextInputDecoration.copyWith(
                                labelText: 'Bio-Data'),
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

                                        updateAddInfoBio(user.uid, context);
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
