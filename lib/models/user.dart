import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;

  User({this.uid});

  String createUserType(String uid, String user_type) {
    String result;
    try {
      DocumentReference documentReference =
          Firestore.instance.collection('UserType').document(uid);

      Map<String, dynamic> my_type = {
        "user_id": uid,
        "type": user_type,
      };

      documentReference.setData(my_type).whenComplete(() {
        result = "success";
      });
    } catch (e) {
      print(e.toString());
      result = null;
    }

    return result;
  }
}
