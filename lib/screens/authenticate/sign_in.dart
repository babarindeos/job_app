import 'package:flutter/material.dart';
import 'package:job_app/services.dart/auth.dart';
import 'package:job_app/shared/constants.dart';
import 'package:job_app/shared/loading.dart';
import 'package:job_app/shared/loading2.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading2()
        : SafeArea(
            child: Scaffold(
              backgroundColor: Colors.white,
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('images/professional_staff_bg.png'),
                      fit: BoxFit.cover),
                ),
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25.0),
                child: ListView(
                  children: <Widget>[
                    Container(
                      child: Stack(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                            child: Text(
                              'Welcome,',
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
                              'Sign In!',
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
                      margin: EdgeInsets.only(top: 10.0),
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 30.0,
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
                                color: Colors.red[200],
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 5.0),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: 'Email'),
                            validator: (value) =>
                                value.isEmpty ? 'Please enter an email' : null,
                            onChanged: (value) {
                              setState(() {
                                email = value;
                              }); // end of state
                            },
                          ),
                          SizedBox(height: 8.0),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                              labelText: 'Password',
                            ),
                            validator: (value) => value.length < 6
                                ? 'Please enter 6+ characters long'
                                : null,
                            obscureText: true,
                            onChanged: (value) {
                              setState(() {
                                password = value;
                              }); //end of state
                            },
                          ),
                          Container(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                                child: Text(
                              'Forgot Password?',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            )),
                          ),
                          SizedBox(height: 20.0),
                          Material(
                            color: Colors.green,
                            shadowColor: Colors.lightGreenAccent,
                            elevation: 7.0,
                            borderRadius: BorderRadius.all(
                              Radius.circular(30.0),
                            ),
                            child: MaterialButton(
                              onPressed: () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  dynamic result =
                                      await _auth.signInWithEmailAndPassword(
                                          email, password);
                                  print(result);
                                  if (result == null) {
                                    setState(() {
                                      error =
                                          'Could not signin with those credentials.';
                                      loading = false;
                                    });
                                  }
                                }
                              },
                              minWidth: 200,
                              height: 42,
                              child: Text(
                                'SIGN IN',
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "You don't have an account?",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              FlatButton(
                                onPressed: () => {widget.toggleView()},
                                child: Text(
                                  "Register",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
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
