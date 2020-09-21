import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Experience {
  String docId;
  String uuid;
  String owner;
  String fromDate;
  String toDate;
  String organisation;
  String position;
  String duties;
  DocumentSnapshot documentSnapshot;

  Experience(
      {this.docId,
      this.uuid,
      this.owner,
      this.fromDate,
      this.toDate,
      this.organisation,
      this.position,
      this.duties,
      this.documentSnapshot});
}
