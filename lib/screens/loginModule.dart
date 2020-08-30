import 'dart:wasm';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:job_app/models/user.dart';
import 'package:job_app/models/verifier.dart';
import 'package:job_app/screens/home/home.dart';
import 'package:job_app/screens/user_profile/select_user_type.dart';
import 'package:provider/provider.dart';

class LoginModule extends StatefulWidget {
  @override
  _LoginModuleState createState() => _LoginModuleState();
}

class _LoginModuleState extends State<LoginModule> {
  dynamic isUserTypeSelected = false;
  dynamic isBioDataFilled = false;
  String routeLocation = '';
  dynamic resultUserType;
  dynamic resultBioData;
  DocumentReference documentReference;

  final Verifier _user = Verifier();

  loadInitialPage(BuildContext context, String userId) {
    Navigator.pushNamed(context, '/userType');
    if (checkIfNewUserTypeExist(userId) == null) {
      print("Push to another page");
    }
  }

  dynamic checkIfNewUserTypeExist(String userId) async {
    print("Checking for User Type Selection...");
    resultUserType = await _user.isUserTypeSelected(userId);
    return resultUserType;
  }

  dynamic checkIfBioDataExist(String userId) async {
    print("Checking for User BioData");
    resultBioData = await _user.isBioDataCreated(userId);
    print("BioData Result : " + resultBioData);
    return resultBioData;
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    loadInitialPage(context, user.uid);

    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Center(
              child: SpinKitDoubleBounce(
                color: Colors.blueAccent,
                size: 150.0,
              ),
            ),
            SizedBox(height: 10.0),
            Text(
              "Sign In... Please Wait.",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontFamily: 'Pacifico-Regular'),
            )
          ],
        ),
      ),
    );
  }
}
