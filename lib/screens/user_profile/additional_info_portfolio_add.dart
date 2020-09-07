import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:job_app/models/user.dart';
import 'package:job_app/shared/constants.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class AdditionalInfoPortfolioAdd extends StatefulWidget {
  AdditionalInfoPortfolioAdd({Key key}) : super(key: key);
  @override
  _AdditionalInfoPortfolioAddState createState() =>
      _AdditionalInfoPortfolioAddState();
}

class _AdditionalInfoPortfolioAddState
    extends State<AdditionalInfoPortfolioAdd> {
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

  Future<void> addPortfolio(userId, context) async {
    var uuid = Uuid();
    var docId = uuid.v4();
    year = _yearController.text;
    title = _titleController.text;
    description = _descriptionController.text;

    try {
      DocumentReference documentRef =
          Firestore.instance.collection("Portfolio").document(docId);
      Map<String, dynamic> portfolioData = {
        'year': year,
        'title': title,
        'description': description
      };
      await documentRef.setData(portfolioData).whenComplete(() {
        print("Am done");

        setState(() {
          processOutcome = 'New portfolio has been added.';
          print("done");
          isloading = false;
        });
      });
    } catch (e) {
      print(e.toString());
    }

    //showInSnackBar(processOutcome, context);
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
        duration: Duration(seconds: 3),
      ),
    );
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
                            'Add Portfolio',
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
                            keyboardType: TextInputType.text,
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

                                        addPortfolio(user.uid, context);
                                      }
                                    },
                                    child: Text(
                                      'SAVE',
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
