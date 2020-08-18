import 'package:flutter/material.dart';
import 'package:job_app/screens/authenticate/authenticate.dart';
import 'package:job_app/screens/home/home.dart';
import 'package:job_app/screens/user_profile/create_profile.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';


class Wrapper extends StatelessWidget {
  String isNewUser = '';
  final User _user = User();
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    print("Result of Stream is" + user.uid);

    // return either Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      isNewUser = _user.isNewUser(user.uid);
      if (isNewUser==null){
        return CreateProfile();
      }else{
        return Home();
      }


    }
  }
}
