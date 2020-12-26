import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_app/models/education.dart';
import 'package:job_app/models/user.dart';
import 'package:job_app/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class EducationEdit extends StatefulWidget {
  final Education data;
  final String pageState;
  EducationEdit({this.data, this.pageState});
  @override
  _EducationEditState createState() => _EducationEditState();
}

class _EducationEditState extends State<EducationEdit> {
  bool isloading = false;
  String dateStarted, dateEnded;
  String institution, courseOfStudy;
  String level, classOfDegree;
  String docId, uuid, owner;
  dynamic processOutcome;

  final _formKey = GlobalKey<FormState>();

  //----------------------------------------------------------------------------------------

  TextEditingController _dateStartedController = TextEditingController();
  TextEditingController _dateEndedController = TextEditingController();
  TextEditingController _institutionController = TextEditingController();
  TextEditingController _courseOfStudyController = TextEditingController();
  TextEditingController _levelController = TextEditingController();
  TextEditingController _classOfDegreeController = TextEditingController();

  //---------------------------------------------------------------------------------------

  void updateEducation(userId, context) async {
    uuid = widget.data.uuid;
    docId = widget.data.docId;
    owner = widget.data.owner;
    dateStarted = _dateStartedController.text;
    dateEnded = _dateEndedController.text;
    institution = _institutionController.text;
    courseOfStudy = _courseOfStudyController.text;
    level = _levelController.text;
    classOfDegree = _classOfDegreeController.text;

    try {
      DocumentReference documentRef =
          Firestore.instance.collection("Education").document(docId);
      Map<String, dynamic> educationData = {
        'id': uuid,
        'owner': userId,
        'date_started': dateStarted,
        'date_ended': dateEnded,
        'institution': institution,
        'course_of_study': courseOfStudy,
        'level': level,
        'class_of_degree': classOfDegree
      };

      await documentRef.updateData(educationData).whenComplete(() {
        processOutcome = 'Education information has been Updated.';
      });
    } catch (e) {
      processOutcome = e.toString();
      print(e.toString());
    }
    setState(() {
      isloading = false;
    });
    showInSnackBar(processOutcome, context);
  } // end of addPortfolio

//---------------------------------------------------------------------------------------

  void showInSnackBar(String processOutcome, BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          processOutcome,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        duration: Duration(seconds: 6),
      ),
    );
  }

//------------------------------------------------------------------------------------------

  void retrieveEducationItem() {
    _dateStartedController.text = widget.data.dateStarted;
    _dateEndedController.text = widget.data.dateEnded;
    _institutionController.text = widget.data.institution;
    _courseOfStudyController.text = widget.data.courseOfStudy;
    _levelController.text = widget.data.level;
    _classOfDegreeController.text = widget.data.classOfDegree;
  }

//--------------------------------------------------------------------------------------------

  @override
  void initState() {
    // TODO: implement initState
    retrieveEducationItem();
    super.initState();
  }

//------------------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return SafeArea(
      child: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            return ListView(children: <Widget>[
              isloading ? LinearProgressIndicator() : Container(),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
                child: Stack(children: <Widget>[
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
                          Text(
                            'Add Education',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SourceSansPro'),
                          ),
                          SizedBox(height: 20.0),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _dateStartedController,
                                  validator: (value) =>
                                      value.isEmpty ? 'Date is required' : null,
                                  decoration: profileTextInputDecoration
                                      .copyWith(labelText: 'Date Started'),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(20)
                                  ],
                                  //maxLength: 4,
                                ),
                              ),
                              SizedBox(width: 3.0),
                              Expanded(
                                flex: 2,
                                child: TextFormField(
                                  controller: _dateEndedController,
                                  validator: (value) =>
                                      value.isEmpty ? 'Date is required' : null,
                                  decoration: profileTextInputDecoration
                                      .copyWith(labelText: 'Date Ended'),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(20),
                                  ],
                                  //maxLength: 100,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 6.0,
                          ),
                          TextFormField(
                            controller: _institutionController,
                            validator: (value) => value.isEmpty
                                ? 'Institution is required'
                                : null,
                            decoration: profileTextInputDecoration.copyWith(
                                labelText: 'Institution'),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(150)
                            ],
                          ),
                          SizedBox(height: 6.0),
                          TextFormField(
                            controller: _courseOfStudyController,
                            validator: (value) => value.isEmpty
                                ? 'Course of Study is required'
                                : null,
                            decoration: profileTextInputDecoration.copyWith(
                                labelText: 'Course of Study'),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(150)
                            ],
                          ),
                          SizedBox(height: 6.0),
                          TextFormField(
                            controller: _levelController,
                            validator: (value) =>
                                value.isEmpty ? 'Level is required' : null,
                            decoration: profileTextInputDecoration.copyWith(
                                labelText: 'Level e.g. BSc, MSc, PhD.'),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50),
                            ],
                          ),
                          SizedBox(height: 6.0),
                          TextFormField(
                            controller: _classOfDegreeController,
                            keyboardType: TextInputType.text,
                            decoration: profileTextInputDecoration.copyWith(
                                labelText: 'Class of Degree (optional)'),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50),
                            ],
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Material(
                                  color: Colors.grey[400],
                                  shadowColor: Colors.lightGreen,
                                  elevation: 7.0,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6.0),
                                  ),
                                  child: MaterialButton(
                                      child: Icon(
                                        Icons.chevron_left,
                                        size: 40.0,
                                      ),
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      minWidth: 70.0,
                                      height: 52.0),
                                ),
                                SizedBox(
                                  width: 6.0,
                                ),
                                Material(
                                  color: Colors.green,
                                  shadowColor: Colors.lightGreen,
                                  elevation: 7.0,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(6.0),
                                  ),
                                  child: MaterialButton(
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        setState(() {
                                          isloading = true;
                                        });

                                        updateEducation(user.uid, context);
                                      }
                                    },
                                    child: Text(
                                      'UPDATE',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 16.0),
                                    ),
                                    minWidth: 120.0,
                                    height: 52.0,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ]),
                  ),
                ]),
              ),
            ]);
          },
        ),
      ),
    );
  }
}
