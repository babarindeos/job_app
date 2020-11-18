import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:job_app/models/jobposted.dart';
import 'package:job_app/screens/home/jobs/job_details.dart';
import 'package:job_app/screens/home/search_jobs/search_job_item.dart';
import 'package:job_app/shared/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchJobs extends StatefulWidget {
  @override
  _SearchJobsState createState() => _SearchJobsState();
}

class _SearchJobsState extends State<SearchJobs> {
  bool isLoading = false;
  List<Job> jobs = [];
  List<Job> visibleJobs;
  Job job;

//------------------------------------------------------------------------------

  @override
  void initState() {
    // TODO: implement initState
    isLoading = true;
    getJobListing();

    super.initState();
  }

//------------------------------------------------------------------------------
  Future<void> getJobListing() async {
    Query collectionRef = Firestore.instance.collection("Job_Postings");
    await collectionRef.getDocuments().then((querySnapshot) {
      // querySnapshot
      querySnapshot.documents.forEach((element) async {
        if (element.exists) {
          job = Job(
              docId: element.documentID,
              uid: element['uid'],
              owner: element['owner'],
              position: element['position'],
              expiration: element['expiration'],
              location: element['location'],
              payment: element['payment'],
              area: element['area'],
              description: element['description'],
              postedFmt: element['postedFmt'],
              posted: element['posted'],
              dateposted: element['date_posted']);
          jobs.add(job);
          visibleJobs = jobs;
          setState(() {
            isLoading = false;
          });
        }
      });
    }); //end of await collectionRef
  }

//------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : SafeArea(
            child: Scaffold(
              body: Container(
                padding: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                child: ListView(
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 7.0, horizontal: 5.0),
                      alignment: Alignment.center,
                      child: Text(
                        "Search Jobs",
                        style: TextStyle(
                            fontFamily: 'Pacifico-Regular',
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: TextFormField(
                        decoration: searchTextInputDecoration.copyWith(
                          labelText: 'Search Jobs',
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          visibleJobs = jobs
                              .where(
                                (element) =>
                                    element.position
                                        .toLowerCase()
                                        .contains(value.toLowerCase()) ||
                                    element.location
                                        .toLowerCase()
                                        .contains(value.toLowerCase()),
                              )
                              .toList();
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(height: 15.0),
                    ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: visibleJobs.length,
                        itemBuilder: (context, index) {
                          return JobItem(
                            docId: visibleJobs[index].docId,
                            uid: visibleJobs[index].uid,
                            owner: visibleJobs[index].owner,
                            position: visibleJobs[index].position,
                            area: visibleJobs[index].area,
                            description: visibleJobs[index].description,
                            location: visibleJobs[index].location,
                            payment: visibleJobs[index].payment,
                            expiration: visibleJobs[index].expiration,
                            posted: visibleJobs[index].posted,
                            postedFmt: visibleJobs[index].postedFmt,
                            datePosted: visibleJobs[index].dateposted,
                          );
                        })
                  ],
                ),
              ),
            ),
          );
  }
}

//------------------------------------------------------------------------------

class JobItem extends StatefulWidget {
  String docId,
      position,
      uid,
      owner,
      area,
      description,
      location,
      payment,
      expiration,
      posted,
      postedFmt;
  Timestamp datePosted;
  JobItem(
      {this.docId,
      this.uid,
      this.owner,
      this.position,
      this.area,
      this.description,
      this.location,
      this.payment,
      this.expiration,
      this.posted,
      this.postedFmt,
      this.datePosted});
  @override
  _JobItemState createState() => _JobItemState();
}

class _JobItemState extends State<JobItem> {
  JobPosted passData;

//------------------------------------------------------------------------------
  Future _getCompanyInfo(String companyId) async {
    return Firestore.instance
        .collection("Company")
        .document(companyId)
        .get()
        .then((dataSnapshot) => dataSnapshot);
  }

//------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        elevation: 7.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 3.0, 10.0),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.position,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15.0,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.business,
                              size: 18.0,
                              color: Colors.blue.shade300,
                            ),
                            FutureBuilder(
                                future: _getCompanyInfo(widget.owner),
                                builder: (BuildContext context,
                                    AsyncSnapshot snapshot) {
                                  if (snapshot.hasData) {
                                    return Container(
                                      padding: const EdgeInsets.only(
                                          left: 3.0, top: 7.0, bottom: 5.0),
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: Text(
                                        snapshot.data['name'].toString(),
                                        style: TextStyle(
                                          fontSize: 12.0,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return Container();
                                  }
                                }),
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.pin_drop,
                              size: 18.0,
                              color: Colors.blue.shade300,
                            ),
                            Container(
                              padding: const EdgeInsets.only(
                                left: 3.0,
                              ),
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Text(
                                widget.location,
                                style: TextStyle(fontSize: 12.0),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        passData = JobPosted(
                          docId: widget.docId,
                          uid: widget.uid,
                          position: widget.position,
                          owner: widget.owner,
                          area: widget.area,
                          description: widget.position,
                          location: widget.location,
                          payment: widget.payment,
                          expiration: widget.expiration,
                          posted: widget.posted,
                          postedFmt: widget.postedFmt,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => JobDetails(data: passData),
                          ),
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        child: Icon(Icons.chevron_right),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 6.0,
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.0, color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        'Created ${widget.postedFmt}',
                        style: TextStyle(fontSize: 11.0),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.centerRight,
                        child: Text(
                          'Closes ${widget.expiration}',
                          style: TextStyle(fontSize: 11.0),
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

//-----------------------------------------------------------------------------

class Job {
  String docId,
      uid,
      owner,
      position,
      expiration,
      location,
      payment,
      area,
      description,
      postedFmt,
      posted;
  Timestamp dateposted;
  Job(
      {this.docId,
      this.uid,
      this.owner,
      this.position,
      this.expiration,
      this.location,
      this.payment,
      this.area,
      this.description,
      this.postedFmt,
      this.posted,
      this.dateposted});
}
