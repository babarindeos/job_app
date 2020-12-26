import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ActivityFeed {
  String uid, type, owner, recipient;
  DateTime date;

  ActivityFeed({this.uid, this.type, this.owner, this.recipient, this.date});

  set gUid(String uid) {
    this.uid = uid;
  }

  String get gUid {
    return this.uid;
  }

  set gType(String type) {
    this.type = type;
  }

  String get gType {
    return this.type;
  }

  set gOwner(String owner) {
    this.owner = owner;
  }

  String get gOwner {
    return this.owner;
  }

  set gRecipient(String recipient) {
    this.recipient = recipient;
  }

  String get gRecipient {
    return this.recipient;
  }

  set gDate(DateTime date) {
    this.date = date;
  }

  DateTime get gDate {
    return this.gDate;
  }

  Future<void> addActivityToFeed(
      String type, String owner, String recipient) async {
    try {
      var uuid = Uuid();
      gUid = uuid.v4();
      gType = type;
      gOwner = owner;
      gRecipient = recipient;
      gDate = DateTime.now();

      print("UID --- " + gUid);
      print("Type ----" + gType);
      print("Owner ------ " + gOwner);
      print("Recipient ----- " + gRecipient);

      DocumentReference docRef =
          Firestore.instance.collection("ActivityFeeds").document();
      Map<String, dynamic> data = {
        'uid': gUid,
        'type': gType,
        'owner': gOwner,
        'recipient': gRecipient,
        'date': gDate
      };
      await docRef.setData(data).whenComplete(() {});
    } catch (e) {
      print(e.toString());
    } finally {}
  }
}
