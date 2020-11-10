import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:job_app/shared/constants.dart';
import 'package:intl/intl.dart';
import 'package:date_format/date_format.dart';
import 'package:uuid/uuid.dart';

final _formKey = GlobalKey<FormState>();

class ScheduleInterview extends StatefulWidget {
  String candidateId,
      candidateName,
      candidateAvatar,
      companyId,
      applicationId,
      jobId,
      jobPosition,
      shortlistedDocId;
  ScheduleInterview(
      {this.candidateId,
      this.candidateName,
      this.candidateAvatar,
      this.companyId,
      this.applicationId,
      this.jobId,
      this.jobPosition,
      this.shortlistedDocId});

  @override
  _ScheduleInterviewState createState() => _ScheduleInterviewState();
}

class _ScheduleInterviewState extends State<ScheduleInterview> {
  DateTime _selectedDate = DateTime.now();
  var _strFormattedDate;
  var _strDbDate;
  DateFormat _newFormat;
  String processOutcome;
  DateTime dtToday;
  String strToday;
  String strToday_fmt;
  bool isLoading = false;
  DateTime _dtDbDate;

  String _hour, _minute, _time;

  TextEditingController _scheduleDateController = new TextEditingController();
  TextEditingController _scheduleTimeController = new TextEditingController();
  TextEditingController _commentController = new TextEditingController();

  //----------------------------------------------------------------------------
  TimeOfDay _selectedTime = TimeOfDay(hour: 00, minute: 00);

  //----------------------------------------------------------------------------
  Future<void> _pickTimeModule() async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _hour = _selectedTime.hour.toString();
        _minute = _selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _scheduleTimeController.text = formatDate(
            DateTime(2019, 08, 1, _selectedTime.hour, _selectedTime.minute),
            [hh, ':', nn, '', am]).toString();
      });
    }
  }

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
        _newFormat = DateFormat("E MMM. d, yyyy");
        _strFormattedDate = _newFormat.format(_selectedDate);
        _newFormat = DateFormat("yyyy-MM-dd");
        _strDbDate = _newFormat.format(_selectedDate);
        _dtDbDate = _selectedDate.toUtc();
      });
      print(_strFormattedDate);
      _scheduleDateController.text = _strFormattedDate;
    }
  }

//------------------------------------------------------------------------------
  Future<void> _postScheduleInterview(BuildContext context) async {
    String msg = '';
    try {
      var uuid = Uuid();
      var uid = uuid.v4();
      DocumentReference docReference =
          Firestore.instance.collection("Interview_Schedule").document();

      Map<String, dynamic> schedule = {
        "uid": uid,
        "job_docid": widget.jobId,
        "candidate_docid": widget.candidateId,
        "company_docid": widget.companyId,
        "application_docid": widget.applicationId,
        "shortlisted_docid": widget.shortlistedDocId,
        "schedule_date": _scheduleDateController.text,
        "schedule_date_unfmt": _strDbDate,
        "schedule_date_dtfmt": _dtDbDate,
        "schedule_time": _scheduleTimeController.text,
        "comment": _commentController.text,
        "date_created": DateTime.now()
      };
      await docReference.setData(schedule).then((dataSnapshot) {
        msg = "An interview has been scheduled with the candidate";
      });
    } catch (e) {
      msg = "An error occurred " + e.message.toString();
    } finally {
      setState(() {
        _scheduleDateController.clear();
        _scheduleTimeController.clear();
        _commentController.clear();

        isLoading = false;
      });
      showInSnackBar(msg, context);
    }
  }

//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Snackbar function
  void showInSnackBar(String value, BuildContext context) {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value,
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.black,
      ),
    );
  }

//------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Schedule Interview'),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.send,
                  size: 30.0,
                ),
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    setState(() {
                      isLoading = true;
                    });
                    _postScheduleInterview(context);
                  }
                })
          ],
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.only(
                        left: 8.0, top: 10.0, right: 10.0, bottom: 10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CircleAvatar(
                          radius: 36.0,
                          backgroundColor: Colors.blue,
                          child: CircleAvatar(
                            radius: 35.0,
                            backgroundColor: Colors.white,
                            child: ClipOval(
                              child: SizedBox(
                                width: 100,
                                height: 180,
                                child: widget.candidateAvatar == null
                                    ? Image(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            'images/profile_avatar.jpg'),
                                      )
                                    : Image.network(
                                        widget.candidateAvatar,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 8.0, top: 5.0),
                              width: MediaQuery.of(context).size.width * 0.7,
                              child: Text(
                                widget.candidateName,
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                            Container(
                              padding:
                                  const EdgeInsets.only(left: 8.0, top: 6.0),
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                'Applied Job - ' + widget.jobPosition,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 5.0),
                          child: TextFormField(
                            validator: (value) =>
                                value.isEmpty ? 'Date is required' : null,
                            decoration: profileTextInputDecoration.copyWith(
                                labelText: 'Schedule Date'),
                            controller: _scheduleDateController,
                            readOnly: true,
                            onTap: () async {
                              pickDateModule();
                            },
                          ),
                        ),
                        SizedBox(height: 5),
                        Container(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 5.0),
                          child: TextFormField(
                            validator: (value) =>
                                value.isEmpty ? 'Time is required' : null,
                            decoration: profileTextInputDecoration.copyWith(
                                labelText: 'Schedule Time'),
                            controller: _scheduleTimeController,
                            readOnly: true,
                            onTap: () async {
                              _pickTimeModule();
                            },
                          ),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        Container(
                          padding:
                              const EdgeInsets.fromLTRB(8.0, 3.0, 8.0, 5.0),
                          child: TextFormField(
                            decoration: profileTextInputDecoration.copyWith(
                                labelText: 'Comment'),
                            controller: _commentController,
                            keyboardType: TextInputType.multiline,
                            maxLines: 4,
                          ),
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
