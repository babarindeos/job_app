import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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

  final List<Widget> _pages = [
    MenuOptions(),
    CareerDetails(),
    JobTracker(),
    SearchJobs(),
    YourJobsApplied(),
    CreateProfile()
  ];
  int _selectedPageIndex = 0;

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: _pages[_selectedPageIndex],
        bottomNavigationBar: BottomNavigationBar(
            onTap: _selectPage,
            type: BottomNavigationBarType.fixed,
            elevation: 7.0,
            backgroundColor: Colors.blue,
            unselectedItemColor: Colors.white,
            selectedItemColor: Colors.amber,
            currentIndex: _selectedPageIndex,
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home, size: 30.0, color: Colors.white),
                title: Text(
                  'Home',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.search,
                  size: 30.0,
                  color: Colors.white,
                ),
                title: Text(
                  'Search',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.business_center,
                  size: 30,
                  color: Colors.white,
                ),
                title: Text(
                  'Jobs',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.insert_drive_file,
                    size: 30.0, color: Colors.white),
                title: Text(
                  'CV',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.settings,
                    size: 30.0,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Settings',
                    style: TextStyle(color: Colors.white),
                  ))
            ]),
      ),
    );
  }
}
