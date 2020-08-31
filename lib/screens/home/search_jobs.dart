import 'package:flutter/material.dart';
import 'package:job_app/shared/constants.dart';

class SearchJobs extends StatefulWidget {
  @override
  _SearchJobsState createState() => _SearchJobsState();
}

class _SearchJobsState extends State<SearchJobs> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
          padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(vertical: 7.0, horizontal: 5.0),
              alignment: Alignment.center,
              child: Text(
                "Search Jobs",
                style: TextStyle(
                    fontFamily: 'Pacifico-Regular',
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: TextFormField(
                decoration: searchTextInputDecoration.copyWith(
                    labelText: 'Search Jobs', prefixIcon: Icon(Icons.search)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
