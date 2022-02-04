import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_navigator/custom_navigator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:job_app/custom/adaptive_bottom_navigation_scaffold.dart';
import 'package:job_app/custom/app_flow.dart';
import 'package:job_app/custom/bottom_navigation_tab.dart';
import 'package:job_app/models/profile.dart';
import 'package:job_app/models/user.dart';
import 'package:job_app/screens/authenticate/sign_in.dart';
import 'package:job_app/screens/friend/add_friend.dart';
import 'package:job_app/screens/friend/friends.dart';
import 'package:job_app/screens/home/your_jobs_applied.dart';
import 'package:job_app/screens/recruiter/about_organisation.dart';
import 'package:job_app/screens/recruiter/additional_company_info.dart';
import 'package:job_app/screens/recruiter/jobs/jobs_tracker.dart';
import 'package:job_app/screens/recruiter/menu_options.dart';
import 'package:job_app/screens/recruiter/message/message_listing.dart';
import 'package:job_app/screens/recruiter/settings/settings.dart';
import 'package:job_app/screens/user_profile/career_details.dart';
import 'package:job_app/screens/user_profile/create_profile.dart';
import 'package:job_app/services.dart/auth.dart';
import 'package:job_app/screens/home/search_jobs.dart';
import 'package:provider/provider.dart';

class RecruiterHome extends StatefulWidget {
  @override
  _RecruiterHomeState createState() => _RecruiterHomeState();
}

class _RecruiterHomeState extends State<RecruiterHome> {
  String myAvatar = '';
  String myName = '';
  String myId = '';
  String msg = '';

//------------------------------------------------------------------------------
  Future<void> getUserId() async {
    final FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    setState(() {
      myId = _user.uid;
    });
    getUserBioDataInfo();
  }

//------------------------------------------------------------------------------
  Future<void> getUserBioDataInfo() async {
    print("======== My ID : " + myId.toString());
    DocumentReference docRef =
        Firestore.instance.collection("BioData").document(myId);
    await docRef.get().then((dataSnapshot) {
      setState(() {
        myAvatar = dataSnapshot['avatar'];
        myName = dataSnapshot['name'];
        print(myAvatar.toString());
      });
    });
  }

//-------------------------------------------------------------------------------
  @override
  void initState() {
    // TODO: implement initState
    getUserId();
    super.initState();
  }

  //----------------------------------------------------------------------------

  final AuthService _auth = AuthService();
  final List<Widget> _children = [
    MenuOptions(),
    MessageListing(),
    Page2(),
    Page2()
  ];

  //----------------------------------------------------------------------------
  _openDrawer() {
    _scaffoldKey.currentState.openDrawer();
  }

  //----------------------------------------------------------------------------

  Widget _page = MenuOptions();
  int _currentIndex = 0;

  //----------------------------------------------------------------------------

  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();

  //----------------------------------------------------------------------------
  // Sign out
  Future<void> _signOut(BuildContext context) async {
    try {
      await _auth.signOut().then((_) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => SignIn()),
          ModalRoute.withName('/'),
        );
      });
    } catch (e) {
      msg = e.message.toString();
      print(msg);
      showInSnackBar(msg, context);
    }
  }

  //----------------------------------------------------------------------------
  // SnackBar
  // Snackbar function
  void showInSnackBar(String value, BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
    );
  }

  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                              child: myAvatar == '' || myAvatar == null
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
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreateProfile(
                              pageState: 'update',
                            ),
                          ),
                        );
                      },
                      child: Text(
                        'BioData Info',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15.0),
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
                      Icons.work,
                      color: Colors.black45,
                      size: 30.0,
                    ),
                    SizedBox(width: 27.0),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AboutOrganisation(pageState: 'update'),
                          ),
                        );
                      },
                      child: Text(
                        'Company Info',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 15.0,
                        ),
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
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AdditionalCompanyInfo(
                                    pageState: 'update')));
                      },
                      child: Text(
                        'Additional Info',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15.0),
                      ),
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
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                AddFriend(currentUserId: myId),
                          ),
                        );
                      },
                      child: Text(
                        'Add friends',
                        style: TextStyle(
                            fontWeight: FontWeight.w500, fontSize: 15.0),
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
                      Icons.people,
                      color: Colors.black45,
                      size: 30.0,
                    ),
                    SizedBox(width: 27.0),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Friends(currentUserId: myId),
                          ),
                        );
                      },
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Friends(
                                currentUserId: myId,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'My friends',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 15.0),
                        ),
                      ),
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
                      onTap: () async {
                        final _user = Provider.of<User>(context, listen: false);
                        _user.logout();

                        await _auth.signOut().then((value) {
                          if (value == null) {
                            Navigator.of(context).pop();
                            Navigator.of(context).pushReplacementNamed('/');
                          }
                        });
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
            if (index == 3) {
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
        ),
      ),
    );
  }

  final _items = [
    BottomNavigationBarItem(
      icon: new Icon(Icons.home),
      title: Text('Home'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.move_to_inbox),
      title: Text('Message'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.notifications),
      title: Text('Alerts'),
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.settings),
      title: Text('Settings'),
    ),
  ];
}

class Page1 extends StatefulWidget {
  @override
  _Page1State createState() => _Page1State();
}

class _Page1State extends State<Page1> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        child: RaisedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Page2()),
            );
          },
          child: Text('Page 2'),
        ),
      ),
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
    return Center(
      child: Container(
        child: RaisedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Page1()),
            );
          },
          child: Text('Page 1'),
        ),
      ),
    );
  }
}

Widget settingsPopMenu() {
  return PopupMenuButton(
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 1,
        child: Text('Profile'),
      )
    ],
  );
}
