import 'package:connectcard/models/Friends.dart';
import 'package:connectcard/models/FriendsDatabase.dart';
import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/services/database.dart';
import 'package:flutter/material.dart';

class AddFriendsPage extends StatefulWidget {
  final List<UserData> users;
  final String uid;

  AddFriendsPage({required this.users, required this.uid});

  @override
  _AddFriendsPageState createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage> {
  List<UserData> filteredUsers = [];
  //for toggling between showing requests and showing friends
  bool showRequests = true;

  @override
  void initState() {
    super.initState();
    _initializeFilteredUsers();
  }

  //to filter users that are not in request
  void _initializeFilteredUsers() async {
    List<UserData> tempFilteredUsers = [];

    for (UserData user in widget.users) {
      bool isRequested = await _isFriendRequested(user);
      if (!isRequested) {
        tempFilteredUsers.add(user);
      }
    }

    setState(() {
      filteredUsers = tempFilteredUsers;
    });
  }

  void _filterUsers(String query) async {
    setState(() {
      filteredUsers = [];
    });

    List<UserData> tempFilteredUsers = [];

    for (UserData user in widget.users) {
      bool isRequested = await _isFriendRequested(user);
      //to sort out the users that are already requested
      if (!isRequested &&
          (user.name.toLowerCase().contains(query.toLowerCase()) ||
              user.headLine.toLowerCase().contains(query.toLowerCase()) ||
              user.uid.toLowerCase().contains(query.toLowerCase()))) {
        tempFilteredUsers.add(user);
      }
    }

    setState(() {
      filteredUsers = tempFilteredUsers;
    });
  }

  //to check if its in request or is in my friend list
  Future<bool> _isFriendRequested(UserData user) async {
    DatabaseService databaseService = DatabaseService(uid: widget.uid);
    FriendsData friendsData = await databaseService.friendData.first;
    List<Friends> friendRequestsSent =
        List.from(friendsData.listOfFriendRequestsSent);
    List<Friends> friendList = List.from(friendsData.listOfFriends);

    bool isFriendRequested =
        friendRequestsSent.any((friend) => friend.uid == user.uid);
    bool isFriend = friendList.any((friend) => friend.uid == user.uid);

    return isFriendRequested || isFriend;
  }

  //popup to add friends
  void _showProfilePopup(UserData user) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Add ${user.name} as a friend?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              CircleAvatar(
                radius: 60.0,
                backgroundImage: NetworkImage(user.profilePic),
              ),
              SizedBox(height: 16.0),
              Text(
                '${user.name} #${user.uid.substring(user.uid.length - 4)}',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                user.headLine,
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
              SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Add Friend into PERSONAL friendrequestsent
                      DatabaseService databaseService =
                          DatabaseService(uid: widget.uid);
                      FriendsData friendsData =
                          await databaseService.friendData.first;
                      List<Friends> friendRequestsSent =
                          List.from(friendsData.listOfFriendRequestsSent);
                      friendRequestsSent.add(Friends(uid: user.uid));
                      await databaseService.updateFriendDatabase(
                        friendsData.listOfFriends,
                        friendRequestsSent,
                        friendsData.listOfFriendRequestsRec,
                        friendsData.listOfFriendsPhysicalCard,
                      );

                      // Friend to receive the request under friendrequestrec
                      DatabaseService databaseServiceFriend =
                          DatabaseService(uid: user.uid);
                      FriendsData friendsDataFriend =
                          await databaseServiceFriend.friendData.first;
                      List<Friends> friendRequestsReceived =
                          List.from(friendsDataFriend.listOfFriendRequestsRec);
                      friendRequestsReceived.add(Friends(uid: widget.uid));
                      await databaseServiceFriend.updateFriendDatabase(
                        friendsDataFriend.listOfFriends,
                        friendsDataFriend.listOfFriendRequestsSent,
                        friendRequestsReceived,
                        friendsDataFriend.listOfFriendsPhysicalCard,
                      );

                      Navigator.pop(context);

                      // Refresh filtered users list to show changes
                      _initializeFilteredUsers();
                    },
                    child: Text('Add Friend'),
                  ),
                  SizedBox(width: 16.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  //popup to remove friend request
  void _removeRequest(UserData user) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Remove friend request for ${user.name}?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.0),
              CircleAvatar(
                radius: 60.0,
                backgroundImage: NetworkImage(user.profilePic),
              ),
              SizedBox(height: 16.0),
              Text(
                '${user.name} #${user.uid.substring(user.uid.length - 4)}',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),
              Text(
                user.headLine,
                style: TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
              SizedBox(height: 24.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      // Remove Friend from PERSONAL friendrequestsent
                      DatabaseService databaseService =
                          DatabaseService(uid: widget.uid);
                      FriendsData friendsData =
                          await databaseService.friendData.first;
                      List<Friends> friendRequestsSent =
                          List.from(friendsData.listOfFriendRequestsSent);
                      friendRequestsSent
                          .removeWhere((friend) => friend.uid == user.uid);
                      await databaseService.updateFriendDatabase(
                        friendsData.listOfFriends,
                        friendRequestsSent,
                        friendsData.listOfFriendRequestsRec,
                        friendsData.listOfFriendsPhysicalCard,
                      );

                      // Remove Friend from friendrequestrec
                      DatabaseService databaseServiceFriend =
                          DatabaseService(uid: user.uid);
                      FriendsData friendsDataFriend =
                          await databaseServiceFriend.friendData.first;
                      List<Friends> friendRequestsReceived =
                          List.from(friendsDataFriend.listOfFriendRequestsRec);
                      friendRequestsReceived
                          .removeWhere((friend) => friend.uid == widget.uid);
                      await databaseServiceFriend.updateFriendDatabase(
                        friendsDataFriend.listOfFriends,
                        friendsDataFriend.listOfFriendRequestsSent,
                        friendRequestsReceived,
                        friendsDataFriend.listOfFriendsPhysicalCard,
                      );

                      // Refresh filtered users list so that it will show the updated changes
                      _initializeFilteredUsers();

                      Navigator.pop(context);
                    },
                    child: Text('Remove Request'),
                  ),
                  SizedBox(width: 16.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  //to get the list of friend request from database
  Future<List<Friends>> _getFriendRequestsSent() async {
    DatabaseService databaseService = DatabaseService(uid: widget.uid);
    FriendsData friendsData = await databaseService.friendData.first;
    return List.from(friendsData.listOfFriendRequestsSent);
  }

  @override
  Widget build(BuildContext context) {
    filteredUsers.sort((a, b) => a.name.compareTo(b.name));

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Add Friends'),
          backgroundColor: const Color(0xffFEAA1B),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Search Friends'),
              Tab(text: 'Request Pending'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      onChanged: _filterUsers,
                      decoration: InputDecoration(
                        labelText: 'Search for Friends',
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  ListView.separated(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: filteredUsers.length,
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.black,
                      thickness: 1.0,
                    ),
                    itemBuilder: (context, index) {
                      UserData user = filteredUsers[index];
                      // search friend tab
                      return GestureDetector(
                        onTap: () {
                          _showProfilePopup(user);
                        },
                        child: ListTile(
                          contentPadding: EdgeInsets.all(10.0),
                          leading: CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage(user.profilePic),
                          ),
                          title: Text(
                            '${user.name}',
                            style: TextStyle(fontSize: 18.0),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'UID: #${user.uid.substring(user.uid.length - 4)}',
                                style: TextStyle(fontSize: 14.0),
                              ),
                              Text(
                                user.headLine,
                                style: TextStyle(fontSize: 14.0),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            FutureBuilder<List<Friends>>(
              future: _getFriendRequestsSent(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  List<Friends> friendRequestsSent = snapshot.data!;
                  List<UserData> pendingRequestsUsers = widget.users
                      .where((user) => friendRequestsSent
                          .any((friend) => friend.uid == user.uid))
                      .toList();
                  return ListView.separated(
                    itemCount: pendingRequestsUsers.length,
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.black,
                      thickness: 1.0,
                    ),
                    itemBuilder: (context, index) {
                      UserData user = pendingRequestsUsers[index];
                      // pending request tab
                      return GestureDetector(
                          onTap: () {
                            _removeRequest(user);
                          },
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10.0),
                            leading: CircleAvatar(
                              radius: 30.0,
                              backgroundImage: NetworkImage(user.profilePic),
                            ),
                            title: Text(
                              '${user.name}',
                              style: TextStyle(fontSize: 18.0),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'UID: #${user.uid.substring(user.uid.length - 4)}',
                                  style: TextStyle(fontSize: 14.0),
                                ),
                                Text(
                                  user.headLine,
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ],
                            ),
                          ));
                    },
                  );
                } else {
                  return Center(child: Text('No pending friend requests.'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
