import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';

class Storage {
  File _image;
  String 

  Storage({File image}) : _image = image;

  Future getImage() async {
    dynamic image = await ImagePicker.pickImage(source: ImageSource.gallery);
  }
}
