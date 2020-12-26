import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:job_app/models/verifier.dart';
import 'package:job_app/screens/authenticate/authenticate.dart';
import 'package:job_app/screens/home/home.dart';
import 'package:job_app/screens/splash.dart';
import 'package:job_app/screens/user_profile/career_details.dart';
import 'package:job_app/screens/user_profile/create_profile.dart';
import 'package:job_app/screens/user_profile/select_user_type.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  dynamic isUserTypeSelected;
  dynamic isBioDataCreated;
  dynamic isCareerDetailsCreated;
  dynamic outcomeResult;
  bool isLoading = true;
  String loadingStatus = 'Loading...Please Wait';

  final Verifier _user = Verifier();

  //---------------------------------------------------------------------------------------

  checkIfNewUserTypeExist(String userId, BuildContext context) async {
    print("Checking for User Type Selection...");

    String result = await _user.isUserTypeSelected(userId);
    if (_user.iUserType == null) {
      Navigator.pushNamed(context, '/userType');
    } else {
      //Navigator.pushNamed(context, '/userType');
      checkIfBioDataExist(userId, context);
    }
  }

//----------------------------------------------------------------------------------------
  checkIfBioDataExist(String userId, BuildContext context) async {
    print("*********************Checking for User BioData " + _user.iUserType);
    String result = await _user.isBioDataCreated(userId);

    if (_user.iBioData == null) {
      print('********************************* BioData has not been filled');
      Navigator.pushNamed(context, '/profile');
    } else {
      if (_user.iUserType == 'job_seeker') {
        checkIfCareerDetailsExist(userId, context);
      } else {
        checkIfCompanyExist(userId, context);
      }
    }
  }

  //------------------------------------------------------------------------------------

  checkIfCareerDetailsExist(String userId, BuildContext context) async {
    print("Checking for Career Details");
    String result = await _user.isCareerDetailsCreated(userId);
    if (_user.iCareerDetails == null) {
      Navigator.pushNamed(context, '/careerDetails');
    } else {
      //Navigator.pushNamed(context, '/home');
      Navigator.pushNamedAndRemoveUntil(
          context, '/home', ModalRoute.withName('/login'));
    }
  }

  //------------------------------------------------------------------------------------
  checkIfCompanyExist(String userid, BuildContext context) async {
    print("Checking for Company Info");
    String result = await _user.isCompanyCreated(userid);
    if (_user.iCompany == null) {
      Navigator.pushNamed(context, '/aboutOrganisation');
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, '/recruiterHome', ModalRoute.withName('/login'));
    }
  }

  //------------------------------------------------------------------------------------

  Widget showLoadingHandler() {
    Widget loader;
    loader = Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SpinKitDoubleBounce(
            color: Colors.blue,
            size: 150.0,
          ),
          SizedBox(height: 10.0),
          Text(
            loadingStatus,
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
    return loader;
  }

  @override
  Widget build(BuildContext context) {
    // return either authenticate or home
    final user = Provider.of<User>(context);
    //print(user.uid);

    if (user == null) {
      //return Authenticate();
      return Splash();
    } else {
      // check if user type has been selected
      //return SelectUserType();
      isUserTypeSelected = checkIfNewUserTypeExist(user.uid, context);
      print("Result has been obtained");
      print("Opening home page now...");
      return SafeArea(
        child: Scaffold(
          body: Center(
            child: isLoading ? showLoadingHandler() : Text(''),
          ),
        ),
      );
    }
  }
}
