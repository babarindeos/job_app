import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_app/models/user.dart';
import 'package:job_app/screens/interview/candidate_scheduled_interviews.dart';
import 'package:job_app/screens/interview/schedule_interview.dart';
import 'package:job_app/screens/recruiter/jobs/ApplicantsInformation.dart';
import 'package:job_app/shared/constants.dart';
import 'package:provider/provider.dart';

class CandidateList extends StatefulWidget {
  @override
  _CandidateListState createState() => _CandidateListState();
}

class _CandidateListState extends State<CandidateList>
    with SingleTickerProviderStateMixin {
  String companyId;
  TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  Widget build(BuildContext context) {
    final currentUserId = Provider.of<User>(context);
    companyId = currentUserId.uid.toString();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Interview'),
        bottom: TabBar(
          controller: _tabController,
          unselectedLabelColor: Colors.white,
          labelColor: Colors.amber,
          tabs: [
            Tab(
              icon: Icon(Icons.person),
              text: 'Shortlisted',
            ),
            Tab(
              icon: Icon(Icons.chat),
              text: 'Scheduled',
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          Container(
            child: ListView(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                      top: 8, left: 5.0, right: 5.0, bottom: 10.0),
                  alignment: Alignment.center,
                  child: TextFormField(
                    decoration: searchTextInputDecoration.copyWith(
                        labelText: 'Search Candidate',
                        prefixIcon: Icon(Icons.search)),
                  ),
                ),
                StreamBuilder(
                    stream: Firestore.instance
                        .collection("Shortlist")
                        .where("company_id", isEqualTo: companyId)
                        .snapshots(),
                    builder: (context, snapshot) {
                      return !snapshot.hasData
                          ? Center(
                              child: CircularProgressIndicator(),
                            )
                          : ListView.builder(
                              reverse: true,
                              shrinkWrap: true,
                              scrollDirection: Axis.vertical,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data.documents.length,
                              itemBuilder: (context, index) {
                                DocumentSnapshot data =
                                    snapshot.data.documents[index];
                                return ShortlistedItem(
                                  documentSnapshot: data,
                                  shortlistedDocId: data.documentID,
                                  uid: data['uid'],
                                  applicationId: data['application_id'],
                                  candidateId: data['candidate_id'],
                                  companyId: data['company_id'],
                                  dateApplied: data['date'],
                                  jobId: data['job_id'],
                                );
                              });
                    }),
              ],
            ),
          ),
          Text('Interviews'),
        ],
      ),
    );
  }
}

class ShortlistedItem extends StatefulWidget {
  String uid, shortlistedDocId, applicationId, candidateId, companyId, jobId;
  Timestamp dateApplied;
  DocumentSnapshot documentSnapshot;
  ShortlistedItem(
      {this.uid,
      this.shortlistedDocId,
      this.applicationId,
      this.candidateId,
      this.companyId,
      this.jobId,
      this.dateApplied,
      this.documentSnapshot});
  @override
  _ShortlistedItemState createState() => _ShortlistedItemState();
}

class _ShortlistedItemState extends State<ShortlistedItem> {
  String candidateAvatar;
  String candidateName = '';
  String jobPosition = '';
  String jobPositionCaption = '';
  bool isLoading = false;

//----------------------------------------------------------------------------
// _companyInfo
  Future<void> _companyInfo(String companyId) async {}
//----------------------------------------------------------------------------
// _jobinfo
  Future<void> _jobInfo(String jobId) async {
    try {
      DocumentReference docRef =
          Firestore.instance.collection("Job_Postings").document(jobId);
      await docRef.get().then((dataSnapshot) {
        setState(() {
          jobPosition = dataSnapshot['position'];
          jobPositionCaption = 'Applied  Job: $jobPosition';
        });
      });
    } catch (e) {} finally {}
  }

//----------------------------------------------------------------------------
// _candidateinfo
  Future<void> _candidateInfo(String candidateId) async {
    try {
      DocumentReference docRef =
          Firestore.instance.collection("BioData").document(candidateId);
      await docRef.get().then((dataSnapshot) {
        setState(() {
          candidateAvatar = dataSnapshot['avatar'];
          candidateName = dataSnapshot['name'];
        });
      });
    } catch (e) {}
  }

//-----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    _companyInfo(widget.companyId);
    _jobInfo(widget.jobId);
    _candidateInfo(widget.candidateId);

    return Container(
      padding: const EdgeInsets.fromLTRB(0.0, 2.0, 2.0, 3.0),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: ClipOval(
            child: SizedBox(
              width: 100,
              height: 180,
              child: candidateAvatar == null
                  ? Image(
                      fit: BoxFit.cover,
                      image: AssetImage('images/profile_avatar.jpg'),
                    )
                  : Image.network(
                      candidateAvatar,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
        title: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ApplicantsInformation(
                  userId: widget.candidateId,
                  jobId: widget.jobId,
                  docId: widget.applicationId,
                  dateApplied: widget.dateApplied.toString(),
                  documentSnapshot: widget.documentSnapshot,
                ),
              ),
            );
          },
          child: Text(
            candidateName,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.blue,
            ),
          ),
        ),
        subtitle: Text(jobPositionCaption),
        trailing: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CandidateSheduledInterviews(
                      candidateId: widget.candidateId,
                      candidateName: candidateName,
                      candidateAvatar: candidateAvatar,
                      companyId: widget.companyId,
                      applicationId: widget.applicationId,
                      jobId: widget.jobId,
                      jobPosition: jobPosition,
                      shortlistedDocId: widget.shortlistedDocId),
                ),
              );
            },
            child: Icon(Icons.chevron_right)),
      ),
    );
  }
}
