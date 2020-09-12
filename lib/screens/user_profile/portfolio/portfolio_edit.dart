import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_app/models/portfolio.dart';
import 'package:job_app/screens/user_profile/portfolio/additional_info_portfolio.dart';
import 'package:job_app/screens/user_profile/portfolio/portfolio_details.dart';
import 'package:job_app/shared/constants.dart';

class PortfolioEdit extends StatefulWidget {
  final Portfolio data;
  PortfolioEdit({this.data});
  @override
  _PortfolioEditState createState() => _PortfolioEditState();
}

class _PortfolioEditState extends State<PortfolioEdit> {
  bool isloading = false;
  String year;
  String title;
  String description;
  dynamic processOutcome;

  final _formKey = GlobalKey<FormState>();

  //----------------------------------------------------------------------------------------

  TextEditingController _yearController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  //---------------------------------------------------------------------------------------

  void updatePortfolio(String docId, BuildContext context) async {
    print(docId);
    DocumentReference docRef =
        Firestore.instance.collection("Portfolio").document(docId);

    Map<String, dynamic> editedData = {
      "Id": widget.data.itemId,
      "description": _descriptionController.text,
      "owner": widget.data.owner,
      "title": _titleController.text,
      "year": _yearController.text,
    };

    await docRef.setData(editedData).whenComplete(() {
      processOutcome = "Portfolio has been updated.";
      showInSnackBar(processOutcome, context);
      setState(() {
        isloading = false;
      });
    });
  }

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
  void retrieveData() {
    _yearController.text = widget.data.year;
    _titleController.text = widget.data.title;
    _descriptionController.text = widget.data.description;
  }

//---------------------------------------------------------------------------------------

  @override
  void initState() {
    retrieveData();
    super.initState();
  }

//-----------------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
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
                          Text(
                            'Edit Portfolio',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SourceSansPro'),
                          ),
                          SizedBox(height: 10.0),
                          SizedBox(height: 20.0),
                          Row(
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: _yearController,
                                  validator: (value) =>
                                      value.isEmpty ? 'Year is required' : null,
                                  decoration: profileTextInputDecoration
                                      .copyWith(labelText: 'Year'),
                                  maxLength: 4,
                                ),
                              ),
                              SizedBox(width: 1.0),
                              Expanded(
                                flex: 3,
                                child: TextFormField(
                                  controller: _titleController,
                                  validator: (value) => value.isEmpty
                                      ? 'Title is required'
                                      : null,
                                  decoration: profileTextInputDecoration
                                      .copyWith(labelText: 'Title'),
                                  inputFormatters: [
                                    LengthLimitingTextInputFormatter(100),
                                  ],
                                  maxLength: 100,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          TextFormField(
                            controller: _descriptionController,
                            validator: (value) => value.isEmpty
                                ? 'Description is required'
                                : null,
                            maxLines: 7,
                            keyboardType: TextInputType.multiline,
                            decoration: profileTextInputDecoration.copyWith(
                                labelText: 'Description'),
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

                                        updatePortfolio(
                                            widget.data.id, context);
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
