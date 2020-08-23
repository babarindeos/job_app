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
  dynamic isNewUser;
  dynamic isBioDataCreated;
  dynamic isCareerDetailsCreated;

  dynamic checkIfNewUserTypeExist(String userId) async {
    String result = await _user.isNewUser(userId);
    return result;
  }

  dynamic checkIfBioDataExist(String userId) async {
    String result = await _user.isBioDataCreated(userId);
    return result;
  }

  String checkIfCareerDetailsExist(String userId) {
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

      isNewUser = checkIfNewUserTypeExist(user.uid);
      //print(isNewUser);
      if (isNewUser == null) {
        return SelectUserType();
      } else {
        //check if user have been created
        isBioDataCreated = checkIfBioDataExist(user.uid);
        print(isBioDataCreated);
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
