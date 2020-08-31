import 'package:flutter/material.dart';
import 'package:job_app/models/verifier.dart';
import 'package:job_app/screens/authenticate/authenticate.dart';
import 'package:job_app/screens/home/home.dart';
import 'package:job_app/screens/user_profile/career_details.dart';
import 'package:job_app/screens/user_profile/create_profile.dart';
import 'package:job_app/screens/user_profile/select_user_type.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';

class Wrapper extends StatelessWidget {
  dynamic isUserTypeSelected;
  dynamic isBioDataCreated;
  dynamic isCareerDetailsCreated;
  dynamic outcomeResult;

  dynamic checkIfNewUserTypeExist(String userId) {
    print("Checking for User Type Selection...");
    String result = _user.isUserTypeSelected(userId);
    return result;
  }

  String checkIfBioDataExist(String userId) {
    print("Checking for User BioData");
    String result = _user.isBioDataCreated(userId);
    return result;
  }

  String checkIfCareerDetailsExist(String userId) {
    print("Checking for Career Details");
    String result = _user.isCareerDetailsCreated(userId);
    return result;
  }

  final Verifier _user = Verifier();
  @override
  Widget build(BuildContext context) {
    // return either authenticate or home
    final user = Provider.of<User>(context);
    //print(user.uid);

    if (user == null) {
      return Authenticate();
    } else {
      // check if user type has been selected
      //return Home();
      isUserTypeSelected = checkIfNewUserTypeExist(user.uid);
      //print("Returned result from isUserTypeSelected : " + isUserTypeSelected);
      if (isUserTypeSelected == null) {
        print("User Type is not Selected.");
        return SelectUserType();
      } else {
        //check if user have been created
        isBioDataCreated = checkIfBioDataExist(user.uid);

        if (isBioDataCreated == null) {
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
