import 'package:custom_navigator/custom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_app/models/profile.dart';
import 'package:job_app/screens/home/notification/notifications.dart';
import 'package:job_app/screens/home/search_jobs.dart';
import 'package:job_app/screens/home/search_jobs/search_test.dart';
import 'package:job_app/screens/home/your_jobs_applied.dart';
import 'package:job_app/screens/recruiter/message/message_listing.dart';
import 'package:job_app/screens/user_profile/career_details.dart';
import 'package:job_app/screens/user_profile/create_profile.dart';
import 'package:job_app/services.dart/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String myAvatar = '';
  String myName = '';
  String myId = '';
  String msg = '';
  //----------------------------------------------------------------------------

  //----------------------------------------------------------------------------
  Future<void> getUserId() async {
    final FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    setState(() {
      myId = _user.uid;
    });
  }

//------------------------------------------------------------------------------
  Future<void> getUserBioDataInfo() async {
    DocumentReference docRef =
        Firestore.instance.collection("BioData").document(myId);
    await docRef.get().then((dataSnapshot) {
      setState(() {
        myAvatar = dataSnapshot['avatar'];
        myName = dataSnapshot['name'];
      });
    });
  }

//-------------------------------------------------------------------------------
  @override
  void initState() {
    getUserId().then((_) => getUserBioDataInfo());
    super.initState();
  }

//----------------------------------------------------------------------------
  _openDrawer() {
    _scaffoldKey.currentState.openDrawer();
  }

//----------------------------------------------------------------------------

  final AuthService _auth = AuthService();
  final List<Widget> _children = [
    SearchJobs(),
    MessageListing(),
    YourJobsApplied(),
    Notifications(),
    SearchJobs(),
  ];

  Widget _page = SearchJobs();
  int _currentIndex = 0;

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        print("am here");
      },
      child: Scaffold(
          key: _scaffoldKey,
          drawer: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DrawerHeader(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Theme.of(context).accentColor.withOpacity(0.8),
                          Theme.of(context).primaryColor,
                        ]),
                  ),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 45.0,
                          backgroundColor: Colors.blue,
                          child: CircleAvatar(
                            radius: 44.0,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: SizedBox(
                                width: 100,
                                height: 180,
                                child: myAvatar == null
                                    ? Image(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            'images/profile_avatar.jpg'),
                                      )
                                    : Image.network(
                                        myAvatar,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 7.0),
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: myName.isNotEmpty
                              ? Text(myName,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 17.0,
                                  ))
                              : Text(''),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 2.0, 5.0, 8.0),
                  child: Text(
                    'Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SourceSansPro',
                      fontSize: 20.0,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 5.0,
                    top: 5.0,
                    left: 15.0,
                    right: 5.0,
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.person,
                        color: Colors.black45,
                        size: 30.0,
                      ),
                      SizedBox(width: 27.0),
                      Text(
                        'BioData Info',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15.0),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 8.0,
                    top: 5.0,
                    left: 15.0,
                    right: 5.0,
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.work,
                        color: Colors.black45,
                        size: 30.0,
                      ),
                      SizedBox(width: 27.0),
                      Text(
                        'Career Details',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 8.0,
                    top: 5.0,
                    left: 15.0,
                    right: 5.0,
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.info,
                        color: Colors.black45,
                        size: 30.0,
                      ),
                      SizedBox(width: 27.0),
                      Text(
                        'Additional Info',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15.0),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 5.0, 8.0),
                  child: Text(
                    'Friends',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SourceSansPro',
                      fontSize: 20.0,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 5.0,
                    top: 5.0,
                    left: 15.0,
                    right: 5.0,
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.person_add,
                        color: Colors.black45,
                        size: 30.0,
                      ),
                      SizedBox(width: 27.0),
                      Text(
                        'Add friends',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15.0),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 8.0,
                    top: 5.0,
                    left: 15.0,
                    right: 5.0,
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.people,
                        color: Colors.black45,
                        size: 30.0,
                      ),
                      SizedBox(width: 27.0),
                      Text(
                        'My friends',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15.0),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                    bottom: 8.0,
                    top: 15.0,
                    left: 15.0,
                    right: 5.0,
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.exit_to_app,
                        color: Colors.black45,
                        size: 30.0,
                      ),
                      SizedBox(width: 27.0),
                      InkWell(
                        onTap: () {
                          //_signOut(context);
                        },
                        child: Text(
                          'Logout',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: _items,
            onTap: (index) {
              // Check if settings is the bottomnavigationItem clicked
              if (index == 4) {
                _openDrawer();
              } else {
                navigatorKey.currentState.maybePop();
                setState(() => _page = _children[index]);
              } // end of check

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
          )),
    );
  }

  final _items = [
    BottomNavigationBarItem(
      icon: new Icon(Icons.home),
      title: Text('Home'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.chat),
      title: Text('Messages'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.business),
      title: Text('Jobs'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.notifications),
      title: Text('Alerts'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      title: Text('Settings'),
    )
  ];
}
