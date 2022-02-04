import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:job_app/screens/friend/view_user_profile_page.dart';
import 'package:job_app/shared/constants.dart';
import 'package:job_app/models/person.dart';
import 'package:uuid/uuid.dart';
import 'package:job_app/models/activity_feed.dart';

class AddFriend extends StatefulWidget {
  String currentUserId;
  AddFriend({this.currentUserId});
  @override
  _AddFriendState createState() => _AddFriendState();
}

class _AddFriendState extends State<AddFriend>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  Person person;
  List<Person> usersList = [];
  List visibleUsers = [];
  bool isLoading = true;

  //----------------------------------------------------------------------------
  void initState() {
    getUsers();
    _tabController = new TabController(length: 2, vsync: this);
    super.initState();
  }

  //----------------------------------------------------------------------------
  Future<void> getUsers() async {
    try {
      final query = Firestore.instance.collection("BioData").orderBy("name");
      var querySnapshot = await query.getDocuments().then((value) => value);
      querySnapshot.documents.forEach((element) async {
        // Add user as long as it's not the same user
        if (element.documentID != widget.currentUserId) {
          person = Person(
              uid: element.documentID,
              name: element['name'],
              avatar: element['avatar'],
              state: element['state'],
              country: element['country']);
          usersList.add(person);
          setState(() {
            visibleUsers = usersList;
          });
        }
      });
    } catch (e) {
      print(e.message.toString());
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Add Friend'),
        bottom: TabBar(
          controller: _tabController,
          unselectedLabelColor: Colors.white,
          labelColor: Colors.amber,
          tabs: [
            Tab(icon: Icon(Icons.person), text: 'Add Friend'),
            Tab(icon: Icon(Icons.person_outline), text: 'Friend Request'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          // ------------------------------- Add Friend  ------------------------------
          Container(
            child: ListView(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(
                      top: 8, left: 8.0, right: 8.0, bottom: 10.0),
                  alignment: Alignment.center,
                  child: TextFormField(
                    decoration: searchTextInputDecoration.copyWith(
                      labelText: 'Search by name',
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                isLoading
                    ? Container(
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: visibleUsers.length,
                        itemBuilder: (context, index) {
                          return AddFriendItem(
                              currentUserId: widget.currentUserId,
                              uid: visibleUsers[index].uid,
                              avatar: visibleUsers[index].avatar,
                              name: visibleUsers[index].name,
                              state: visibleUsers[index].state,
                              country: visibleUsers[index].country);
                        })
              ],
            ),
          ),
          // --------------------------- Friend Request -------------------------------
          Container(
            child: StreamBuilder(
              stream: Firestore.instance
                  .collection("Friends")
                  .where("friend_id", isEqualTo: widget.currentUserId)
                  .where("status", isEqualTo: "pending")
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                return !snapshot.hasData
                    ? Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (context, index) {
                          DocumentSnapshot data =
                              snapshot.data.documents[index];
                          return FriendRequestItem(
                              documentSnapshot: data,
                              docId: data.documentID,
                              uid: data['uid'],
                              owner: data['user_id'],
                              recipient: data['friend_id'],
                              date: data['date']);
                        });
              },
            ),
          )
        ],
      ),
    );
  }
}

//------------------------------------------------------------------------------
//----------------------  AddFriendItem ----------------------------------------
class AddFriendItem extends StatefulWidget {
  String currentUserId, uid, avatar, name, state, country;
  AddFriendItem(
      {this.currentUserId,
      this.uid,
      this.avatar,
      this.name,
      this.state,
      this.country});
  @override
  _AddFriendItemState createState() => _AddFriendItemState();
}

class _AddFriendItemState extends State<AddFriendItem> {
  bool isFriend = false;
  String message = '';
  String friendshipUid = '';
  bool isLoading = true;
  //ActivityFeed _activityFeed = new ActivityFeed();

//------------------- FriendshipIdentifier Generator----------------------------
  Future<String> generateFriendshipIdentifier(String userId) async {
    int strDeterminer = widget.currentUserId.compareTo(userId);
    if (strDeterminer == 1) {
      friendshipUid = widget.currentUserId.toString() + '-' + userId.toString();
    } else {
      friendshipUid = userId.toString() + '-' + widget.currentUserId.toString();
    }
    return friendshipUid;
  }

//------------------ End of FriendshipIdentifier Generator----------------------
//------------------------------------------------------------------------------
  Future<void> _addFriend(String userId, String nameOfUser) async {
    //print(widget.currentUserId);
    //print(userId);
    //--------- Get friendship_uid from generator -------------------------------

    friendshipUid = await generateFriendshipIdentifier(userId);
    //---------End of get friendship from generator ----------------------------

    try {
      var uuid = Uuid();
      var docId = uuid.v4();

      DocumentReference docRef =
          Firestore.instance.collection("Friends").document();
      Map<String, dynamic> data = {
        'uid': docId,
        'friendship_uid': friendshipUid,
        'user_id': widget.currentUserId,
        'friend_id': userId,
        'status': 'pending',
        'date': DateTime.now()
      };
      await docRef.setData(data).then((value) async {
        message = "Friend request has been sent to " + nameOfUser.toString();
        showInSnackBar(message, context);
        await addActivityToFeed('friend_request', widget.currentUserId, userId);
      });
    } catch (e) {
      print(e.toString());
    } finally {}
  }

//------------------------------------------------------------------------------

  Future<void> addActivityToFeed(
      String type, String owner, String recipient) async {
    try {
      var uuid = Uuid();
      String uid = uuid.v4();

      DocumentReference docRef =
          Firestore.instance.collection("ActivityFeeds").document();
      Map<String, dynamic> data = {
        'uid': uid,
        'type': type,
        'owner': owner,
        'recipient': recipient,
        'date': DateTime.now()
      };
      await docRef.setData(data).whenComplete(() {});
    } catch (e) {
      print(e.toString());
    } finally {}
  }

//------------------------------------------------------------------------------

  // Snackbar function
  void showInSnackBar(String value, BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(
        value,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      //backgroundColor: Theme.of(context).backgroundColor,
      backgroundColor: Colors.black,
    ));
  }
  // ---------------------------------------------------------------------------

//------------------------------------------------------------------------------
  Future<bool> _getFriendStatus(String userId) async {
    //--------- Get friendship_uid from generator -----------------------------
    friendshipUid = await generateFriendshipIdentifier(userId);
    //---------End of get friendship from generator ----------------------------
    var query = Firestore.instance
        .collection("Friends")
        .where("friendship_uid", isEqualTo: friendshipUid);
    await query.getDocuments().then((dataSnapshot) {
      if (dataSnapshot.documents.length > 0) {
        if (this.mounted) {
          setState(() {
            isFriend = true;
            isLoading = false;
          });
        }
      } else {
        if (this.mounted) {
          setState(() {
            isFriend = false;
            isLoading = false;
          });
        }
      }
    });
    return isFriend;
  }

//------------------------------------------------------------------------------
//------------------- Dispose --------------------------------------------------
  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
  }
//------------------- End of dispose -------------------------------------------

//------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    //--------------------------------------------------------------------------

    _getFriendStatus(widget.uid);

    //print("isFriend Status: " + isFriend.toString());
    //--------------------------------------------------------------------------

    return Container(
      padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(width: 1.0, color: Colors.grey.shade300),
        ),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue,
          child: ClipOval(
            child: SizedBox(
              width: 100,
              height: 180,
              child: widget.avatar == null
                  ? Image(
                      fit: BoxFit.cover,
                      image: AssetImage('images/profile_avatar.jpg'),
                    )
                  : Image.network(
                      widget.avatar,
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
        title: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewUserProfilePage(userId: widget.uid),
              ),
            );
          },
          child: Text(
            widget.name,
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
        ),
        subtitle: Text('${widget.state}${', '}${widget.country}'),
        trailing: isLoading
            ? CircularProgressIndicator()
            : isFriend
                ? Icon(Icons.check, color: Colors.green)
                : InkWell(
                    onTap: () async {
                      await _addFriend(widget.uid, widget.name);
                    },
                    child: Icon(Icons.person_add),
                  ),
      ),
    );
  }
}

//---------------- FriendRequest Item-------------------------------------------

class FriendRequestItem extends StatefulWidget {
  DocumentSnapshot documentSnapshot;
  String docId, uid, owner, recipient;
  Timestamp date;
  FriendRequestItem(
      {this.documentSnapshot,
      this.docId,
      this.uid,
      this.owner,
      this.recipient,
      this.date});
  @override
  _FriendRequestItemState createState() => _FriendRequestItemState();
}

class _FriendRequestItemState extends State<FriendRequestItem> {
  String nameOfUser = '';
  String avatar = '';
  String career = '';
  String location = '';

//------------------------------------------------------------------------------
  Future<void> getUserBio(String requestSender) async {
    DocumentReference docRef =
        Firestore.instance.collection("BioData").document(requestSender);
    await docRef.get().then((dataSnapshot) {
      if (dataSnapshot.exists) {
        if (mounted) {
          setState(() {
            nameOfUser = dataSnapshot['name'];
            avatar = dataSnapshot['avatar'];
            location = dataSnapshot['state'] + ', ' + dataSnapshot['country'];
          });
        }
      }
    });
  }

//------------------------------------------------------------------------------
  void getUserCareer(String requestSender) async {
    DocumentReference docRef =
        Firestore.instance.collection("CareerDetails").document(requestSender);
    await docRef.get().then((dataSnapshot) {
      if (dataSnapshot.exists) {
        setState(() {
          career = dataSnapshot['field'];
        });
      }
    });
  }
//------------------------------------------------------------------------------

//-----------------  Accept Friend Request -------------------------------------
  Future<void> _acceptFriend(String docId) async {
    DocumentReference docRef =
        Firestore.instance.collection("Friends").document(docId);
    Map<String, dynamic> data = {
      'status': 'active',
    };
    await docRef.updateData(data).then((value) async {
      await addActivityToFeed(
          'friend_request_accepted', widget.recipient, widget.owner);
    });
  }

//------------------------------------------------------------------------------

//------------------ Decline Request -------------------------------------------
  Future<void> _declineRequest(String docId) async {
    DocumentReference docRef =
        Firestore.instance.collection("Friends").document(docId);
    Map<String, dynamic> data = {
      'status': 'decline',
    };
    await docRef.updateData(data).then((value) => {});
  }

//------------------------------------------------------------------------------
//--------- Add to ActivityFeed ------------------------------------------------
  Future<void> addActivityToFeed(
      String type, String owner, String recipient) async {
    try {
      var uuid = Uuid();
      String uid = uuid.v4();

      DocumentReference docRef =
          Firestore.instance.collection("ActivityFeeds").document();
      Map<String, dynamic> data = {
        'uid': uid,
        'type': type,
        'owner': owner,
        'recipient': recipient,
        'date': DateTime.now()
      };
      await docRef.setData(data).whenComplete(() {});
    } catch (e) {
      print(e.toString());
    } finally {}
  }

//------------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    getUserBio(widget.owner);
    getUserCareer(widget.owner);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 5.0),
      child: Card(
        elevation: 7.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 10.0, 3.0, 10.0),
          child: Column(
            children: <Widget>[
              Row(
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
                            child: (avatar == null || avatar == '')
                                ? Image(
                                    fit: BoxFit.cover,
                                    image:
                                        AssetImage('images/profile_avatar.png'),
                                  )
                                : Image.network(avatar, fit: BoxFit.cover),
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
                        Container(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ViewUserProfilePage(userId: widget.owner),
                                ),
                              );
                            },
                            child: Text(
                              nameOfUser,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: Text(
                            career,
                          ),
                        ),
                        Container(
                          child: Text(
                            location,
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 7.0),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 1.0, color: Colors.grey.shade300),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  InkWell(
                    onTap: () async {
                      await _declineRequest(widget.docId);
                    },
                    child: Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(50.0),
                        ),
                      ),
                      height: 30.0,
                      width: 100.0,
                      child: Text(
                        'Decline',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      await _acceptFriend(widget.docId);
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 10.0),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.blue,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(50.0),
                        ),
                      ),
                      height: 30.0,
                      width: 100.0,
                      child: Text(
                        'Accept',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
//---------------------------------------------------------------------------------------
