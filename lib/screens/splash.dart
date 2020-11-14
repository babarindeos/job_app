import 'package:flutter/material.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Theme.of(context).accentColor.withOpacity(0.9),
              Theme.of(context).primaryColor,
            ]),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            child: Image.asset(
              "images/logo.png",
              width: 120.0,
              fit: BoxFit.cover,
            ),
            radius: 50.0,
            backgroundColor: Colors.white,
          ),
          Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 60.0),
            child: Text(
              'Forty Seconds CV',
              style: TextStyle(
                fontFamily: 'Signatra',
                fontSize: 50.0,
                color: Colors.white,
              ),
            ),
          ),
          Material(
            color: Colors.green,
            shadowColor: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(30.0)),
            child: MaterialButton(
              onPressed: () {
                Navigator.pushNamed(context, '/signIn');
              },
              child: Text(
                "LET'S GO THERE",
                style: TextStyle(color: Colors.white),
              ),
              minWidth: 280,
              height: 42.0,
            ),
          ),
        ],
      ),
    ));
  }
}
