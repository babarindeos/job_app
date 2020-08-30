import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Verifier {
  // Check if user is new, to take the new user path
  String iUserType;

  Verifier({this.iUserType});
//------------------------------------------------------------------------------------------
  isUserTypeSelected(String uid) {
    String result;

    try {
      DocumentReference documentReference =
          Firestore.instance.collection('UserType').document(uid);

      documentReference.get().then((dataSnapshot) {
        if (dataSnapshot.exists) {
          result = (dataSnapshot.data['type']);
          print("In isUserTypeSelected Method - UserType has been Selected");
          return result;
        } else {
          print(
              "In isUserTypeSelected Method - UserType has not been Selected");
          return null;
        }
      });
    } catch (e) {
      print("In isUserTypeSelected - Error caught..." + e.toString());
      return null;
    }
  }

//----------------------------------------------------------------------------------------------------
  // Check if user bio-data has been filled
  isBioDataCreated(String uid) {
    String result;
    try {
      DocumentReference documentReference =
          Firestore.instance.collection('BioData').document(uid);

      documentReference.get().then((dataSnapshot) {
        if (dataSnapshot.exists) {
          result = (dataSnapshot.data['name']);
          print("In BioData - User has filled in Bio Data");
          return result;
        } else {
          print("In Bio Data - User has not filled in his/her Bio-data");
          return null;
        }
      });
    } catch (e) {
      print("In Biodata " + e.toString());
      return null;
    }
    return null;
  } // end of method isBioDataFilled

//-----------------------------------------------------------------------------------------------
  // Check if CareerDetails has been filled in
  isCareerDetailsCreated(String uid) {
    String result;
    try {
      DocumentReference documentReference =
          Firestore.instance.collection('CareerDetails').document(uid);

      documentReference.get().then((dataSnapshot) {
        if (dataSnapshot.exists) {
          result = (dataSnapshot.data['field']);
          print('In Career Details - Details has been filled in -- ' + result);
          return result;
        } else {
          print('In Career Details - Details has not been filled in');
          return null;
        }
      });
    } catch (e) {
      print("In Career Details " + e.toString());
      return null;
    }
  }

//-------------------------------------------------------------------------------------------------
} // end of class
