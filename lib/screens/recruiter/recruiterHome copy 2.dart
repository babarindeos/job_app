import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:job_app/custom/adaptive_bottom_navigation_scaffold.dart';
import 'package:job_app/custom/app_flow.dart';
import 'package:job_app/custom/bottom_navigation_tab.dart';
import 'package:job_app/models/profile.dart';
import 'package:job_app/screens/home/your_jobs_applied.dart';
import 'package:job_app/screens/recruiter/jobs/jobs_tracker.dart';
import 'package:job_app/screens/recruiter/menu_options.dart';
import 'package:job_app/screens/user_profile/career_details.dart';
import 'package:job_app/screens/user_profile/create_profile.dart';
import 'package:job_app/services.dart/auth.dart';
import 'package:job_app/screens/home/search_jobs.dart';

class RecruiterHome extends StatefulWidget {
  @override
  _RecruiterHomeState createState() => _RecruiterHomeState();
}

class _RecruiterHomeState extends State<RecruiterHome> {
  final AuthService _auth = AuthService();
  final List<Widget> _children = [
    Page1(),
    Page2(),
  ];

  Widget _page = Page1();
  int _currentIndex = 1;

  Globalkey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: _items,
        onTap: (index) {
          navigatorKey.currentState.maybePop();
          setState(() => _page = _children[index]);
          _currentIndex = index;
        },
        currentIndex: _currentIndex,
      ),
      body: CustomNavigator(
        navigatorKey: navigatorKey,
        home: _page,
        pageRoute: PageRoutes.materialPageRoute,
      ),
    );
  }

  final _items = [
    BottomNavigationBarItem(
      icon: new Icon(Icons.looks_one),
      title: new Text('Page 1'),
    ),
    BottomNavigationBarItem(
      icon: new Icon(Icons.looks_two),
      title: new Text('Page 2'),
    )
  ];
}

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Page 1'),
    );
  }
}

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('Page 2'),
    );
  }
}
