import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:job_app/services.dart/auth.dart';

class User {
  final String uid;
  String userType;

  User({this.uid, this.userType});

  createUserType(String uid, String userType) async {
    String result;
    try {
      DocumentReference documentReference =
          Firestore.instance.collection('UserType').document(uid);

      Map<String, dynamic> my_type = {
        "user_id": uid,
        "type": userType,
      };

      await documentReference.setData(my_type).whenComplete(() {
        result = "success";
      });
    } catch (e) {
      print(e.toString());
      result = null;
    }

    return result;
  }

  Future<String> getUserType() async {
    dynamic result;
    FirebaseAuth auth = FirebaseAuth.instance;
    dynamic uid = await auth.currentUser().then((value) => value.uid);

    print("In getUserType " + uid);
    try {
      DocumentReference documentRef =
          Firestore.instance.collection('UserType').document(uid);

      await documentRef.get().then((dataSnapshot) {
        if (dataSnapshot.exists) {
          result = (dataSnapshot.data['type']);
          print(result);
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

  Future<String> isCareerDetailsCreated() async {
    dynamic result;
    FirebaseAuth auth = FirebaseAuth.instance;
    dynamic uid = await auth.currentUser().then((value) => value.uid);

    print("In Career Details " + uid);
    try {
      DocumentReference documentRef =
          Firestore.instance.collection('CareerDetails').document(uid);

      await documentRef.get().then((dataSnapshot) {
        if (dataSnapshot.exists) {
          result = (dataSnapshot.data['field']);

          print(result);
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

  Future<bool> logout() async{
    return false;
  }
}
