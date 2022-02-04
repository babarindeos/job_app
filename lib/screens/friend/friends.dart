import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_app/models/person.dart';
import 'package:job_app/screens/friend/view_user_profile_page.dart';
import 'package:job_app/screens/recruiter/message/messages.dart';
import 'package:job_app/shared/constants.dart';

class Friends extends StatefulWidget {
  String currentUserId;
  Friends({this.currentUserId});
  @override
  _FriendsState createState() => _FriendsState();
}

class _FriendsState extends State<Friends> with SingleTickerProviderStateMixin {
  TabController _tabController;
  List<String> activeFriendsList = [];
  List<Map<String, dynamic>> friendsIdentity = [];
  List<String> bothFriends = [];
  Person person;
  List<Person> myFriends = [];
  String theOtherParty;
  List<Person> visibleFriendsList = [];
  String friendsCount = '';
  bool isLoading = true;
  String currentUserName = '';
  String currentUserAvatar = '';

  //--------------------------- getActiveFriends -----------------------------------
  Future<void> getActiveFriends() async {
    try {
      final query = Firestore.instance
          .collection("Friends")
          .where("status", isEqualTo: 'active')
          .orderBy("date", descending: true);
      var querySnapshot = await query.getDocuments().then((value) => value);
      querySnapshot.documents.forEach((element) async {
        if (element['friendship_uid']
            .toString()
            .contains(widget.currentUserId)) {
          bothFriends.clear();

          // elements to friendsIdentity for reference
          friendsIdentity.add({
            "uid": element['uid'],
            "friendship_uid": element['friendship_uid']
          });

          // split friendship_uid to get the other partner from currentUserId
          bothFriends = element['friendship_uid'].split("-");

          //print(bothFriends);
          // Determine the user to add to the active friend list
          if (bothFriends[0] != widget.currentUserId) {
            activeFriendsList.add(bothFriends[0]);
            theOtherParty = bothFriends[0];
          }
          if (bothFriends[1] != widget.currentUserId) {
            activeFriendsList.add(bothFriends[1]);
            theOtherParty = bothFriends[1];
          }

          // get User friends biodata information
          await getMyFriend(theOtherParty);
        }
      });
      print(activeFriendsList);
    } catch (e) {} finally {}
  }

  //-------------------------- end of getActiveFriends -------------------------
  //----------------------------------------------------------------------------
//-----------------------------getMyFriends-------------------------------------
  Future<void> getMyFriend(String theOtherParty) async {
    //print("Inside GetMyFriends: " + theOtherParty);
    DocumentReference docRef =
        Firestore.instance.collection("BioData").document(theOtherParty);
    await docRef.get().then((dataSnapshot) {
      if (dataSnapshot.exists) {
        person = Person(
            uid: dataSnapshot.documentID,
            name: dataSnapshot['name'],
            avatar: dataSnapshot['avatar'],
            age: dataSnapshot['age'],
            gender: dataSnapshot['gender'],
            phone: dataSnapshot['phone'],
            state: dataSnapshot['state'],
            country: dataSnapshot['country']);

        setState(() {
          myFriends.add(person);
          myFriends.sort((a, b) => a.name.compareTo(b.name));
          visibleFriendsList = myFriends;
          friendsCount = "(${visibleFriendsList.length})";
          isLoading = false;
        });
      }
    });
    print(myFriends);
  }

//---------------------------- End of getMyFriends -----------------------------

//---------------------------- getCurrentUserBioData ---------------------------

  Future<void> getCurrentUserBioData() async {
    DocumentReference docRef =
        Firestore.instance.collection("BioData").document(widget.currentUserId);
    await docRef.get().then((dataSnapshot) {
      if (dataSnapshot.exists) {
        setState(() {
          currentUserAvatar = dataSnapshot['avatar'];
          currentUserName = dataSnapshot['name'];
        });
      }
    });
  }

//-----------------------------End of getCurrentUserBioData --------------------
//------------------------------------------------------------------------------
  @override
  void initState() {
    // TODO: implement initState
    getActiveFriends();
    getCurrentUserBioData();
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

//------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Friends'),
        bottom: TabBar(
            controller: _tabController,
            unselectedLabelColor: Colors.white,
            labelColor: Colors.amber,
            tabs: [
              Tab(icon: Icon(Icons.people), text: 'My Friends ' + friendsCount),
              Tab(icon: Icon(Icons.people_outline), text: 'Blocked'),
            ]),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : TabBarView(
              controller: _tabController,
              children: <Widget>[
                //------------------------------- My Friends ----------------------------
                Container(
                  child: ListView(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 8.0, right: 8.0, bottom: 10.0),
                        child: TextField(
                          decoration: searchTextInputDecoration.copyWith(
                            labelText: 'Search by name',
                            prefixIcon: Icon(Icons.search),
                          ),
                        ),
                      ),
                      SizedBox(height: 10.0),
                      ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: visibleFriendsList.length,
                          itemBuilder: (context, index) {
                            return MyFriendsItem(
                              friendIdentityUid: friendsIdentity[index]['uid'],
                              currentUserId: widget.currentUserId,
                              currentUserName: currentUserName,
                              currentUserAvatar: currentUserAvatar,
                              userUid: visibleFriendsList[index].uid,
                              avatar: visibleFriendsList[index].avatar,
                              name: visibleFriendsList[index].name,
                              state: visibleFriendsList[index].state,
                              country: visibleFriendsList[index].country,
                            );
                          }),
                    ],
                  ),
                ),

                // ------------------------------- Blocked ------------------------------
                Container(
                  child: ListView(
                    children: <Widget>[],
                  ),
                )
              ],
            ),
    );
  }
}

//------------------------------------------------------------------------------
//---------------  MyFriendsItem -----------------------------------------------
class MyFriendsItem extends StatefulWidget {
  String currentUserId,
      userUid,
      avatar,
      name,
      state,
      country,
      currentUserName,
      currentUserAvatar,
      friendIdentityUid;
  MyFriendsItem(
      {this.currentUserId,
      this.currentUserName,
      this.currentUserAvatar,
      this.userUid,
      this.avatar,
      this.name,
      this.state,
      this.country,
      this.friendIdentityUid});
  @override
  _MyFriendsItemState createState() => _MyFriendsItemState();
}

class _MyFriendsItemState extends State<MyFriendsItem> {
//---------------------------- _blockFriend ------------------------------------

  Future<void> _blockFriend(String friendIdentityUid) async {
    // var getFriendsDocId = Firestore.instance
    //     .collection("Friends")
    //     .where("uid", isEqualTo: friendIdentityUid)
    //     .getDocuments()
    //     .then((value) {});
    Query collectionRef = Firestore.instance
        .collection("Friends")
        .where("uid", isEqualTo: friendIdentityUid);
    await collectionRef.getDocuments().then((QuerySnapshot) {
      QuerySnapshot.documents.forEach((element) async {
        if (element.exists) {
          await _executeBlockFriend(element.documentID);
        }
      });
    });
  }

//---------------------------- End of _blockFriend -----------------------------
//------------------------------------------------------------------------------

//---------------------- _executeBlockFriend------------------------------------
  Future<void> _executeBlockFriend(String friendDocId) async {
    print(friendDocId);
    DocumentReference docRef =
        Firestore.instance.collection("Friends").document(friendDocId);
    Map<String, dynamic> data = {
      "status": "blocked",
    };
    await docRef.updateData(data).whenComplete(() {});
  }

//--------------------- End of _executeBlockFriend -----------------------------

  @override
  Widget build(BuildContext context) {
    print(widget.friendIdentityUid);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 5.0),
      child: Card(
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 3.0, 7.0),
          child: Column(
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: CircleAvatar(
                      radius: 30.0,
                      backgroundColor: Colors.blue,
                      child: CircleAvatar(
                        radius: 29.0,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: SizedBox(
                            width: 100,
                            height: 180,
                            child: (widget.avatar == null ||
                                    widget.avatar == '')
                                ? Image(
                                    fit: BoxFit.cover,
                                    image:
                                        AssetImage('images/profile_avatar.png'),
                                  )
                                : Image.network(widget.avatar,
                                    fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10.0),
                  Expanded(
                    flex: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ViewUserProfilePage(userId: widget.userUid),
                              ),
                            );
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Text(
                              widget.name,
                              style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Text(
                            '${widget.state}, ${widget.country}',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                        SizedBox(
                          height: 8.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Messages(
                                      senderId: widget.currentUserId,
                                      candidateId: widget.userUid,
                                      candidateName: widget.name,
                                      senderName: widget.currentUserName,
                                      candidateAvatar: widget.avatar,
                                      senderAvatar: widget.currentUserAvatar,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50.0),
                                  ),
                                ),
                                height: 30.0,
                                width: 90.0,
                                child: Text(
                                  'Message',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            SizedBox(width: 5.0),
                            InkWell(
                              onTap: () async {
                                _blockFriend(widget.friendIdentityUid);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blue),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(50.0),
                                  ),
                                ),
                                height: 30.0,
                                width: 90.0,
                                child: Text(
                                  'Block',
                                  style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

//------------------------------------------------------------------------------
