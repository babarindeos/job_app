import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:job_app/models/jobposted.dart';
import 'package:job_app/models/user.dart';
import 'package:job_app/shared/constants.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

final _formKey = GlobalKey<FormState>();

class JobEdit extends StatefulWidget {
  final JobPosted data;
  JobEdit({this.data});

  @override
  _JobEditState createState() => _JobEditState();
}

class _JobEditState extends State<JobEdit> {
  //Declare variables
  DateTime _selectedDate = DateTime.now();
  var _strFormattedDate;
  var _strDbDate;
  DateFormat _newFormat;
  String processOutcome;
  DateTime dtToday;
  String strToday;
  bool isLoading = false;

  //----------------------------------------------------------------------------
  Future<void> pickDateModule() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _newFormat = DateFormat("MMM. d, yyyy");
        _strFormattedDate = _newFormat.format(_selectedDate);
        _newFormat = DateFormat("yyyy-MM-dd");
        _strDbDate = _newFormat.format(_selectedDate);
      });
      print(_strFormattedDate);
      _expiryController.text = _strFormattedDate;
    }
  }

  //----------------------------------------------------------------------------
  TextEditingController _positionController = TextEditingController();
  TextEditingController _areaController = TextEditingController();
  TextEditingController _aboutController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _paymentController = TextEditingController();
  TextEditingController _expiryController = TextEditingController();

  //----------------------------------------------------------------------------
  Future<void> _updateJob(String companyId, BuildContext context) async {
    try {
      DocumentReference docReference = Firestore.instance
          .collection("Job_Postings")
          .document(widget.data.docId);
      Map<String, dynamic> jobData = {
        "uid": widget.data.uid,
        "owner": widget.data.owner,
        "position": _positionController.text,
        "area": _areaController.text,
        "description": _aboutController.text,
        "location": _locationController.text,
        "payment": _paymentController.text,
        "expiration": _expiryController.text,
        "posted": widget.data.posted,
      };

      await docReference.updateData(jobData).whenComplete(() {
        processOutcome = "Job has been Updated";
      });
    } catch (e) {
      processOutcome = e.toString();
      print(e.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
      showInSnackBar(processOutcome, context);
    }
  }

  //----------------------------------------------------------------------------
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

  //----------------------------------------------------------------------------
  void retrieveJobData() {
    _positionController.text = widget.data.position;
    _areaController.text = widget.data.area;
    _aboutController.text = widget.data.description;
    _locationController.text = widget.data.location;
    _paymentController.text = widget.data.payment;
    _expiryController.text = widget.data.expiration;

    print(widget.data.docId);
    setState(() {
      isLoading = false;
    });
  }
  //-----------------------------------------------------------------------------

  @override
  void initState() {
    setState(() {
      isLoading = true;
    });
    retrieveJobData();
    super.initState();
  }

  //----------------------------------------------------------------------------

  @override
  void dispose() {
    // TODO: implement dispose
    _positionController.dispose();
    _areaController.dispose();
    _aboutController.dispose();
    _locationController.dispose();
    _paymentController.dispose();
    _expiryController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final companyId = Provider.of<User>(context);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Edit Job Post'),
        ),
        body: Builder(
          builder: (BuildContext context) {
            return isLoading
                ? SpinKitDoubleBounce(color: Colors.blueAccent, size: 50.0)
                : ListView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 5.0, horizontal: 10.0),
                    children: <Widget>[
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                height: 5.0,
                              ),
                              TextFormField(
                                controller: _positionController,
                                validator: (value) => value.isEmpty
                                    ? 'Job Position is required'
                                    : null,
                                decoration: profileTextInputDecoration.copyWith(
                                    labelText: 'Job Position'),
                              ),
                              SizedBox(height: 8.0),
                              TextFormField(
                                controller: _areaController,
                                validator: (value) => value.isEmpty
                                    ? 'Job Line is required'
                                    : null,
                                decoration: profileTextInputDecoration.copyWith(
                                    labelText:
                                        'Job Area e.g Software Engineering '),
                              ),
                              SizedBox(height: 8.0),
                              TextFormField(
                                controller: _aboutController,
                                validator: (value) => value.isEmpty
                                    ? 'Job Description is required'
                                    : null,
                                decoration: profileTextInputDecoration.copyWith(
                                    labelText: 'About Job'),
                                maxLines: 3,
                                keyboardType: TextInputType.multiline,
                              ),
                              SizedBox(height: 8.0),
                              TextFormField(
                                controller: _locationController,
                                validator: (value) => value.isEmpty
                                    ? 'Location is required'
                                    : null,
                                decoration: profileTextInputDecoration.copyWith(
                                    labelText: 'Location'),
                              ),
                              SizedBox(height: 8.0),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: TextFormField(
                                        controller: _paymentController,
                                        validator: (value) => value.isEmpty
                                            ? 'Payment is required'
                                            : null,
                                        decoration: profileTextInputDecoration
                                            .copyWith(labelText: 'Payment'),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 4.0),
                                  Expanded(
                                    flex: 2,
                                    child: Container(
                                      child: TextFormField(
                                          controller: _expiryController,
                                          validator: (value) => value.isEmpty
                                              ? 'Expiry Date is required'
                                              : null,
                                          decoration: profileTextInputDecoration
                                              .copyWith(
                                                  labelText: 'Expiry Date'),
                                          readOnly: true,
                                          onTap: () async {
                                            pickDateModule();
                                          }),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(height: 5.0),
                              Container(
                                child: Material(
                                  color: Colors.green,
                                  shadowColor: Colors.lightGreen,
                                  elevation: 7.0,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(5.0),
                                  ),
                                  child: MaterialButton(
                                    onPressed: () async {
                                      if (_formKey.currentState.validate()) {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        _updateJob(companyId.uid, context);
                                      }
                                    },
                                    minWidth: 100,
                                    height: 30.0,
                                    child: Text(
                                      'Update Job',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ]);
          },
        ),
      ),
    );
  }
}
