import 'package:cloud_firestore/cloud_firestore.dart';

class Interview {
  String uid;
  String applicationDocId;
  String candidateDocId;
  String companyDocId;
  String companyName;
  String comment;
  String jobDocId;
  String jobPosition;
  String jobLocation;
  String scheduleDate;
  String scheduledDateUnFmt;
  String scheduleTime;
  String shortlistedDocId;

  Timestamp dateCreated, scheduledDateDtFmt;

  Interview(
      {this.uid,
      this.applicationDocId,
      this.candidateDocId,
      this.companyDocId,
      this.companyName,
      this.comment,
      this.jobDocId,
      this.jobPosition,
      this.jobLocation,
      this.scheduleDate,
      this.scheduledDateDtFmt,
      this.scheduledDateUnFmt,
      this.scheduleTime,
      this.shortlistedDocId});
}
