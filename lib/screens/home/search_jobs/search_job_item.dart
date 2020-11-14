import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_app/models/jobposted.dart';
import 'package:job_app/screens/home/jobs/job_details.dart';

class SearchJobItem extends StatefulWidget {
  final String uid,
      docId,
      owner,
      position,
      area,
      description,
      location,
      payment,
      expiration,
      posted,
      postedFmt;

  final DocumentSnapshot documentSnapshot;

  SearchJobItem(
      {@required this.uid,
      @required this.docId,
      @required this.owner,
      @required this.position,
      @required this.area,
      @required this.description,
      @required this.location,
      @required this.payment,
      @required this.expiration,
      @required this.posted,
      @required this.postedFmt,
      @required this.documentSnapshot});

  @override
  _SearchJobItemState createState() => _SearchJobItemState();
}

class _SearchJobItemState extends State<SearchJobItem> {
  JobPosted data;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 7.0,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(2.0),
                      decoration: BoxDecoration(),
                      child: Image.asset('images/company_logo.jpg'),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.position,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Icon(
                              Icons.pin_drop,
                              size: 18.0,
                              color: Colors.blue,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: Text(
                                widget.location,
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        data = JobPosted(
                          uid: widget.uid,
                          docId: widget.docId,
                          owner: widget.owner,
                          position: widget.position,
                          area: widget.area,
                          description: widget.description,
                          location: widget.location,
                          payment: widget.payment,
                          expiration: widget.expiration,
                          posted: widget.posted,
                          postedFmt: widget.postedFmt,
                        );
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => JobDetails(data: data)));
                      },
                      child: Icon(Icons.chevron_right),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.0, color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Created ${widget.postedFmt}',
                        style: TextStyle(fontSize: 11.0),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Closes ${widget.expiration}',
                          style: TextStyle(fontSize: 11.0),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
