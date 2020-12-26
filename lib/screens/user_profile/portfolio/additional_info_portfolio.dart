import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_app/models/user.dart';
import 'package:job_app/screens/user_profile/portfolio/additional_info_portfolio_add.dart';
import 'package:job_app/screens/user_profile/portfolio/portfolio_item.dart';
import 'package:job_app/shared/constants.dart';
import 'package:provider/provider.dart';

class AdditionalInfoPortfolio extends StatefulWidget {
  String pageState;
  AdditionalInfoPortfolio({Key key, this.pageState}) : super(key: key);
  @override
  _AdditionalInfoPortfolioState createState() =>
      _AdditionalInfoPortfolioState();
}

class _AdditionalInfoPortfolioState extends State<AdditionalInfoPortfolio> {
  bool isloading = false;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<User>(context);

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
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
                                      'Portfolios',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'SourceSansPro'),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Text(""),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: 1.0),
                          StreamBuilder(
                            stream: Firestore.instance
                                .collection("Portfolio")
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
                                        return PortfolioItem(
                                          documentSnapshot: data,
                                          id: data.documentID,
                                          itemId: data['Id'],
                                          description: data['description'],
                                          owner: data['owner'],
                                          title: data['title'],
                                          year: data['year'],
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
                builder: (context) =>
                    AdditionalInfoPortfolioAdd(pageState: widget.pageState),
              ),
            );
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
