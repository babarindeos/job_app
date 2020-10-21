import 'package:flutter/material.dart';
import 'package:job_app/services.dart/auth.dart';
import 'package:job_app/shared/constants.dart';
import 'package:job_app/shared/loading2.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String confirm_password = '';
  String error = '';
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Loading2()
        : SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/office_building.png'),
                      fit: BoxFit.cover),
                ),
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30.0),
                child: ListView(
                  children: <Widget>[
                    Container(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text(
                              'Hello,',
                              style: TextStyle(
                                fontSize: 23.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SourceSansPro',
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 25.0),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'Sign Up!',
                              style: TextStyle(
                                fontSize: 40.0,
                                fontWeight: FontWeight.w100,
                                fontFamily: 'Pacifico',
                                color: Colors.amberAccent,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 6.0),
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 20.0,
                        child: Image(
                          image: AssetImage('images/logo.png'),
                        ),
                      ),
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 5.0),
                          Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(top: 3.0),
                            child: Text(
                              error,
                              style: TextStyle(
                                color: Colors.red[100],
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 1.0),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: 'Email'),
                            validator: (value) =>
                                value.isEmpty ? 'Enter an email' : null,
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              }); // end of state
                            },
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: 'Password'),
                            obscureText: true,
                            validator: (value) => value.length < 6
                                ? 'Enter password 6+ characters long.'
                                : null,
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              }); //end of state
                            },
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              labelText: 'Confirm Password',
                            ),
                            obscureText: true,
                            validator: (value) => value.length < 6
                                ? 'Enter password 6+ characters long.'
                                : null,
                            onChanged: (value) {
                              setState(() {
                                confirm_password = value;
                              }); //end of state
                            },
                          ),
                          SizedBox(height: 20.0),
                          Material(
                            color: Colors.green,
                            shadowColor: Colors.lightGreen,
                            elevation: 7.0,
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                            child: MaterialButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    isLoading = true;
                                  });
                                  dynamic result =
                                      await _auth.registerWithEmailAndPassword(
                                          email, password);
                                  if (result == null) {
                                    setState(() {
                                      error = _auth.aErrMsg;
                                      isLoading = false;
                                    });
                                  }
                                }
                              },
                              minWidth: 200,
                              height: 42,
                              child: Text(
                                "LET'S GO",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.0,
                          ),
                          Row(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerRight,
                                child: Text(
                                  "Already have an account?",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              Container(
                                child: FlatButton(
                                  onPressed: () {
                                    //widget.toggleView();
                                    Navigator.popAndPushNamed(
                                        context, '/signIn');
                                  },
                                  child: Text(
                                    "Login Here",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
