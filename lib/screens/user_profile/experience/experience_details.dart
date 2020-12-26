import 'package:flutter/material.dart';
import 'package:job_app/models/education.dart';
import 'package:job_app/screens/user_profile/education/education_edit.dart';
import 'package:job_app/models/experience.dart';
import 'package:job_app/screens/user_profile/experience/experience_edit.dart';

class ExperienceDetails extends StatefulWidget {
  final Experience data;
  final String pageState;
  ExperienceDetails({this.data, this.pageState});

  @override
  _ExperienceDetailsState createState() => _ExperienceDetailsState();
}

class _ExperienceDetailsState extends State<ExperienceDetails> {
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
                                      'Experience Details',
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
                                          builder: (context) => ExperienceEdit(
                                            data: widget.data,
                                            pageState: widget.pageState,
                                          ),
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
                              "Period",
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
                            child: Text(widget.data.fromDate +
                                " - " +
                                widget.data.toDate),
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
                            child: Text(
                              'Organisation',
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
                            child: Text(widget.data.organisation),
                          ),
                          SizedBox(height: 15.0),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
                            child: Text(
                              'Position',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 2.0),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
                            child: Text(widget.data.position),
                          ),
                          SizedBox(height: 15.0),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
                            child: Text(
                              'Duties',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(height: 2.0),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding:
                                const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 5.0),
                            child: Text(widget.data.duties),
                          ),
                          SizedBox(height: 15.0),
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
