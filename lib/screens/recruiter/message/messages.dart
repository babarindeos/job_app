import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_app/shared/constants.dart';

class Messages extends StatefulWidget {
  String companyId, candidateId;
  Messages({this.companyId, this.candidateId});
  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  DateTime currentDate;

  TextEditingController _message = TextEditingController();

//------------------------------------------------------------------------------
  Future<void> _sendMessage() async {
    if (_message.text.isNotEmpty) {
      currentDate = DateTime.now();
      DocumentReference docReference =
          Firestore.instance.collection("Messages").document();

      Map<String, dynamic> msgContent = {
        "sender": widget.companyId,
        "recipient": widget.candidateId,
        "message": _message.text,
        "date": currentDate
      };

      await docReference.setData(msgContent).then((value) {
        _message.clear();
      });
    }
  }
//------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    print(widget.companyId);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Messages'),
          centerTitle: true,
        ),
        body: Column(
          children: <Widget>[
            Expanded(
              child: Column(
                children: <Widget>[],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
