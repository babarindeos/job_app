import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  String gender;
  String name;
  String age;
  String state;
  String country;
  String phone;
  String avatarUrl;

  final CollectionReference BioDataReference =
      Firestore.instance.collection('BioData');

  Profile(
      {this.gender,
      this.name,
      this.age,
      this.state,
      this.country,
      this.phone,
      this.avatarUrl});

  set uGender(String gender) {
    this.gender = gender;
  }

  String get uGender {
    return gender;
  }

  set uName(String name) {
    this.name = name;
  }

  String get uName {
    return name;
  }

  set uAge(String age) {
    this.age = age;
  }

  String get uAge {
    return age;
  }

  set uState(String state) {
    this.state = state;
  }

  String get uState {
    return state;
  }

  set uCountry(String country) {
    this.country = country;
  }

  String get uCountry {
    return country;
  }

  set uPhone(String phone) {
    this.phone = phone;
  }

  String get uPhone {
    return phone;
  }

  set uAvatarUrl(String avatar) {
    this.avatarUrl = avatar;
  }

  String get uAvatar {
    return avatarUrl;
  }

  Future updateProfile(String uid, String mediaUrl) async {
    try {
      avatarUrl = mediaUrl;
      Map profile = Map<String, dynamic>();

      print("************************AVATAR URL: " + avatarUrl.toString());

      //Map without Changed Avatar i.e Avatar is blank
      Map<String, dynamic> profileWithoutAvatar = {
        'gender': gender,
        'name': name,
        'age': age,
        'state': state,
        'country': country,
        'phone': phone,
      };

      //Map with Changed Avatar i.e avatarUrl is not blank
      Map<String, dynamic> profileWithAvatar = {
        'gender': gender,
        'name': name,
        'age': age,
        'state': state,
        'country': country,
        'phone': phone,
        'avatar': avatarUrl
      };

      if (avatarUrl == '') {
        profile = profileWithoutAvatar;
      } else {
        profile = profileWithAvatar;
      }

      return await BioDataReference.document(uid)
          .setData(profile)
          .whenComplete(() {
        return ('Bio-Data has been Updated.');
      });

      //   return await BioDataReference.document(uid).setData({
      //     'gender': gender,
      //     'name': name,
      //     'age': age,
      //     'state': state,
      //     'country': country,
      //     'phone': phone,
      //     'avatar': avatarUrl,
      //   }).whenComplete(() {
      //     return ('$name BioData has been updated.');
      //   });
      // } catch (e) {
      //   print(e.toString());
      //   return null;
      // }

    } catch (e) {
      print(e.toString());
      return null;
    } // end of try and catch
  }
}
