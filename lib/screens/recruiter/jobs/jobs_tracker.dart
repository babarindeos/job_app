import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_app/models/user.dart';
import 'package:job_app/screens/recruiter/jobs/job_posted_item.dart';
import 'package:job_app/screens/recruiter/jobs/post_job.dart';
import 'package:provider/provider.dart';

class JobTracker extends StatefulWidget {
  @override
  _JobTrackerState createState() => _JobTrackerState();
}

class _JobTrackerState extends State<JobTracker> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    String user_uid = (user.uid.toString());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Job Tracker'),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 20, left: 20),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JobPost()),
                  );
                },
                child: Icon(Icons.add),
              ),
            ),
          ],
        ),
        body: StreamBuilder(
            stream: Firestore.instance
                .collection("Job_Postings")
                .where("owner", isEqualTo: user_uid)
                .snapshots(),
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
                        DocumentSnapshot data = snapshot.data.documents[index];
                        return JobPostedItem(
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
      ),
    );
  }
}
