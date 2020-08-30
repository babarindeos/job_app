import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:job_app/models/user.dart';
import 'package:provider/provider.dart';

class FormKeys {
  static final frmKey1 = GlobalKey<FormState>();
  static final frmKey2 = const Key('__R1KEY2__');
  static final frmKey3 = const Key('__R1KEY3__');
}

final GlobalKey<FormState> _formKey =
    new GlobalKey<FormState>(debugLabel: '_loginFormKey');

class AdditionalInfo extends StatefulWidget {
  @override
  _AdditionalInfoState createState() => _AdditionalInfoState();
}

class _AdditionalInfoState extends State<AdditionalInfo> {
  bool isloading = false;

//---------------------------------------------------------------------------
  Widget showLoader() {
    return Center(
      child: SpinKitDoubleBounce(
        color: Colors.blueAccent,
        size: 100.0,
      ),
    );
  }
//-----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return SafeArea(
        child: Scaffold(
      body: isloading
          ? showLoader()
          : ListView(children: <Widget>[
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
                          image: AssetImage('images/step-3-mini.png'),
                          width: 150.0,
                        ),
                      ),
                      Text(
                        'Additional Information',
                        style: TextStyle(
                            fontSize: 28.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'SourceSansPro'),
                      ),
                      SizedBox(height: 10.0),
                      SizedBox(height: 2.0),
                      Card(
                        elevation: 5.0,
                        child: Container(
                          padding: EdgeInsets.all(0.0),
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(7.0),
                                child: Column(
                                  children: <Widget>[
                                    Text(
                                      'John Smith',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22.0,
                                        fontFamily: 'Pacifico-Regular',
                                      ),
                                    ),
                                    Text('Senior PHP Developer')
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  padding: EdgeInsets.all(7.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                            width: 1.0,
                                            color: Colors.grey.shade300,
                                          ),
                                          top: BorderSide(
                                            width: 1.0,
                                            color: Colors.grey.shade300,
                                          ))),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        top: 5.0, bottom: 5.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Icon(Icons.person,
                                              color: Colors.blue.shade700),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            'Bio',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0),
                                          ),
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
                              ),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  padding:
                                      EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                    bottom: BorderSide(
                                      width: 1.0,
                                      color: Colors.grey.shade300,
                                    ),
                                  )),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Icon(Icons.insert_drive_file,
                                              color: Colors.blue.shade700),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            'Portfolio',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0),
                                          ),
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
                              ),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  padding:
                                      EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                    bottom: BorderSide(
                                      width: 1.0,
                                      color: Colors.grey.shade300,
                                    ),
                                  )),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Icon(Icons.business_center,
                                              color: Colors.blue.shade700),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            'Projects',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0),
                                          ),
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
                              ),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  padding:
                                      EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                    bottom: BorderSide(
                                      width: 1.0,
                                      color: Colors.grey.shade300,
                                    ),
                                  )),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Icon(Icons.account_balance,
                                              color: Colors.blue.shade700),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            'Education',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0),
                                          ),
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
                              ),
                              InkWell(
                                onTap: () {},
                                child: Container(
                                  padding:
                                      EdgeInsets.only(top: 5.0, bottom: 5.0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                    bottom: BorderSide(
                                      width: 1.0,
                                      color: Colors.grey.shade300,
                                    ),
                                  )),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 1,
                                          child: Icon(Icons.public,
                                              color: Colors.blue.shade700),
                                        ),
                                        Expanded(
                                          flex: 4,
                                          child: Text(
                                            'Experience',
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0),
                                          ),
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
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                    ],
                  ),
                ),
              ),
            ]),
    ));
  }
}
