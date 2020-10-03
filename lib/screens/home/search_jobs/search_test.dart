import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_app/screens/home/search_jobs/search_job_item.dart';
import 'package:job_app/shared/constants.dart';

class SearchTest extends StatefulWidget {
  @override
  _SearchTestState createState() => _SearchTestState();
}

class _SearchTestState extends State<SearchTest> {
  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 5.0),
              alignment: Alignment.center,
              child: Text(
                "Search Jobs",
                style: TextStyle(
                    fontFamily: 'Pacifico-Regular',
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: TextFormField(
                decoration: searchTextInputDecoration.copyWith(
                    labelText: 'Search Jobs', prefixIcon: Icon(Icons.search)),
              ),
            ),
            StreamBuilder(
                stream:
                    Firestore.instance.collection("Job_Postings").snapshots(),
                builder: (context, snapshot) {
                  return !snapshot.hasData
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (context, index) {
                            DocumentSnapshot data =
                                snapshot.data.documents[index];
                            return SearchJobItem(
                              documentSnapshot: data,
                              docId: data.documentID,
                              uid: data['uid'],
                              owner: data['owner'],
                              position: data['position'],
                              area: data['area'],
                              description: data['description'],
                              location: data['location'],
                              payment: data['payment'],
                              expiration: data['expiration'],
                              posted: data['posted'],
                              postedFmt: data['postedFmt'],
                            );
                          });
                }),
          ],
        ),
      ),
    );
  }
}
