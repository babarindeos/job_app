import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:job_app/models/profile.dart';
import 'package:job_app/models/storage.dart';
import 'package:job_app/models/user.dart';
import 'package:job_app/services.dart/auth.dart';
import 'package:job_app/shared/constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';

final StorageReference storageRef = FirebaseStorage.instance.ref();

class CreateProfile extends StatefulWidget {
  @override
  _CreateProfileState createState() => _CreateProfileState();
}

class _CreateProfileState extends State<CreateProfile> {
  File _image, file;
  String gender_option = '';
  bool loading = false;
  bool _btnForwardEnable = false;
  bool isUploading = false;
  String postId = Uuid().v4();
  String _userId = '';
  String mediaUrl = '';
  String _processResult;
  String result;

  final _formKey = GlobalKey<FormState>();
  // call Profile Class
  final Profile _profile = Profile();
  final Storage _storage = Storage();

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
      _storage.pFile = image;
      print('Image Path $_image');
    });
  }

  createPostInFirestore() {}

  Future processForm(String uid) async {
    // Set isUploading for LinearProgress indicator
    setState(() {
      isUploading = true;
    });

    // called storage class: uploadAvatar method
    if (_image != null) {
      mediaUrl = await _storage.uploadAvatar(uid, 'avatar');
    }

    print(mediaUrl);
    result = await _profile.updateProfile(uid, mediaUrl);

    // End upload
    setState(() {
      isUploading = false;
      _btnForwardEnable = true;
    });
    // End of upload
  }

  handleForwardButton() {
    print("Move forward");
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // TODO: implement build
    return SafeArea(
      child: Scaffold(
        body: Builder(builder: (BuildContext context) {
          return ListView(
            children: <Widget>[
              isUploading ? LinearProgressIndicator() : Text(""),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 10.0),
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
                                  decoration: profileTextInputDecoration
                                      .copyWith(labelText: 'State'),
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
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/userType');
                                  },
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
                                    if (_formKey.currentState.validate()) {
                                      processForm(user.uid);
                                      setState(() {
                                        Scaffold.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              'Your Profile has been Updated.'),
                                          duration: Duration(seconds: 3),
                                        ));
                                      });
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
                                  onPressed: _btnForwardEnable
                                      ? () {
                                          handleForwardButton();
                                        }
                                      : null,
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
