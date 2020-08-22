import 'package:flutter/material.dart';
import 'package:job_app/shared/constants.dart';
import 'package:flutter/widgets.dart';

class formKeys {
  static final frmKey1 = const Key('__R1KEY1__');
  static final frmKey2 = const Key('__R1KEY2__');
  static final frmKey3 = const Key('__R1KEY3__');
}

class CareerDetails extends StatefulWidget {
  @override
  _CareerDetailsState createState() => _CareerDetailsState();
}

class _CareerDetailsState extends State<CareerDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
              child: Form(
                key: formKeys.frmKey1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                      child: Image(
                        image: AssetImage('images/step-2-mini.png'),
                        width: 150.0,
                      ),
                    ),
                    Text(
                      'Career Details',
                      style: TextStyle(
                          fontSize: 28.0,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'SourceSansPro'),
                    ),
                    SizedBox(height: 10.0),
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
                                  labelText: 'Field'),
                              onChanged: (String fieldf) {},
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
                                  labelText: 'Experience'),
                              onChanged: (String experience) {},
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 3.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                            flex: 4,
                            child: Container(
                              padding: EdgeInsets.only(right: 0.0),
                              child: TextFormField(
                                keyboardType: TextInputType.text,
                                maxLines: 3,
                                validator: (value) =>
                                    value.isEmpty ? 'State required' : null,
                                decoration: profileTextInputDecoration.copyWith(
                                    labelText: 'Bio'),
                                onChanged: (String state) {},
                              ),
                            )),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            child: Text('CV',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                )),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Card(
                      elevation: 5.0,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Text('Upload Resume',
                                  style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Expanded(
                              flex: 1,
                              child: Icon(Icons.file_upload,
                                  color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Card(
                      elevation: 6.0,
                      child: Container(
                        padding: EdgeInsets.all(10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              flex: 3,
                              child: Text('Video CV',
                                  style: TextStyle(
                                      color: Colors.blue.shade700,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Expanded(
                              flex: 1,
                              child: Icon(Icons.chevron_right,
                                  color: Colors.grey.shade700),
                            ),
                          ],
                        ),
                      ),
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
                                onPressed: () => {},
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
                                  onPressed: () => {})),
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
