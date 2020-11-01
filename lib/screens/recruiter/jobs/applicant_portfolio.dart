import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_app/screens/recruiter/jobs/applicant_portfolio_details.dart';

class ApplicantPortfolio extends StatefulWidget {
  String userId, userAvatar, userName;
  ApplicantPortfolio({this.userId, this.userAvatar, this.userName});
  @override
  _ApplicantPortfolioState createState() => _ApplicantPortfolioState();
}

class _ApplicantPortfolioState extends State<ApplicantPortfolio> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          StreamBuilder(
              stream: Firestore.instance
                  .collection("Portfolio")
                  .where("owner", isEqualTo: widget.userId.toString())
                  .snapshots(),
              builder: (context, snapshot) {
                return !snapshot.hasData
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot data =
                              snapshot.data.documents[index];
                          return ApplicantPortfolioItem(
                            documentSnapshot: data,
                            docId: data.documentID,
                            uuid: data['id'],
                            title: data['title'],
                            description: data['description'],
                            owner: data['owner'],
                            year: data['year'],
                            userAvatar: widget.userAvatar,
                            userName: widget.userName,
                          );
                        });
              })
        ],
      ),
    );
  }
}

class ApplicantPortfolioItem extends StatefulWidget {
  String docId, uuid, title, description, owner, year, userAvatar, userName;
  DocumentSnapshot documentSnapshot;
  ApplicantPortfolioItem(
      {this.docId,
      this.uuid,
      this.title,
      this.description,
      this.owner,
      this.year,
      this.userAvatar,
      this.userName,
      this.documentSnapshot});
  @override
  _ApplicantPortfolioItemState createState() => _ApplicantPortfolioItemState();
}

class _ApplicantPortfolioItemState extends State<ApplicantPortfolioItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 5.0),
                child: Icon(
                  Icons.radio_button_checked,
                  color: Colors.blue,
                ),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.title,
                      style: TextStyle(
                        fontFamily: 'SourceSansPro',
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      widget.year,
                      style: TextStyle(fontSize: 12.0),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 8.0),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ApplicantPortfolioDetails(
                            docId: widget.docId,
                            uuid: widget.uuid,
                            title: widget.title,
                            description: widget.description,
                            owner: widget.owner,
                            year: widget.year,
                            userAvatar: widget.userAvatar,
                            userName: widget.userName),
                      ),
                    );
                  },
                  child: Icon(Icons.chevron_right),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
