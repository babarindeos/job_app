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
  String logo;
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
      this.logo,
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

  set uLogo(String logo) {
    this.logo = logo;
  }

  String get uLogo {
    return this.logo;
  }

  String get uUpdateStatus {
    return this.updateStatus;
  }

  Future updateCompanyInfo(String userId) async {
    try {
      DocumentReference documentReference =
          Firestore.instance.collection("Company").document(userId);
      Map<String, dynamic> companyData;
      if (this.uLogo != '' || this.uLogo != null) {
        companyData = {
          "name": this.uCompanyName,
          "sector": this.uSector,
          "about": this.uAboutCompany,
          "address": this.uAddress,
          "phone": this.uPhone,
          "email": this.uEmail,
          "logo": this.uLogo,
        };
      } else {
        companyData = {
          "name": this.uCompanyName,
          "sector": this.uSector,
          "about": this.uAboutCompany,
          "address": this.uAddress,
          "phone": this.uPhone,
          "email": this.uEmail,
        };
      }

      await documentReference.updateData(companyData).whenComplete(() {
        this.updateStatus = "success";
        return "success";
      });
    } catch (e) {
      print(e.toString());
      this.updateStatus = "failed";
      return null;
    }
  }

//------------------------------------------------------------------------------
  Future updateAboutCompanyInfo(String userId, String aboutInfo) async {
    try {
      DocumentReference docRef =
          Firestore.instance.collection("Company").document(userId);
      Map<String, dynamic> data = {
        'about': aboutInfo,
      };
      await docRef.updateData(data).whenComplete(() {
        this.updateStatus = "Company information has been updated";
        return 'success';
      });
    } catch (e) {
      this.updateStatus = e.message;
      return e.message;
    } finally {}
  }
//------------------------------------------------------------------------------

  Future updateCompanyContactInfo(
      String userId, String website, String phone, String fax) async {
    try {
      DocumentReference docRef =
          Firestore.instance.collection("Company").document(userId);
      Map<String, dynamic> data = {
        'website': website,
        'phone': phone,
        'fax': fax,
      };
      await docRef.updateData(data).whenComplete(() {
        this.updateStatus = "Company information has been updated.";
        return 'success';
      });
    } catch (e) {
      this.updateStatus = e.message;
      return e.message;
    } finally {}
  }

//------------------------------------------------------------------------------
  Future updateCompanySocialMediaInfo(String userId, String facebook,
      String twitter, String linkedIn, String instagram) async {
    try {
      DocumentReference docRef =
          Firestore.instance.collection("Company").document(userId);
      Map<String, dynamic> data = {
        'facebook': facebook,
        'twitter': twitter,
        'linkedin': linkedIn,
        'instagram': instagram
      };
      await docRef.updateData(data).whenComplete(() {
        this.updateStatus = "Company information has been updated.";
        return 'success';
      });
    } catch (e) {
      this.updateStatus = e.message;
      return e.message;
    } finally {}
  }

//------------------------------------------------------------------------------

}
