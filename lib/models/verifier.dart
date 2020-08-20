import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Verifier {
  // Check if user is new, to take the new user path
  String isNewUser(String uid) {
    String result = '';
    try {
      DocumentReference documentReference =
          Firestore.instance.collection('UserType').document(uid);

      documentReference.get().then((datasnapshot) {
        if (datasnapshot.exists) {
          result = (datasnapshot.data['type']);
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
}
