import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_app/models/profile.dart';
import 'package:job_app/models/user.dart';
import 'package:job_app/shared/constants.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:path/path.dart';

class CreateProfile extends StatefulWidget {
  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  File _image;
  String gender_option = '';
  bool loading = false;
  bool _btnForwardEnable = false;
  final _formKey = GlobalKey<FormState>();
  // call Profile Class
  final Profile _profile = Profile();

  void _handleGenderSelected(String value) {
    setState(() {
      gender_option = value;
      _profile.uGender = gender_option;
    });
  }

  // getting the Image
  Future getImage() async {
    dynamic image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      print('Image Path $_image');
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // uploading the image to firestore
    Future uploadAvatar(BuildContext context) async {
      if (_image != null) {
        final user = Provider.of<User>(context);

        String fileName = basename(_image.path);
        StorageReference firebaseStorageRef =
            FirebaseStorage.instance.ref().child(user.uid);
        StorageUploadTask uploadTask = firebaseStorageRef.putFile(_image);
        StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
        setState(() {
          print("Profile pciture uploaded");
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text('Profile Picture Uploaded.')));
        });
      }
    }

    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      child: Image(
                        image: AssetImage('images/step-1-mini.png'),
                        width: 150.0,
                      ),
                    ),
                    Text(
                      'My Profile',
                      style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SourceSansPro'),
                    ),
                    SizedBox(height: 10.0),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          CircleAvatar(
                              radius: 50.0,
                              backgroundColor: Colors.white,
                              child: ClipOval(
                                child: SizedBox(
                                  width: 100,
                                  height: 180,
                                  child: (_image != null)
                                      ? Image.file(_image, fit: BoxFit.fill)
                                      : Image(
                                          image: AssetImage(
                                              'images/profile_avatar.png'),
                                        ),
                                ),
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                              top: 20.0,
                            ),
                            child: IconButton(
                                icon: Icon(
                                  FontAwesomeIcons.camera,
                                  size: 30.0,
                                ),
                                onPressed: () {
                                  getImage();
                                }),
                          ),
                        ]),
                    SizedBox(height: 10.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Gender',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                        Radio<String>(
                          activeColor: Colors.blue,
                          value: 'Male',
                          groupValue: gender_option,
                          onChanged: _handleGenderSelected,
                        ),
                        Text('Male'),
                        Radio<String>(
                          value: 'Female',
                          groupValue: gender_option,
                          activeColor: Colors.blue,
                          onChanged: _handleGenderSelected,
                        ),
                        Text('Female'),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 3,
                          child: Container(
                            padding: EdgeInsets.only(right: 5.0),
                            child: TextFormField(
                              validator: (value) =>
                                  value.isEmpty ? 'Name required' : null,
                              decoration: profileTextInputDecoration.copyWith(
                                  labelText: 'Name'),
                              onChanged: (String name) {
                                _profile.uName = name;
                              },
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  value.isEmpty ? 'Age required' : null,
                              decoration: profileTextInputDecoration.copyWith(
                                  labelText: 'Age'),
                              onChanged: (String age) {
                                _profile.uAge = age;
                              },
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
                                keyboardType: TextInputType.text,
                                validator: (value) =>
                                    value.isEmpty ? 'State required' : null,
                                decoration: profileTextInputDecoration.copyWith(
                                    labelText: 'State'),
                                onChanged: (String state) {
                                  _profile.uState = state;
                                },
                              ),
                            )),
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: TextFormField(
                              keyboardType: TextInputType.text,
                              validator: (value) =>
                                  value.isEmpty ? 'Country required' : null,
                              decoration: profileTextInputDecoration.copyWith(
                                  labelText: 'Country'),
                              onChanged: (String country) {
                                _profile.uCountry = country;
                              },
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
                          keyboardType: TextInputType.phone,
                          validator: (value) =>
                              value.isEmpty ? 'Phone required' : null,
                          decoration: profileTextInputDecoration.copyWith(
                              labelText: 'Phone Number'),
                          onChanged: (String phone) {
                            _profile.phone = phone;
                          },
                        )))
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Material(
                              color: Colors.grey[200],
                              shadowColor: Colors.lightGreen,
                              elevation: 7.0,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                              child: MaterialButton(
                                minWidth: 70,
                                height: 52,
                                child: Icon(
                                  Icons.arrow_back_ios,
                                  size: 29.0,
                                ),
                                onPressed: () => {},
                              )),
                        ),
                        Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.only(left: 5.0, right: 5.0),
                            width: 135.0,
                            child: Material(
                              color: Colors.green,
                              shadowColor: Colors.lightGreen,
                              elevation: 7.0,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                              child: MaterialButton(
                                minWidth: 135,
                                height: 52,
                                child: Text(
                                  'SAVE',
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () async {
                                  uploadAvatar(context);
                                  if (_formKey.currentState.validate()) {
                                    setState(() {
                                      loading = true;
                                    });

                                    dynamic result =
                                        await _profile.updateProfile(user.uid);
                                    //print(result);
                                    if (result != null) {
                                      _btnForwardEnable = true;
                                    }
                                  }
                                },
                              ),
                            )),
                        Container(
                          child: Material(
                              color: Colors.grey[200],
                              shadowColor: Colors.lightGreen,
                              elevation: 7.0,
                              borderRadius: BorderRadius.all(
                                Radius.circular(5.0),
                              ),
                              child: MaterialButton(
                                minWidth: 70,
                                height: 52,
                                child: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 29.0,
                                ),
                                onPressed: _btnForwardEnable ? () => {} : null,
                              )),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
