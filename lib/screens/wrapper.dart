import 'package:flutter/material.dart';
import 'package:job_app/models/verifier.dart';
import 'package:job_app/screens/authenticate/authenticate.dart';
import 'package:job_app/screens/home/home.dart';
import 'package:job_app/screens/splash.dart';
import 'package:job_app/screens/user_profile/career_details.dart';
import 'package:job_app/screens/user_profile/create_profile.dart';
import 'package:job_app/screens/user_profile/select_user_type.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';

class Wrapper extends StatelessWidget {
  dynamic isUserTypeSelected;
  dynamic isUserTypeObject;
  dynamic isUserTypeSelected_mobile;
  dynamic isBioDataCreated;
  dynamic isCareerDetailsCreated;
  dynamic outcomeResult;
  dynamic result;

  dynamic checkIfNewUserTypeExist(String userId) async {
    print("Checking for User Type Selection...");
    result = await _user.isUserTypeSelected(userId);
    return result;
  }

  dynamic checkIfBioDataExist(String userId) async {
    print("Checking for User BioData");
    result = await _user.isBioDataCreated(userId);
    return result;
  }

  dynamic checkIfCareerDetailsExist(String userId) async {
    print("Checking for Career Details");
    result = await _user.isCareerDetailsCreated(userId);
    return result;
  }

  final Verifier _user = Verifier();
  @override
  Widget build(BuildContext context) {
    // return either authenticate or home
    final user = Provider.of<User>(context);
    //print(user.uid);

    if (user == null) {
      return Splash();
    } else {
      // check if user type has been selected

      isUserTypeSelected = checkIfNewUserTypeExist(user.uid);
      //print("Returned result from isUserTypeSelected : " + isUserTypeSelected);
      if (isUserTypeSelected == null) {
        print("User Type is not Selected.");
        // print(" UserType Object: " + _user.iUserType);
        return SelectUserType();
      } else {
        //check if user have been created
        isBioDataCreated = checkIfBioDataExist(user.uid);

        if (isBioDataCreated == null) {
          print("User BioData is not filled in");
          return CreateProfile();
        } else {
          // check if Career Details has been created
          isCareerDetailsCreated = checkIfCareerDetailsExist(user.uid);
          print(isCareerDetailsCreated);
          if (isCareerDetailsCreated == null) {
            return CareerDetails();
          } else {
            return Home();
          }
        }
      }
    }
  }
}
