import 'package:cloud_firestore/cloud_firestore.dart';

class JobApplication {
  String jobId;
  String userId;
  DateTime dateApplied;

  JobApplication({this.jobId, this.userId, this.dateApplied});
}
