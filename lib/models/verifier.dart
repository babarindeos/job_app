import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Verifier {
  // Check if user is new, to take the new user path
  String isNewUser(String uid) {
    String result = '';
    try {
      DocumentReference documentReference =
          Firestore.instance.collection('UserType').document(uid);

      documentReference.get().then((dataSnapshot) {

        if (dataSnapshot.exists) {
             result = (dataSnapshot.data['type']);
             print(result);
        } else {
             result = null;
        }
      });
    } catch (e) {
      print(e.toString());
      result = null;
    }
    return result;
  }

   // Check if user bio-data has been filled
  String isBioDataCreated(String uid){
    String result;
    try{
        DocumentReference documentReference = Firestore.instance.collection('BioData').document(uid);

        documentReference.get().then((dataSnapshot){
                if (dataSnapshot.exists){
                   result = (dataSnapshot.data['name']);

                }else{
                   result = null;
                }
        });

    }catch(e){
        print(e.toString());
        result = null;
    }

    return result;

  } // end of method isBioDataFilled


  // Check if CareerDetails has been filled in
  bool isCareerDetailsCreated(String uid){
    bool result;
    try{

      DocumentReference documentReference = Firestore.instance.collection('CareerDetails').document(uid);

      documentReference.get().then((dataSnapshot){
        if (dataSnapshot.exists){
          result = true;
        }else{
          result = false;
        }
      });

    }catch(e){
        print(e.toString());
        result = false;
    }
    return result;

  }





}
