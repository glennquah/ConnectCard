import 'package:connectcard/models/Friends.dart';
import 'package:connectcard/models/FriendsDatabase.dart';
import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/services/database.dart';
import 'package:connectcard/shared/profile_popup.dart';
import 'package:flutter/material.dart';

// This class is used to add friends
// 2 tabs: search friends which shows list of users using connectcard and pending requests
class AddFriendsPage extends StatefulWidget {
  final List<UserData> users;
  final String uid;

  const AddFriendsPage({super.key, required this.users, required this.uid});

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
      // Check if the user is not already requested or a friend and matches the query
      if (!isRequested &&
          !filteredUsers.contains(user) &&
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
  void _addFriend(UserData user) async {
    // Add Friend into PERSONAL friendrequestsent
    DatabaseService databaseService = DatabaseService(uid: widget.uid);
    FriendsData friendsData = await databaseService.friendData.first;
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
    DatabaseService databaseServiceFriend = DatabaseService(uid: user.uid);
    FriendsData friendsDataFriend =
        await databaseServiceFriend.friendData.first;
    List<Friends> friendRequestsReceived =
        List.from(friendsDataFriend.listOfFriendRequestsRec);

    // Check if the user is not already a friend, then add to friendRequestsReceived
    bool isFriend = friendsDataFriend.listOfFriends
        .any((friend) => friend.uid == widget.uid);
    if (!isFriend) {
      friendRequestsReceived.add(Friends(uid: widget.uid));
      await databaseServiceFriend.updateFriendDatabase(
        friendsDataFriend.listOfFriends,
        friendsDataFriend.listOfFriendRequestsSent,
        friendRequestsReceived,
        friendsDataFriend.listOfFriendsPhysicalCard,
      );
    }

    // Refresh filtered users list to show changes
    _initializeFilteredUsers();
  }

  //popup to remove friend request
  void _removeRequest(UserData user) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Remove friend request for ${user.name}?",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16.0),
              CircleAvatar(
                radius: 30.0,
                backgroundImage: NetworkImage(user.profilePic),
                backgroundColor: Colors.grey,
                child: user.profilePic.isNotEmpty
                    ? null
                    : const Icon(
                        Icons.person,
                        size: 30.0,
                        color: Colors.white,
                      ),
              ),
              const SizedBox(height: 16.0),
              Text(
                '${user.name} #${user.uid.substring(user.uid.length - 4)}',
                style: const TextStyle(
                    fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),
              Text(
                user.headLine,
                style: const TextStyle(fontSize: 14.0, color: Colors.grey),
              ),
              const SizedBox(height: 24.0),
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
                    child: const Text('Remove Request'),
                  ),
                  const SizedBox(width: 16.0),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
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
          title: const Text('Add Friends'),
          backgroundColor: const Color(0xffFEAA1B),
          bottom: const TabBar(
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
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                    ),
                  ),
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredUsers.length,
                    separatorBuilder: (context, index) => const Divider(
                      color: Colors.black,
                      thickness: 1.0,
                    ),
                    itemBuilder: (context, index) {
                      UserData user = filteredUsers[index];
                      // search friend tab
                      return GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => ProfilePopup(
                              user: user,
                              onAddFriend: () => _addFriend(user),
                            ),
                          );
                        },
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(10.0),
                          leading: CircleAvatar(
                            radius: 30.0,
                            backgroundImage: NetworkImage(user.profilePic),
                            backgroundColor: Colors.grey,
                            child: user.profilePic.isNotEmpty
                                ? null
                                : const Icon(
                                    Icons.person,
                                    size: 30.0,
                                    color: Colors.white,
                                  ),
                          ),
                          title: Text(
                            '${user.name}',
                            style: const TextStyle(fontSize: 18.0),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'UID: #${user.uid.substring(user.uid.length - 4)}',
                                style: const TextStyle(fontSize: 14.0),
                              ),
                              Text(
                                user.headLine,
                                style: const TextStyle(fontSize: 14.0),
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
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasData) {
                  List<Friends> friendRequestsSent = snapshot.data!;
                  List<UserData> pendingRequestsUsers = widget.users
                      .where((user) => friendRequestsSent
                          .any((friend) => friend.uid == user.uid))
                      .toList();
                  return ListView.separated(
                    itemCount: pendingRequestsUsers.length,
                    physics: const NeverScrollableScrollPhysics(),
                    separatorBuilder: (context, index) => const Divider(
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
                            contentPadding: const EdgeInsets.all(10.0),
                            leading: CircleAvatar(
                              radius: 30.0,
                              backgroundImage: NetworkImage(user.profilePic),
                              backgroundColor: Colors.grey,
                              child: user.profilePic.isNotEmpty
                                  ? null
                                  : const Icon(
                                      Icons.person,
                                      size: 30.0,
                                      color: Colors.white,
                                    ),
                            ),
                            title: Text(
                              '${user.name}',
                              style: const TextStyle(fontSize: 18.0),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'UID: #${user.uid.substring(user.uid.length - 4)}',
                                  style: const TextStyle(fontSize: 14.0),
                                ),
                                Text(
                                  user.headLine,
                                  style: const TextStyle(fontSize: 14.0),
                                ),
                              ],
                            ),
                          ));
                    },
                  );
                } else {
                  return const Center(
                      child: Text('No pending friend requests.'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
