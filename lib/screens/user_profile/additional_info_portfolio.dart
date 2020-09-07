import 'package:flutter/material.dart';
import 'package:job_app/screens/user_profile/additional_info_portfolio_add.dart';
import 'package:job_app/shared/constants.dart';

class AdditionalInfoPortfolio extends StatefulWidget {
  AdditionalInfoPortfolio({Key key}) : super(key: key);
  @override
  _AdditionalInfoPortfolioState createState() =>
      _AdditionalInfoPortfolioState();
}

class _AdditionalInfoPortfolioState extends State<AdditionalInfoPortfolio> {
  bool isloading = false;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Builder(
          builder: (BuildContext context) {
            return ListView(children: <Widget>[
              isloading ? LinearProgressIndicator() : Container(),
              Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 1.0, horizontal: 20.0),
                child: Stack(children: <Widget>[
                  Form(
                    key: _formKey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 10.0),
                            child: Image(
                              image: AssetImage('images/step-3-mini.png'),
                              width: 150.0,
                            ),
                          ),
                          Text(
                            'Additional Information',
                            style: TextStyle(
                                fontSize: 28.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SourceSansPro'),
                          ),
                          Text(
                            'Portfolios',
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'SourceSansPro'),
                          ),
                          SizedBox(height: 10.0),
                          SizedBox(height: 20.0),
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
                    builder: (context) => AdditionalInfoPortfolioAdd()));
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
