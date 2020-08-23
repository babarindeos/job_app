import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Verifier {
  // Check if user is new, to take the new user path
  isNewUser(String uid) {
    String result;

    try {
      DocumentReference documentReference =
          Firestore.instance.collection('UserType').document(uid);

      documentReference.get().then((dataSnapshot) {
        if (dataSnapshot.exists) {
          result = (dataSnapshot.data['type']);
          return result;
        } else {
          return null;
        }
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // Check if user bio-data has been filled
  String isBioDataCreated(String uid) {
    String result;
    try {
      DocumentReference documentReference =
          Firestore.instance.collection('BioData').document(uid);

      documentReference.get().then((dataSnapshot) {
        if (dataSnapshot.exists) {
          result = (dataSnapshot.data['name']);
          return result;
        } else {
          return null;
        }
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  } // end of method isBioDataFilled

  // Check if CareerDetails has been filled in
  String isCareerDetailsCreated(String uid) {
    String result;
    try {
      DocumentReference documentReference =
          Firestore.instance.collection('CareerDetails').document(uid);

      documentReference.get().then((dataSnapshot) {
        if (dataSnapshot.exists) {
          result = (dataSnapshot.data['field']);
          print('Result ' + result);
          return result;
        } else {
          print('Result not found');
          return null;
        }
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
} // end of class
