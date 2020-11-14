import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_app/shared/constants.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class Messages extends StatefulWidget {
  String senderId, candidateId;
  String candidateName, senderName;
  String candidateAvatar, senderAvatar;
  Messages(
      {this.senderId,
      this.candidateId,
      this.candidateName,
      this.candidateAvatar,
      this.senderName,
      this.senderAvatar});
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  DateTime currentDate;
  String chatId;

  TextEditingController _message = TextEditingController();
  ScrollController _scrollController = new ScrollController();

//------------------------------------------------------------------------------
  Future<void> _sendMessage() async {
    if (_message.text.isNotEmpty) {
      currentDate = DateTime.now();

      // Create uuid object
      var uuid = Uuid();

      // Generate a v4
      var uid = uuid.v4();

      DocumentReference docReference =
          Firestore.instance.collection("Messages").document();

      Map<String, dynamic> msgContent = {
        "uid": uid,
        "chat_id": chatId,
        "sender": widget.senderId,
        "recipient": widget.candidateId,
        "message": _message.text,

        //"date": FieldValue.serverTimestamp()
        "date": currentDate
      };

      await docReference.setData(msgContent).then((value) {
        _message.clear();
      });
    }
  }
//------------------------------------------------------------------------------

// Generate Chat Id
  Future<void> generateChatId() async {
    int strDeterminer = widget.senderId.compareTo(widget.candidateId);
    if (strDeterminer == 1) {
      chatId = widget.senderId.toString() + '-' + widget.candidateId.toString();
    } else {
      chatId = widget.candidateId + '-' + widget.senderId.toString();
    }
    print(chatId);
  }

//------------------------------------------------------------------------------

  @override
  void initState() {
    // TODO: implement initState
    generateChatId();

    super.initState();
  }

//------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    print(widget.senderId);
    print(widget.candidateAvatar);
    print(widget.candidateName);
    print(widget.senderName);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: RichText(
            text: TextSpan(children: [
              TextSpan(
                  text: 'Messages',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                  )),
              TextSpan(text: '\n'),
              TextSpan(text: widget.candidateName),
            ]),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                controller: _scrollController,
                shrinkWrap: true,
                reverse: true,
                children: <Widget>[
                  StreamBuilder(
                      stream: Firestore.instance
                          .collection("Messages")
                          .where("chat_id", isEqualTo: chatId)
                          .orderBy("date", descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        return !snapshot.hasData
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : ListView.builder(
                                reverse: true,
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot data =
                                      snapshot.data.documents[index];
                                  return MessagesItem(
                                      documentSnapshot: data,
                                      docId: data.documentID,
                                      sender: data['sender'],
                                      recipient: data['recipient'],
                                      message: data['message'],
                                      myId: widget.senderId,
                                      myAvatar: widget.senderAvatar,
                                      recipientAvatar: widget.candidateAvatar,
                                      date: data['date']);
                                });
                      })
                ],
              ),
            ),
            SizedBox(height: 7.0),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _message,
                      decoration: profileTextInputDecoration.copyWith(
                          labelText: 'Send a message'),
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.multiline,
                      autofocus: true,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      _sendMessage();
                      _scrollController.animateTo(
                        0.0,
                        curve: Curves.easeOut,
                        //curve: Curves.fastOutSlowIn,
                        duration: const Duration(milliseconds: 300),
                      );
                    },
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

//------------------------------------------------------------------------------
class MessagesItem extends StatefulWidget {
  String docId, sender, recipient, recipientAvatar, message;
  String myId, myAvatar;
  Timestamp date;
  DocumentSnapshot documentSnapshot;
  MessagesItem(
      {this.docId,
      this.sender,
      this.recipient,
      this.recipientAvatar,
      this.message,
      this.date,
      this.documentSnapshot,
      this.myId,
      this.myAvatar});

  @override
  _MessagesItemState createState() => _MessagesItemState();
}

class _MessagesItemState extends State<MessagesItem> {
  bool isMe = false;
  String selectedSenderAvatar = '';
  @override
  Widget build(BuildContext context) {
    if (widget.sender == widget.myId) {
      isMe = true;
      selectedSenderAvatar = widget.myAvatar;
      print(isMe);
    } else {
      isMe = false;
      selectedSenderAvatar = widget.recipientAvatar;
    }

    print("************** Selected Avatar : " +
        widget.sender +
        " -  " +
        selectedSenderAvatar);

    DateTime msgDateTime = widget.date.toDate();

    return Container(
      padding: const EdgeInsets.only(left: 3.0, right: 3.0),
      child: Column(
        children: <Widget>[
          isMe
              ? Container(
                  margin: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 50.0),
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.pink.withOpacity(0.1),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15.0),
                      bottomLeft: Radius.circular(15.0),
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 26.0,
                        backgroundColor: Colors.pink.withOpacity(0.1),
                        child: CircleAvatar(
                          radius: 25.0,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: (widget.myAvatar == '' ||
                                      widget.myAvatar == null)
                                  ? Image(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'images/profile_avatar.jpg'),
                                    )
                                  : Image.network(
                                      widget.myAvatar,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 7.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              DateFormat.yMMMd().add_jm().format(msgDateTime),
                              style: TextStyle(
                                fontSize: 11.0,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(widget.message)),
                        ],
                      ),
                    ],
                  ),
                )
              : Container(
                  margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 50.0),
                  padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15.0),
                      bottomRight: Radius.circular(15.0),
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleAvatar(
                        radius: 26.0,
                        backgroundColor: Colors.green,
                        child: CircleAvatar(
                          radius: 25.0,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: (widget.recipientAvatar == '' ||
                                      widget.recipientAvatar == null)
                                  ? Image(
                                      fit: BoxFit.cover,
                                      image: AssetImage(
                                          'images/profile_avatar.jpg'))
                                  : Image.network(
                                      widget.recipientAvatar,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 7.0,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(
                              DateFormat.yMMMd().add_jm().format(msgDateTime),
                              style: TextStyle(
                                fontSize: 11.0,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(widget.message)),
                        ],
                      ),
                    ],
                  ),
                )
        ],
      ),
    );
  }
}
