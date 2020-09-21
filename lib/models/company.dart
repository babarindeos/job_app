import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';

class Company {
  File file, image;
  String companyName;
  String sector;
  String aboutCompany;
  String address;
  String phone;
  String email;
  String updateStatus;

  Company(
      {this.file,
      this.image,
      this.companyName,
      this.sector,
      this.aboutCompany,
      this.address,
      this.phone,
      this.email,
      this.updateStatus});

  set uFile(File file) {
    this.file = file;
  }

  File get uFile {
    return this.file;
  }

  set uImage(File image) {
    this.image = image;
  }

  File get uImage {
    return this.image;
  }

  set uCompanyName(String companyName) {
    this.companyName = companyName;
  }

  String get uCompanyName {
    return this.companyName;
  }

  set uSector(String sector) {
    this.sector = sector;
  }

  String get uSector {
    return this.sector;
  }

  set uAboutCompany(String aboutCompany) {
    this.aboutCompany = aboutCompany;
  }

  String get uAboutCompany {
    return this.aboutCompany;
  }

  set uAddress(String address) {
    this.address = address;
  }

  String get uAddress {
    return this.address;
  }

  set uPhone(String phone) {
    this.phone = phone;
  }

  String get uPhone {
    return this.phone;
  }

  set uEmail(String email) {
    this.email = email;
  }

  String get uEmail {
    return this.email;
  }

  String get uUpdateStatus {
    return this.updateStatus;
  }

  Future updateCompanyInfo(String userId) async {
    try {
      DocumentReference documentReference =
          Firestore.instance.collection("Company").document(userId);

      Map<String, dynamic> companyData = {
        "name": this.uCompanyName,
        "sector": this.uSector,
        "about": this.uAboutCompany,
        "address": this.uAddress,
        "phone": this.uPhone,
        "email": this.uEmail,
      };

      await documentReference.setData(companyData).whenComplete(() {
        this.updateStatus = "success";
        return "success";
      });
    } catch (e) {
      print(e.toString());
      this.updateStatus = "failed";
      return null;
    }
  }
}
