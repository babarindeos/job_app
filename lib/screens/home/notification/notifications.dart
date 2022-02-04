import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:job_app/models/user.dart';
import 'package:provider/provider.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  String currentUserId;
  bool isLoading = true;

  //----------------------------------------------------------------------------
  Future<void> getCurrentUserId() async {
    final FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    setState(() {
      currentUserId = _user.uid;
      isLoading = false;
    });

    //print(currentUserId);
  }

  //----------------------------------------------------------------------------

  @override
  void initState() {
    // TODO: implement initState
    getCurrentUserId();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //final user = Provider.of<User>(context);

    //currentUserId = user.uid;
    //print(currentUserId);
    return isLoading
        ? CircularProgressIndicator()
        : Scaffold(
            body: Container(
            padding: const EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 10.0),
            child: ListView(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 5.0),
                  alignment: Alignment.center,
                  child: Text(
                    "Alerts",
                    style: TextStyle(
                        fontFamily: 'Pacifico-Regular',
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 10.0),
                StreamBuilder(
                    stream: Firestore.instance
                        .collection("ActivityFeeds")
                        .where("recipient", isEqualTo: currentUserId)
                        .orderBy("date", descending: true)
                        .snapshots(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                                return NotificationItem(
                                    documentSnapshot: data,
                                    docID: data.documentID,
                                    date: data['date'],
                                    owner: data['owner'],
                                    recipient: data['recipient'],
                                    type: data['type'],
                                    jobDocId: data['job_docid'],
                                    uid: data['uid']);
                              });
                    }),
              ],
            ),
          ));
  }
}

//------------------------------------------------------------------------------
// ----------- NotificationItem

class NotificationItem extends StatefulWidget {
  DocumentSnapshot documentSnapshot;
  String docID, owner, recipient, type, uid, jobDocId;
  Timestamp date;
  NotificationItem(
      {this.documentSnapshot,
      this.docID,
      this.date,
      this.owner,
      this.recipient,
      this.type,
      this.jobDocId,
      this.uid});
  @override
  _NotificationItemState createState() => _NotificationItemState();
}

class _NotificationItemState extends State<NotificationItem> {
  String senderAvatar = '';
  String senderName = '';
  String message = '';
  String activityFeedType = '';
  String companyName = '';
  String jobTitle = '';

  //----------------------------------------------------------------------------
  Future<void> getSenderData() async {
    DocumentReference docRef =
        Firestore.instance.collection("BioData").document(widget.owner);
    await docRef.get().then((dataSnapshot) {
      if (mounted) {
        setState(() {
          senderName = dataSnapshot['name'];
          senderAvatar = dataSnapshot['avatar'];
        });
      }

      formatFeedData();
    });
  }

  //----------------------------------------------------------------------------
  //------------  Get Company Data ---------------------------------------------
  Future<void> getCompanyData() async {
    DocumentReference docRef =
        Firestore.instance.collection("Company").document(widget.owner);
    await docRef.get().then((dataSnapshot) {
      if (mounted) {
        setState(() {
          companyName = dataSnapshot['name'];
        });
      }
    });
  }

  //------------  End of Company Data ------------------------------------------
  //------------- Get Job Title ------------------------------------------------
  Future<void> getJobTitle() async {
    DocumentReference docRef =
        Firestore.instance.collection("Job_Postings").document(widget.jobDocId);
    await docRef.get().then((dataSnapshot) {
      if (dataSnapshot.exists) {
        if (mounted) {
          setState(() {
            jobTitle = dataSnapshot['position'];
          });
        }
      }
    });
  }

  //----------------------------------------------------------------------------

  //------------ FormatFeedData ------------------------------------------------
  Future<void> formatFeedData() async {
    activityFeedType = widget.type;
    switch (activityFeedType) {
      case 'friend_request':
        if (mounted) {
          setState(() {
            message = "${senderName} sent you a friend request";
          });
        }
        break;
      case 'friend_request_accepted':
        if (mounted) {
          setState(() {
            message = '${senderName} accepted your friend request';
          });
        }
        break;
      case 'job_shortlisting':
        if (mounted) {
          setState(() {
            message =
                '${companyName} shortlisted you for the job of ${jobTitle}';
          });
        }
    }
  }
//-------------------- End of FormatFeedData -----------------------------------
//------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    getSenderData();
    if (widget.type == 'job_shortlisting') {
      getCompanyData();
      getJobTitle();
      //print("Job DOC: " + widget.jobDocId);
    }

    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: ClipOval(
            child: SizedBox(
              width: 100,
              height: 180,
              child: senderAvatar == null || senderAvatar == ''
                  ? Image(
                      fit: BoxFit.cover,
                      image: AssetImage('images/profile_avatar.jpg'),
                    )
                  : Image.network(
                      senderAvatar,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
        title: Text(
          message,
          style: TextStyle(
            fontSize: 13.0,
          ),
        ),
        subtitle: Container(
          padding: const EdgeInsets.only(top: 5.0),
          child: Text(
            DateFormat.yMMMd().add_jm().format(widget.date.toDate()).toString(),
            style: TextStyle(
              fontSize: 11.0,
            ),
          ),
        ),
      ),
    );
  }
}
