import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class JobPosted {
  String uid,
      docId,
      owner,
      position,
      area,
      description,
      location,
      payment,
      expiration,
      posted,
      postedFmt;
  DocumentSnapshot documentSnapshot;

  JobPosted(
      {this.uid,
      this.docId,
      this.owner,
      this.position,
      this.area,
      this.description,
      this.location,
      this.payment,
      this.expiration,
      this.posted,
      this.postedFmt,
      this.documentSnapshot});
}
