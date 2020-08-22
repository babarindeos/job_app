import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String uid;

  User({this.uid});

  Future createUserType(String uid, String userType) async {
    String result;
    try {
      DocumentReference documentReference =
          Firestore.instance.collection('UserType').document(uid);

      Map<String, dynamic> my_type = {
        "user_id": uid,
        "type": userType,
      };

      await documentReference.setData(my_type).whenComplete(() {
        result = "success";
      });
    } catch (e) {
      print(e.toString());
      result = null;
    }

    return result;
  }
}
