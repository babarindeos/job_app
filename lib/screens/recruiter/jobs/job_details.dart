import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_app/models/jobposted.dart';
import 'package:job_app/screens/recruiter/jobs/job_edit.dart';
import 'package:job_app/screens/recruiter/jobs/job_view.dart';

class JobDetails extends StatefulWidget {
  final JobPosted data;
  JobDetails({this.data});
  @override
  _JobDetailsState createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Job Details'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobView(data: widget.data),
                    ),
                  );
                },
                child: Icon(Icons.person),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 14.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => JobEdit(data: widget.data),
                    ),
                  );
                },
                child: Icon(Icons.edit),
              ),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 5.0),
          children: <Widget>[
            Row(children: <Widget>[
              Text(
                'Created ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Container(
                child: Text(widget.data.postedFmt),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      'Closes ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text('${widget.data.expiration}'),
                ],
              ),
            ]),
            SizedBox(
              height: 20.0,
            ),
            Text(
              'Position',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4.0),
            Text(widget.data.position),
            SizedBox(height: 20.0),
            Text('Area/Sector', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4.0),
            Text(widget.data.area),
            SizedBox(height: 20.0),
            Text('Location', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4.0),
            Text(widget.data.location),
            SizedBox(height: 20.0),
            Text('Payment', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4.0),
            Text(widget.data.payment),
            SizedBox(height: 20.0),
            Text('Description/ Responsibilities',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 4.0),
            Text(widget.data.description),
          ],
        ),
      ),
    );
  }
}
