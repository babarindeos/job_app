import 'package:flutter/material.dart';
import 'package:job_app/models/user.dart';
import 'package:provider/provider.dart';

class SelectUserType extends StatefulWidget {
  @override
  _SelectUserTypeState createState() => _SelectUserTypeState();
}

class _SelectUserTypeState extends State<SelectUserType> {
  String user_type = '';
  final User _user = User();
  String error = '';

  @override
  Widget build(BuildContext context) {
    final current_user = Provider.of<User>(context);
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
                    setState(() {
                      user_type = "job_seeker";
                    });
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
                    setState(() {
                      user_type = "recruiter";
                    });
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
                    onPressed: () {
                      print(current_user.uid);
                      if (user_type == '') {
                        setState(() {
                          error = "Select a User Type";
                        });
                      } else {
                        dynamic result =
                            _user.createUserType(current_user.uid, user_type);
                        print(result);
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
