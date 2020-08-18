import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:job_app/shared/constants.dart';

class CreateProfile extends StatefulWidget{

  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  String gender = '';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: <Widget>[


            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('My Profile', style: TextStyle(fontSize: 28.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'SourceSansPro'),),
                  SizedBox(height: 10.0),
                  CircleAvatar(
                    radius: 50.0,
                    backgroundColor: Colors.white,
                    child: Image(
                      image: AssetImage('images/profile_avatar.png'),),

                  ), SizedBox(height: 10.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Gender', style: TextStyle(fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,),),
                      Radio(
                        value: 'Male',
                        groupValue: gender,
                        activeColor: Colors.green,
                        onChanged: (val) => {},
                      ), Text('Male'),
                      Radio(
                        value: 'Female',
                        groupValue: gender,
                        activeColor: Colors.blue,
                        onChanged: (val) => {},
                      ), Text('Female'),

                    ],
                  ),
                  SizedBox(height: 10.0,),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 3,
                        child: Container(
                          padding: EdgeInsets.only(right: 5.0),
                          child: TextFormField(
                            decoration: profileTextInputDecoration.copyWith(
                                labelText: 'Name'),

                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: TextFormField(
                            decoration: profileTextInputDecoration.copyWith(
                                labelText: 'Age'),

                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 3.0),
                  Row(

                    children: <Widget>[
                      Expanded(
                          flex: 3,
                          child: Container(
                            padding: EdgeInsets.only(right: 5.0),
                            child: TextFormField(
                              decoration: profileTextInputDecoration.copyWith(
                                  labelText: 'State'),
                            ),
                          )
                      ),
                      Expanded(
                        flex: 2,
                        child: Container(
                          child: TextFormField(
                            decoration: profileTextInputDecoration.copyWith(
                                labelText: 'Country'),
                          ),
                        ),
                      ),
                    ],

                  ),
                  SizedBox(height: 5.0),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          child: TextFormField(
                            decoration: profileTextInputDecoration.copyWith(labelText: 'Phone Number'),
                          )
                        )
                      )
                    ],
                  ),
                  SizedBox(height:15.0),
                  Row(
                    children: <Widget>[
                      Container(
                        child: Material(
                            color: Colors.grey[200],
                            shadowColor: Colors.lightGreen,
                            elevation: 7.0,
                            borderRadius: BorderRadius.all(Radius.circular(5.0),),
                            child: MaterialButton(
                              minWidth: 80,
                              height: 52,
                              child: Icon(Icons.arrow_back_ios,size:29.0,)

                            )
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left:15.0),
                        width: 200.0,
                        child: Material(
                          color: Colors.green,
                          shadowColor: Colors.lightGreen,
                          elevation: 7.0,
                          borderRadius: BorderRadius.all(Radius.circular(5.0),),
                          child: MaterialButton(
                            minWidth: 200,
                            height: 52,
                            child: Text('SAVE', style: TextStyle(color: Colors.white),)
                          ),
                        )
                      )
                    ],
                  )


                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}