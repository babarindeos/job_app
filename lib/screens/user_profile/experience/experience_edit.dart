import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_app/models/experience.dart';
import 'package:job_app/models/user.dart';
import 'package:job_app/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ExperienceEdit extends StatefulWidget {
  final Experience data;
  final String pageState;
  ExperienceEdit({Key key, this.data, this.pageState}) : super(key: key);
  @override
  _ExperienceEditState createState() => _ExperienceEditState();
}

class _ExperienceEditState extends State<ExperienceEdit> {
  bool isloading = false;
  String fromDate, toDate;
  String organisation, position;
  String duties;
  dynamic processOutcome;

  final _formKey = GlobalKey<FormState>();

  //----------------------------------------------------------------------------------------

  TextEditingController _fromDateController = TextEditingController();
  TextEditingController _toDateController = TextEditingController();
  TextEditingController _organisationController = TextEditingController();
  TextEditingController _positionController = TextEditingController();
  TextEditingController _dutiesController = TextEditingController();

  //---------------------------------------------------------------------------------------

  void updateExperience(userId, context) async {
    //var uuidFactory = Uuid();
    //var uuid = uuidFactory.v4();
    fromDate = _fromDateController.text;
    toDate = _toDateController.text;
    organisation = _organisationController.text;
    position = _positionController.text;
    duties = _dutiesController.text;

    try {
      DocumentReference documentRef = Firestore.instance
          .collection("Experience")
          .document(widget.data.docId);
      Map<String, dynamic> experienceData = {
        //'uuid': uuid,
        //'owner': userId,
        'from_date': _fromDateController.text,
        'to_date': _toDateController.text,
        'organisation': _organisationController.text,
        'position': _positionController.text,
        'duties': _dutiesController.text,
      };

      await documentRef.updateData(experienceData).whenComplete(() {
        processOutcome = 'Experience has been updated.';
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
  void retrieveExperienceItem() {
    _fromDateController.text = widget.data.fromDate;
    _toDateController.text = widget.data.toDate;
    _organisationController.text = widget.data.organisation;
    _positionController.text = widget.data.position;
    _dutiesController.text = widget.data.duties;
  }

//------------------------------------------------------------------------------------------

  @override
  void initState() {
    print(widget.data.docId);
    retrieveExperienceItem();
    // TODO: implement initState
  }

//-----------------------------------------------------------------------------------------
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
                                  padding: const EdgeInsets.only(
                                    top: 20.0,
                                  ),
                                ),
                          Text(
                            'Additional Information',
                            style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SourceSansPro'),
                          ),
                          Text(
                            'Edit Experience',
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
                                  controller: _fromDateController,
                                  validator: (value) =>
                                      value.isEmpty ? 'Date is required' : null,
                                  decoration: profileTextInputDecoration
                                      .copyWith(labelText: 'From Date'),
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
                                  controller: _toDateController,
                                  validator: (value) =>
                                      value.isEmpty ? 'Date is required' : null,
                                  decoration: profileTextInputDecoration
                                      .copyWith(labelText: 'To Date'),
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
                            controller: _organisationController,
                            validator: (value) => value.isEmpty
                                ? 'Organisation is required'
                                : null,
                            decoration: profileTextInputDecoration.copyWith(
                                labelText: 'Organisation'),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(150)
                            ],
                          ),
                          SizedBox(height: 6.0),
                          TextFormField(
                            controller: _positionController,
                            validator: (value) =>
                                value.isEmpty ? 'Position is required' : null,
                            decoration: profileTextInputDecoration.copyWith(
                                labelText: 'Position'),
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(150)
                            ],
                          ),
                          SizedBox(height: 6.0),
                          TextFormField(
                            controller: _dutiesController,
                            maxLines: 4,
                            validator: (value) =>
                                value.isEmpty ? 'Duties is required' : null,
                            decoration: profileTextInputDecoration.copyWith(
                                labelText: 'Duties & Responsibilities'),
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

                                        updateExperience(user.uid, context);
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
