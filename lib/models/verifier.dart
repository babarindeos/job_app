import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Verifier {
  // Check if user is new, to take the new user path
  String iUserType;
  String iBioData;
  String iCareerDetails;
  String iCompany;

  Verifier({this.iUserType, this.iBioData, this.iCareerDetails, this.iCompany});
//------------------------------------------------------------------------------------------
  Future<String> isUserTypeSelected(String uid) async {
    String result;

    try {
      DocumentReference documentReference =
          Firestore.instance.collection('UserType').document(uid);

      await documentReference.get().then((dataSnapshot) {
        if (dataSnapshot.exists) {
          result = (dataSnapshot.data['type']);
          iUserType = result;

          print("In isUserTypeSelected Method - UserType has been Selected - " +
              result);
          return result;
        } else {
          print(
              "In isUserTypeSelected Method - UserType has not been Selected");
          iUserType = null;
          return null;
        }
      });
    } catch (e) {
      print("In isUserTypeSelected - Error caught..." + e.toString());
      iUserType = null;
      return null;
    }
  }

//----------------------------------------------------------------------------------------------------
  // Check if user bio-data has been filled
  Future<String> isBioDataCreated(String uid) async {
    String result;
    try {
      DocumentReference documentReference =
          Firestore.instance.collection('BioData').document(uid);

      await documentReference.get().then((dataSnapshot) {
        if (dataSnapshot.exists) {
          result = (dataSnapshot.data['name']);
          iBioData = result;
          print("In BioData - User has filled in Bio Data");
          return result;
        } else {
          print("In Bio Data - User has not filled in his/her Bio-data");
          iBioData = null;
          return null;
        }
      });
    } catch (e) {
      print("In Biodata " + e.toString());
      iBioData = null;
      return null;
    }
  } // end of method isBioDataFilled

//-----------------------------------------------------------------------------------------------
  // Check if CareerDetails has been filled in
  Future<String> isCareerDetailsCreated(String uid) async {
    String result;
    try {
      DocumentReference documentReference =
          Firestore.instance.collection('CareerDetails').document(uid);

      await documentReference.get().then((dataSnapshot) {
        if (dataSnapshot.exists) {
          result = (dataSnapshot.data['field']);
          iCareerDetails = result;
          print('In Career Details - Details has been filled in -- ' + result);
          return result;
        } else {
          print('In Career Details - Details has not been filled in');
          iCareerDetails = null;
          return null;
        }
      });
    } catch (e) {
      print("In Career Details " + e.toString());
      iCareerDetails = null;
      return null;
    }
  }

//-------------------------------------------------------------------------------------------------
// Check if Company has been filled in
  Future<String> isCompanyCreated(String uid) async {
    String result;
    try {
      DocumentReference documentReference =
          Firestore.instance.collection('Company').document(uid);
      await documentReference.get().then((dataSnapshot) {
        if (dataSnapshot.exists) {
          result = (dataSnapshot.data['name']);
          iCompany = result;
          return result;
        } else {
          iCompany = null;
          return null;
        }
      });
    } catch (e) {
      print("Company name " + e.toString());
      iCompany = null;
      return null;
    }
  }

//--------------------------------------------------------------------------------------------------

} // end of class
