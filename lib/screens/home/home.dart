import 'package:custom_navigator/custom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:job_app/models/profile.dart';
import 'package:job_app/screens/home/search_jobs/search_test.dart';
import 'package:job_app/screens/home/your_jobs_applied.dart';
import 'package:job_app/screens/user_profile/career_details.dart';
import 'package:job_app/screens/user_profile/create_profile.dart';
import 'package:job_app/services.dart/auth.dart';
import 'package:job_app/screens/home/search_jobs.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  final List<Widget> _children = [
    SearchJobs(),
    SearchTest(),
    SearchJobs(),
    SearchJobs()
  ];

  Widget _page = SearchJobs();
  int _currentIndex = 0;

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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
          type: BottomNavigationBarType.fixed,
          elevation: 7.0,
        ),
        body: CustomNavigator(
          navigatorKey: navigatorKey,
          home: _page,
          pageRoute: PageRoutes.materialPageRoute,
        ));
  }

  final _items = [
    BottomNavigationBarItem(
      icon: new Icon(Icons.home),
      title: Text('Home'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search),
      title: Text('Search'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.business_center),
      title: Text('Portfolios'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.insert_drive_file),
      title: Text('Projects'),
    )
  ];
}
