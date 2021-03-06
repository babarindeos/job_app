import 'package:flutter/material.dart';
import 'package:job_app/screens/user_profile/create_profile.dart';
import 'package:job_app/screens/wrapper.dart';
import 'package:job_app/services.dart/auth.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';

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
        home: Wrapper(),
        routes: {
          '/profile' : (context) => CreateProfile(),
        },
      ),
    );
  }
}
