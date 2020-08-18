import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;

  User({this.uid});


  String isNewUser(String uid) {
    try{
      DocumentReference documentReference = Firestore.instance.collection('UserType').document(uid);

      documentReference.get().then((datasnapshot){
        if (datasnapshot.exists) {
            return (datasnapshot.data['type']);
        }else{
            return null;
        }

      });
    }catch(e){
      print(e.toString());
      return null;
    }
  }


}
