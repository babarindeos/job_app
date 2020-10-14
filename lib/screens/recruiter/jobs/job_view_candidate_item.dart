import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_app/screens/recruiter/jobs/ApplicantsInformation.dart';

class JobViewCandidateItem extends StatefulWidget {
  final String userId, docId, jobId, dateApplied;
  final DocumentSnapshot documentSnapshot;

  JobViewCandidateItem(
      {@required this.userId,
      @required this.docId,
      @required this.jobId,
      @required this.documentSnapshot,
      @required this.dateApplied});

  @override
  _JobViewCandidateItemState createState() => _JobViewCandidateItemState();
}

class _JobViewCandidateItemState extends State<JobViewCandidateItem> {
  Future _getBioData(String userId) async {
    return Firestore.instance
        .collection("BioData")
        .document(userId)
        .get()
        .then((value) => value['name']);
  }
  //-----------------------------------------------------------------------------

  Future _getUserAvatar(String userId) async {
    return Firestore.instance
        .collection("BioData")
        .document(userId)
        .get()
        .then((value) => value['avatar']);
  }

  //-----------------------------------------------------------------------------
  Future _getProfession(String userId) async {
    return Firestore.instance
        .collection("CareerDetails")
        .document(userId)
        .get()
        .then((value) => value['field']);
  }

  //----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    //print(widget.userId);
    return Container(
        padding: const EdgeInsets.fromLTRB(8.0, 3.0, 5.0, 4.0),
        child: Row(
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
                    child: FutureBuilder(
                      future: _getUserAvatar(widget.userId),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        return Image.network(snapshot.data.toString(),
                            fit: BoxFit.cover);
                      },
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 4.0,
            ),
            Expanded(
              flex: 2,
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: FutureBuilder(
                      future: _getBioData(widget.userId),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data.toString());
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    child: FutureBuilder(
                      future: _getProfession(widget.userId),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return Text(snapshot.data.toString());
                        } else {
                          return Center(
                            child: Text(''),
                          );
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ApplicantsInformation(
                        userId: widget.userId,
                        jobId: widget.jobId,
                        docId: widget.docId,
                        documentSnapshot: widget.documentSnapshot,
                        dateApplied: widget.dateApplied),
                  ),
                );
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5.0, horizontal: 7.0),
                child: Icon(Icons.chevron_right),
              ),
            ),
          ],
        ));
  }
}
