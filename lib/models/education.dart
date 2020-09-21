import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Education {
  String docId;
  String uuid;
  String owner;
  String dateStarted;
  String dateEnded;
  String institution;
  String courseOfStudy;
  String level;
  String classOfDegree;
  DocumentSnapshot documentSnapshot;

  Education(
      {this.docId,
      this.uuid,
      this.owner,
      this.dateStarted,
      this.dateEnded,
      this.institution,
      this.courseOfStudy,
      this.level,
      this.classOfDegree,
      this.documentSnapshot});
}
