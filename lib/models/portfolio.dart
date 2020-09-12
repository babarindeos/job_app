import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Portfolio {
  String id, itemId, description, owner, title, year;
  DocumentSnapshot documentSnapshot;

  Portfolio(
      {this.id,
      this.itemId,
      this.description,
      this.owner,
      this.title,
      this.year,
      this.documentSnapshot});

  String get idescription {
    return this.description;
  }
}
