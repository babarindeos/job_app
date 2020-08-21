import 'package:cloud_firestore/cloud_firestore.dart';

class Profile{
  String gender;
  String name;
  String age;
  String state;
  String country;
  String phone;

  final CollectionReference BioDataReference = Firestore.instance.collection('BioData');

  Profile({this.gender, this.name, this.age, this.state, this.country, this.phone});

  set uGender(String gender){this.gender = gender; }
  String get uGender{return gender; }

  set uName(String name){ this.name = name; }
  String get uName{return name; }

  set uAge(String age){this.age = age;}
  String get uAge{ return age; }

  set uState(String state){this.state = state;}
  String get uState{return state; }

  set uCountry(String country){this.country=country;}
  String get uCountry{return country;}

  set uPhone(String phone){this.phone;}
  String get uPhone{return phone; }

  Future updateProfile(String uid) async{
    try{
        return await BioDataReference
            .document(uid)
            .setData({'gender': gender, 'name': name, 'age': age, 'state':state, 'country':country, 'phone':phone})
            .whenComplete(() => {print('$name BioData has been updated.')});
    }catch(e){
        print(e.toString());
        return null;
    }

  }



}