import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompanyInformation extends StatefulWidget {
  String companyId;
  CompanyInformation({this.companyId});
  @override
  _CompanyInformationState createState() => _CompanyInformationState();
}

class _CompanyInformationState extends State<CompanyInformation> {
  bool isLoaded = false;

  String aboutCompany = '';
  String address = '';
  String email = '';
  String companyName = '';
  String phone = '';
  String sector = '';

  @override

  //----------------------------------------------------------------------------
  void initState() {
    // TODO: implement initState
    _retrieveCompanyInformation();
    super.initState();
  }

  //----------------------------------------------------------------------------
  Future<void> _retrieveCompanyInformation() async {
    DocumentReference docReference =
        Firestore.instance.collection("Company").document(widget.companyId);

    await docReference.get().then((dataSnapshot) {
      if (dataSnapshot.exists) {
        setState(() {
          companyName = (dataSnapshot.data['name']);
          sector = (dataSnapshot.data['sector']);
          address = (dataSnapshot.data['address']);
          email = (dataSnapshot.data['email']);
          phone = (dataSnapshot.data['phone']);
          aboutCompany = (dataSnapshot.data['about']);
        });
      }
    });

    setState(() {
      isLoaded = true;
    });
  }

  //-----------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Company Information'),
        ),
        body: !isLoaded
            ? Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 12.0),
                children: <Widget>[
                  Container(
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          flex: 2,
                          child: Container(
                            child: Image.asset(
                              'images/company_logo.jpg',
                              width: 20.0,
                              fit: BoxFit.fitWidth,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 3.0),
                            child: Text(
                              companyName,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                fontFamily: 'SourceSansPro',
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Text(
                    "Sector",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5.0),
                  Text(sector),
                  SizedBox(height: 20.0),
                  Text(
                    "Location",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    address,
                  ),
                  SizedBox(height: 20.0),
                  Text(
                    'Email',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5.0),
                  Text(email),
                  SizedBox(height: 20.0),
                  Text(
                    'Phone No.',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5.0),
                  Text(phone),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "About Company",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(aboutCompany),
                ],
              ),
      ),
    );
  }
}
