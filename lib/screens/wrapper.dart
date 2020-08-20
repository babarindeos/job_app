import 'package:flutter/material.dart';
import 'package:job_app/models/verifier.dart';
import 'package:job_app/screens/authenticate/authenticate.dart';
import 'package:job_app/screens/home/home.dart';
import 'package:job_app/screens/user_profile/create_profile.dart';
import 'package:job_app/screens/user_profile/select_user_type.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';

class Wrapper extends StatelessWidget {
  dynamic isNewUser;
  final Verifier _user = Verifier();
  @override
  Widget build(BuildContext context) {
    // return either authenticate or home
    final user = Provider.of<User>(context);
    print(user);

    // return either Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      isNewUser = _user.isNewUser(user.uid);
      print('isNewUser is :');
      print(isNewUser);
      if (isNewUser == '') {
        return SelectUserType();
      } else {
        return Home();
      }
    }
  }
}
