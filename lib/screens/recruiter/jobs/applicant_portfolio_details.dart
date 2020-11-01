import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ApplicantPortfolioDetails extends StatefulWidget {
  String docId, uuid, title, description, owner, year, userAvatar, userName;
  ApplicantPortfolioDetails(
      {this.docId,
      this.uuid,
      this.title,
      this.description,
      this.owner,
      this.year,
      this.userAvatar,
      this.userName});

  @override
  _ApplicantPortfolioDetailsState createState() =>
      _ApplicantPortfolioDetailsState();
}

class _ApplicantPortfolioDetailsState extends State<ApplicantPortfolioDetails> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Portfolio Details'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(8.0),
          children: <Widget>[
            Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 31.0,
                  backgroundColor: Colors.blue,
                  child: CircleAvatar(
                    radius: 30.0,
                    backgroundColor: Colors.white,
                    child: ClipOval(
                      child: SizedBox(
                        width: 50,
                        height: 50,
                        child:
                            Image.network(widget.userAvatar, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8.0),
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: Text(
                    widget.userName,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 8.0,
            ),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Text(
                      widget.title + ' - ' + widget.year,
                      style: TextStyle(
                          fontFamily: 'SourceSansPro',
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    'Description',
                    style: TextStyle(
                      fontFamily: 'SourceSansPro',
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(widget.description),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
