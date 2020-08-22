import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image/image.dart' as Im;
import 'package:uuid/uuid.dart';

class Storage {
  File _image, _file;
  String _mediaUrl;
  String _uid;
  String _submissionType;
  String _postId;

  StorageReference storageRef = FirebaseStorage.instance.ref();

  Storage(
      {File image,
      File file,
      String mediaUrl,
      String uid,
      String submissionType,
      String postId})
      : _image = image,
        _file = file,
        _mediaUrl = mediaUrl,
        _uid = uid,
        _submissionType = submissionType,
        _postId = postId;

  Future getImage() async {
    dynamic image = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  set pUid(String uid) {
    this._uid = uid;
  }

  String get pUid {
    return this._uid;
  }

  set pSubmissionType(String submissionType) {
    this._submissionType = submissionType;
  }

  String get pSubmissionType {
    return this._submissionType;
  }

  set pFile(File file) {
    this._file = file;
  }

  File get pFile {
    return this._file;
  }

  set pPostId(String postId) {
    this._postId = Uuid().v4();
  }

  String get pPostId {
    return this._postId;
  }

  // Upload Avatar
  Future uploadAvatar(String userId, String submissionType) async {
    this.pUid = userId;
    this.pSubmissionType = submissionType;
    print(this.pUid);
    print(this.pSubmissionType);

    await this._compressImage();
    this._mediaUrl = await this._executeFileUpload();
    return this._mediaUrl;
  }

  // comppress image
  Future _compressImage() async {
    String postId = Uuid().v4();
    print('Compress Image module');
    final tempDir = await getTemporaryDirectory();
    final path = tempDir.path;
    Im.Image imageFile = Im.decodeImage(this.pFile.readAsBytesSync());
    final compressImageFile = File('$path/img_$postId.jpg')
      ..writeAsBytesSync(Im.encodeJpg(imageFile, quality: 85));

    print(compressImageFile);
    // setState(() {
    //   file = compressImageFile;
    //   print("Image has been compressed");
    // });

    this.pFile = compressImageFile;
  }

  Future<String> _executeFileUpload() async {
    print("In Upload Image module");
    StorageUploadTask uploadTask = storageRef
        .child('$_submissionType' + "_" + "$_uid.jpg")
        .putFile(this._file);
    StorageTaskSnapshot storageSnap = await uploadTask.onComplete;
    String downloadUrl = await storageSnap.ref.getDownloadURL();
    return downloadUrl;
  }
} //end of class
