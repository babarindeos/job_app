import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
    labelStyle: TextStyle(
      color: Colors.black45,
    ),
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.white, width: 2.0),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Colors.amber, width: 2.0),
    ),
    errorStyle: TextStyle(color: Colors.amber));

const profileTextInputDecoration = InputDecoration(
  enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
    color: Colors.blueAccent,
  )),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(
      color: Colors.amber,
    ),
  ),
);
