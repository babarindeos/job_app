import 'package:flutter/material.dart';
import 'package:job_app/models/education.dart';
import 'package:job_app/screens/user_profile/education/education_edit.dart';

class EducationDetails extends StatefulWidget {
  final Education data;
  final String pageState;
  EducationDetails({this.data, this.pageState});

  @override
  _EducationDetailsState createState() => _EducationDetailsState();
}

class _EducationDetailsState extends State<EducationDetails> {
  bool isloading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          children: <Widget>[
            isloading ? LinearProgressIndicator() : Container(),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.fromLTRB(5.0, 0.0, 13.0, 0.0),
              child: Stack(
                children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          widget.pageState.isEmpty
                              ? Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 10.0),
                                  child: Image(
                                    image: AssetImage('images/step-3-mini.png'),
                                    width: 150.0,
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.only(top: 20.0),
                                ),
                          Text(
                            'Additional Information',
                            style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SourceSansPro'),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(
                                        Icons.arrow_back,
                                        size: 30.0,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Education Details',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'SourceSansPro'),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EducationEdit(
                                              data: widget.data,
                                              pageState: widget.pageState),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      child:
                                          Icon(Icons.edit, color: Colors.blue),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.0),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
                            child: Text(
                              "Duration",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
                            child: Text(widget.data.dateStarted +
                                " - " +
                                widget.data.dateEnded),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
                            child: Text(
                              'Institution',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
                            child: Text(widget.data.institution),
                          ),
                          SizedBox(height: 15.0),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
                            child: Text(
                              'Course of Study',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 2.0),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
                            child: Text(widget.data.courseOfStudy),
                          ),
                          SizedBox(height: 15.0),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
                            child: Text(
                              'Level',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 2.0),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
                            child: Text(widget.data.level),
                          ),
                          SizedBox(height: 15.0),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
                            child: Text(
                              'Class of Degree',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(
                            height: 2.0,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
                            child: Text(widget.data.classOfDegree),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
