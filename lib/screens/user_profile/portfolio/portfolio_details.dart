import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_app/models/portfolio.dart';
import 'package:job_app/screens/user_profile/portfolio/portfolio_edit.dart';

class PortfolioDetails extends StatefulWidget {
  final Portfolio data;
  final String pageState;
  PortfolioDetails({this.data, this.pageState});
  @override
  _PortfolioDetailsState createState() => _PortfolioDetailsState();
}

class _PortfolioDetailsState extends State<PortfolioDetails> {
  bool isloading = false;

  @override
  final _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(children: <Widget>[
          isloading ? LinearProgressIndicator() : Container(),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.fromLTRB(5.0, 0.0, 13.0, 0.0),
            child: Stack(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        widget.pageState.isEmpty
                            ? Container(
                                margin: EdgeInsets.symmetric(
                                    vertical: 5.0, horizontal: 8.0),
                                child: Image(
                                  image: AssetImage('images/step-3-mini.png'),
                                  width: 150.0,
                                ),
                              )
                            : Container(
                                padding: const EdgeInsets.only(
                                  top: 25.0,
                                ),
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
                                    'Portfolios Details',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'SourceSansPro'),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => PortfolioEdit(
                                              data: widget.data,
                                              pageState: widget.pageState),
                                        ));
                                  },
                                  child: Container(
                                    child: Icon(Icons.edit, color: Colors.blue),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.fromLTRB(
                                      10.0, 0.0, 10.0, 5.0),
                                  child: Text(
                                    'Year',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: const EdgeInsets.fromLTRB(
                                      10.0, 0.0, 10.0, 5.0),
                                  child: Text(
                                    widget.data.year,
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 2.0,
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 1.0, 5.0, 5.0),
                              child: Text(
                                widget.data.title,
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Container(
                              padding: const EdgeInsets.fromLTRB(
                                  10.0, 1.0, 5.0, 5.0),
                              child: Text(widget.data.description),
                            )
                          ],
                        )
                      ]),
                ),
              ],
            ),
          )
        ]),
      ),
    );
  }
}

class Data {
  String id, itemId, description, owner, title, year;
  DocumentSnapshot documentSnapshot;

  Data(
      {this.id,
      this.itemId,
      this.description,
      this.owner,
      this.title,
      this.year,
      this.documentSnapshot});
}
