import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:job_app/screens/recruiter/message/messages.dart';

class MessageListing extends StatefulWidget {
  @override
  _MessageListingState createState() => _MessageListingState();
}

class _MessageListingState extends State<MessageListing> {
  List chatList = [];
  List chatListDocumentId = [];
  List chatListUid = [];
  String docChatId = '';
  String chatUid = '';
  String recipient = '';
  String currentUserId;
  DocumentReference docRef;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    _getCurrentUser();
    _buildQueryStream();
    super.initState();
  }

//------------------------------------------------------------------------------

  Future<void> _getCurrentUser() async {
    final FirebaseUser _user = await FirebaseAuth.instance.currentUser();
    currentUserId = _user.uid;
  }

//------------------------------------------------------------------------------
  _buildQueryStream() async {
    Query streamQuery = Firestore.instance
        .collection("Messages")
        .orderBy("date", descending: true);
    await streamQuery.getDocuments().then((querySnapshot) {
      querySnapshot.documents.forEach((element) async {
        if (element.exists) {
          //print(element.documentID);
          // get the document chatId
          docChatId = element.data['chat_id'];
          chatUid = element.data['uid'];
          recipient = element.data['recipient'];
          if (docChatId != null && chatUid != null) {
            print(docChatId);
            print('My Id: ' + currentUserId);
            print('Recipient: ' + recipient);

            // check if recipient is the same as currentUserId
            if (recipient == currentUserId) {
              //check if document has been added to list
              if (chatList.contains(docChatId)) {
                print('Is already in list');
              } else {
                setState(() {
                  chatList.add(docChatId);
                  chatListDocumentId.add(element.documentID);
                  chatListUid.add(chatUid);
                });

                print('Added to the lists');
              }
              //end of check if document is in list
            }
            //end of check for currentUserId
            print(
                '------------------------------------------------------------------');
          }
        }
      });
    });
    print(chatList);
    print(chatListDocumentId);
    print("List Length *************** " + chatList.length.toString());
    setState(() {
      isLoading = false;
    });
  }

//------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Messages'),
          centerTitle: true,
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                padding: const EdgeInsets.only(top: 10.0, bottom: 8.0),
                children: <Widget>[
                    chatList.length > 0
                        ? StreamBuilder(
                            stream: Firestore.instance
                                .collection("Messages")
                                .where("uid", whereIn: chatListUid)
                                .orderBy("date", descending: true)
                                .snapshots(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
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
                                        return MessageListingItem(
                                          documentSnapshot: data,
                                          docId: data.documentID,
                                          chatId: data['chat_id'],
                                          candidateId: data['sender'],
                                          message: data['message'],
                                          date: data['date'],
                                          myUserId: currentUserId,
                                        );
                                      });
                            })
                        : Center(
                            child: Text(''),
                          ),
                  ]),
      ),
    );
  }
}

//------------------------------------------------------------------------------
class MessageListingItem extends StatefulWidget {
  String docId, chatId, candidateId, message, myUserId;
  Timestamp date;

  DocumentSnapshot documentSnapshot;
  MessageListingItem(
      {this.docId,
      this.documentSnapshot,
      this.chatId,
      this.candidateId,
      this.message,
      this.date,
      this.myUserId});
  @override
  _MessageListingItemState createState() => _MessageListingItemState();
}

class _MessageListingItemState extends State<MessageListingItem> {
  String candidateAvatar = '';
  String candidateName = '';
  String myUserId = '';
  String myName = '';
  String myAvatar = '';

  //----------------------------------------------------------------------------
// _candidateinfo
  Future<void> _getCandidateInfo(String candidateId) async {
    try {
      DocumentReference docRef =
          Firestore.instance.collection("BioData").document(candidateId);
      await docRef.get().then((dataSnapshot) {
        if (mounted) {
          setState(() {
            candidateAvatar = dataSnapshot['avatar'];
            candidateName = dataSnapshot['name'];
          });
        }
      });
    } catch (e) {}
  }

//------------------------------------------------------------------------------
  Future<void> _getMyInfo(String myUserId) async {
    try {
      DocumentReference docRef =
          Firestore.instance.collection("BioData").document(myUserId);
      await docRef.get().then((dataSnapshot) {
        setState(() {
          myAvatar = dataSnapshot['avatar'];
          myName = dataSnapshot['name'];
        });
      });
    } catch (e) {}
  }

//------------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    // call _getSenderInfo
    _getCandidateInfo(widget.candidateId);
    _getMyInfo(widget.myUserId);

    return Container(
      padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          width: 1.0,
          color: Colors.grey.shade300,
        ),
      )),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: ClipOval(
            child: SizedBox(
              width: 100,
              height: 180,
              child: candidateAvatar == null
                  ? Image(
                      fit: BoxFit.cover,
                      image: AssetImage('images/profile_avatar.jpg'),
                    )
                  : Image.network(
                      candidateAvatar,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
        title: candidateName.isNotEmpty
            ? Text(
                candidateName,
                style: TextStyle(
                    fontFamily: 'SourceSansPro', fontWeight: FontWeight.bold),
              )
            : LinearProgressIndicator(),
        subtitle: Padding(
            padding: const EdgeInsets.only(top: 3.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  DateFormat.yMMMd()
                      .add_jm()
                      .format(widget.date.toDate())
                      .toString(),
                  style: TextStyle(
                    fontSize: 11.0,
                  ),
                ),
                SizedBox(
                  height: 4.0,
                ),
                Text(
                  widget.message,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )),
        trailing: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Messages(
                    senderId: widget.myUserId,
                    candidateId: widget.candidateId,
                    candidateName: candidateName,
                    candidateAvatar: candidateAvatar,
                    senderName: myName,
                    senderAvatar: myAvatar),
              ),
            );
          },
          child: Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}
