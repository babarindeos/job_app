import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_app/models/user.dart';
import 'package:job_app/services.dart/auth.dart';
import 'package:provider/provider.dart';

class SelectUserType extends StatefulWidget {
  @override
  _SelectUserTypeState createState() => _SelectUserTypeState();
}

class _SelectUserTypeState extends State<SelectUserType> {
  dynamic user_type = '';
  String loggedInUserId;
  String error = '';
  var result = '';

  final User _user = User();
  AuthService _auth = AuthService();

  Future<void> getloggedInUserId() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    dynamic user = await auth.currentUser().then((value) => value.uid);

    loggedInUserId = user.toString();
    print("In getLogged " + loggedInUserId);
    //getUserType(loggedInUserId);
  }

  @override
  void initState() {
    super.initState();

    print("Initial State");
    getloggedInUserId();
    getUserType();
  }

  Future<void> getUserType() async {
    dynamic result;
    FirebaseAuth auth = FirebaseAuth.instance;
    dynamic uid = await auth.currentUser().then((value) => value.uid);

    print("In getUserType " + uid);
    try {
      DocumentReference documentRef =
          Firestore.instance.collection('UserType').document(uid);

      await documentRef.get().then((dataSnapshot) {
        if (dataSnapshot.exists) {
          result = (dataSnapshot.data['type']);
          setState(() {
            user_type = result;
          });
        } else {
          user_type = null;
        }
      });
    } catch (e) {
      user_type = null;
    }
  }

  handleUserTypeSelection(String currentUser, String type) async {
    //print(currentUser);
    setState(() {
      user_type = type;
    });
    result = await _user.createUserType(currentUser, user_type);
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<User>(context);

    return SafeArea(
      child: Scaffold(
        body: Container(
            margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 15.0),
            alignment: Alignment.center,
            child: Column(
              children: <Widget>[
                Text(
                  'SELECT USER TYPE',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SourceSansPro',
                  ),
                ),
                InkWell(
                  child: Container(
                    width: 150,
                    margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
                    decoration: BoxDecoration(
                      color: user_type == 'job_seeker'
                          ? Colors.green
                          : Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        )
                      ],
                    ),
                    padding: EdgeInsets.all(10.0),
                    child:
                        Image.asset('images/job_seeker.jpg', fit: BoxFit.cover),
                  ),
                  onTap: () {
                    handleUserTypeSelection(_user.uid, 'job_seeker');
                  },
                ),
                InkWell(
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                      color: user_type == 'recruiter'
                          ? Colors.green
                          : Colors.white,
                      border: Border.all(
                        color: Colors.grey,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 5,
                          blurRadius: 7,
                          offset: Offset(0, 3), // changes position of shadow
                        )
                      ],
                    ),
                    padding: EdgeInsets.all(10.0),
                    child:
                        Image.asset('images/recruiter.jpg', fit: BoxFit.cover),
                  ),
                  onTap: () {
                    print(_user.uid);
                    handleUserTypeSelection(_user.uid, 'recruiter');
                  },
                ),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  error,
                  style: TextStyle(
                      color: Colors.red.shade400, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10.0),
                Material(
                  color: Colors.green,
                  shadowColor: Colors.lightGreen,
                  elevation: 7.0,
                  child: MaterialButton(
                    child: Text(
                      'PROCEED',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    onPressed: () async {
                      if (user_type == '') {
                        setState(() {
                          error = "Select a User Type";
                        });
                      } else {
                        Navigator.pushNamed(context, '/profile');
                      }
                    },
                    minWidth: 300,
                    height: 50,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
