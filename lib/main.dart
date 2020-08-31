import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_app/screens/authenticate/authenticate.dart';
import 'package:job_app/screens/authenticate/register.dart';
import 'package:job_app/screens/authenticate/sign_in.dart';
import 'package:job_app/screens/home/home.dart';
import 'package:job_app/screens/loginModule.dart';
import 'package:job_app/screens/user_profile/career_details.dart';
import 'package:job_app/screens/user_profile/create_profile.dart';
import 'package:job_app/screens/user_profile/select_user_type.dart';
import 'package:job_app/screens/wrapper.dart';
import 'package:job_app/services.dart/auth.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';
import 'package:job_app/screens/user_profile/additional_info.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
          accentColor: Colors.teal,
        ),
        home: Wrapper(),
        routes: {
          '/authenticate': (BuildContext context) => Authenticate(),
          '/login': (BuildContext context) => LoginModule(),
          '/signIn': (BuildContext context) => SignIn(),
          '/register': (BuildContext context) => Register(),
          '/profile': (BuildContext context) => CreateProfile(),
          '/userType': (BuildContext context) => SelectUserType(),
          '/careerDetails': (BuildContext context) => CareerDetails(),
          '/additionalInfo': (BuildContext context) => AdditionalInfo(),
          '/home': (context) => Home(),
        },
      ),
    );
  }
}
