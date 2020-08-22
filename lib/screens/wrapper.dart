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

  final Verifier _user = Verifier();
  @override
  Widget build(BuildContext context) {
    // return either authenticate or home
    final user = Provider.of<User>(context);

    // return either Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      // check if user type has been selected
      isNewUser = _user.isNewUser(user.uid);

      if (isNewUser == '') {
        return SelectUserType();
      } else {
        //check if user have been created
        isBioDataCreated = _user.isBioDataCreated(user.uid);
        if (isBioDataCreated == null) {
          return CreateProfile();
        } else
          // check if Career Details have been created
          isCareerDetailsCreated = _user.isCareerDetailsCreated(user.uid);
        if (isCareerDetailsCreated == null) {
          //CareerDetails();
          return Home();
        } else {
          return Home();
        }
      }
    }
  }
}
