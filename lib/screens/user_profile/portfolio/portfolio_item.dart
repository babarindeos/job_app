import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_app/models/portfolio.dart';
import 'package:job_app/screens/user_profile/portfolio/portfolio_details.dart';

class PortfolioItem extends StatefulWidget {
  final String id;
  final String itemId;
  final String description;
  final String owner;
  final String title;
  final String year;
  final DocumentSnapshot documentSnapshot;

  PortfolioItem(
      {@required this.id,
      @required this.itemId,
      @required this.description,
      @required this.owner,
      @required this.title,
      @required this.year,
      @required this.documentSnapshot});

  @override
  _PortfolioItemState createState() => _PortfolioItemState();
}

class _PortfolioItemState extends State<PortfolioItem> {
  Portfolio data;

  void deletePortfolio(String docId) async {
    DocumentReference docRef =
        Firestore.instance.collection('Portfolio').document(docId);
    await docRef.delete().then((value) {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0.0),
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 1.0, color: Colors.grey.shade300))),
      child: Container(
        alignment: Alignment.centerLeft,
        width: double.infinity,
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: GestureDetector(
                onTap: () async {
                  deletePortfolio(widget.id);
                },
                child: Container(
                  height: 50,
                  child: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          widget.title,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        )),
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Text(widget.year),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: FlatButton(
                  onPressed: () {
                    data = Portfolio(
                        id: widget.id,
                        itemId: widget.itemId,
                        description: widget.description,
                        owner: widget.owner,
                        title: widget.title,
                        year: widget.year,
                        documentSnapshot: widget.documentSnapshot);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                PortfolioDetails(data: data)));
                  },
                  child: Icon(Icons.chevron_right)),
            ),
          ],
        ),
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
