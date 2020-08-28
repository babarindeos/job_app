import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Career {
  String _field;
  String _experience;
  String _bio;
  String _facebook;
  String _instagram;
  String _linkedIn;
  String _snapchat;

  Career(
      {String field,
      String experience,
      String bio,
      String facebook,
      String instagram,
      String linkedIn,
      String snapchat})
      : _field = field,
        _experience = experience,
        _bio = bio,
        _facebook = facebook,
        _instagram = instagram,
        _linkedIn = linkedIn,
        _snapchat = snapchat;

  set uField(String value) {
    this._field = value;
  }

  String get uField {
    return this._field;
  }

  set uExperience(String value) {
    this._experience = value;
  }

  String get uExperience {
    return this._experience;
  }

  set uBio(String value) {
    this._bio = value;
  }

  String get uBio {
    return this._bio;
  }

  set uFacebook(String value) {
    this._facebook = value;
  }

  String get uFacebook {
    return this._facebook;
  }

  set uInstagram(String value) {
    this._instagram = value;
  }

  String get uInstagram {
    return this._instagram;
  }

  set uLinkedIn(String value) {
    this._linkedIn = value;
  }

  String get uLinkedIn {
    return this._linkedIn;
  }

  set uSnapchat(String value) {
    this._snapchat = value;
  }

  String get uSnapchat {
    return this._snapchat;
  }

// ------------------------------------------------------------------------------------------
  Future<String> updateCareerDetails(String uid) async {
    try {
      DocumentReference documentReference =
          Firestore.instance.collection("CareerDetails").document(uid);

      Map<String, dynamic> career = {
        "field": this.uField,
        "experience": this.uExperience,
        "bio": this.uBio
      };
      documentReference
          .setData(career)
          .whenComplete(() => "Career Details has been Updated.");
    } catch (e) {
      print(e.toString());
      return null;
    }
  } // end of update

//----------------------------------------------------------------------------------------

  // Update Social Media
  Future<String> updateSocialMedia(String uid) async {
    try {
      DocumentReference documentReference =
          Firestore.instance.collection("SocialMedia").document(uid);

      Map<String, dynamic> socialMedia = {
        "facebook": this.uFacebook,
        "instagram": this.uInstagram,
        "linkedin": this.uLinkedIn,
        "snapchat": this.uSnapchat
      };

      await documentReference.updateData(socialMedia).whenComplete(() {
        return "success";
      });
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  // end of social media update

//----------------------------------------------------------------------------------------------

//Retrieve User Social Media Accounts
  Future<String> getUserSocialMedia() async {
    dynamic result;
    FirebaseAuth auth = FirebaseAuth.instance;
    dynamic uid = await auth.currentUser().then((value) => value.uid);

    DocumentReference documentReference =
        Firestore.instance.collection('SocialMedia').document(uid);
    await documentReference.get().then((dataSnapshot) {
      if (dataSnapshot.exists) {
        this.uFacebook = dataSnapshot.data['facebook'];
        this.uInstagram = dataSnapshot.data['instagram'];
        this.uLinkedIn = dataSnapshot.data['linkedin'];
        this._snapchat = dataSnapshot.data['snapchat'];
        print(this.uFacebook);

        return 'success';
      } else {
        return null;
      }
    });
  }

// ----------------------------------------------------------------------------------------------
}
