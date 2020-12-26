import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_app/models/user.dart';
import 'package:provider/provider.dart';

import 'education_add.dart';
import 'education_item.dart';

class Education extends StatefulWidget {
  final String pageState;
  Education({Key key, this.pageState}) : super(key: key);
  @override
  _EducationState createState() => _EducationState();
}

class _EducationState extends State<Education> {
  bool isloading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<User>(context);
    return SafeArea(
      child: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            return ListView(children: <Widget>[
              isloading ? LinearProgressIndicator() : Container(),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 13.0, 0.0),
                child: Stack(children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          widget.pageState.isEmpty
                              ? Container(
                                  margin: EdgeInsets.symmetric(
                                      vertical: 5.0, horizontal: 10.0),
                                  child: Image(
                                    image: AssetImage('images/step-3-mini.png'),
                                    width: 150.0,
                                  ),
                                )
                              : Container(
                                  padding: const EdgeInsets.only(top: 20.0),
                                ),
                          Text(
                            'Additional Information',
                            style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SourceSansPro'),
                          ),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Expanded(
                                  flex: 1,
                                  child: Container(
                                    alignment: Alignment.centerLeft,
                                    child: FlatButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      child: Icon(
                                        Icons.arrow_back,
                                        size: 30.0,
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Education',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'SourceSansPro'),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Container(),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 1.0),
                          StreamBuilder(
                            stream: Firestore.instance
                                .collection("Education")
                                .where("owner",
                                    isEqualTo: currentUser.uid.toString())
                                .snapshots(),
                            builder: (context, snapshot) {
                              return !snapshot.hasData
                                  ? Center(child: CircularProgressIndicator())
                                  : ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.vertical,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      itemCount: snapshot.data.documents.length,
                                      itemBuilder: (context, index) {
                                        DocumentSnapshot data =
                                            snapshot.data.documents[index];
                                        return EducationItem(
                                          documentSnapshot: data,
                                          docId: data.documentID,
                                          uuid: data['id'],
                                          owner: data['owner'],
                                          dateStarted: data['date_started'],
                                          dateEnded: data['date_ended'],
                                          institution: data['institution'],
                                          courseOfStudy:
                                              data['course_of_study'],
                                          level: data['level'],
                                          classOfDegree:
                                              data['class_of_degree'],
                                          pageState: widget.pageState,
                                        );
                                      });
                            },
                          ),
                          SizedBox(
                            height: 15.0,
                          ),
                        ]),
                  ),
                ]),
              ),
            ]);
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EducationAdd(pageState: widget.pageState),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
