import 'package:connectcard/models/Friends.dart';
import 'package:connectcard/models/FriendsDatabase.dart';
import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/screens/friendcards/addfriendspage.dart';
import 'package:connectcard/screens/friendcards/friendcards.dart';
import 'package:connectcard/services/database.dart';
import 'package:connectcard/shared/loading.dart';
import 'package:connectcard/shared/navigationbar.dart';
import 'package:connectcard/shared/profilebar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FriendsCardsPage extends StatefulWidget {
  @override
  _FriendsCardsPageState createState() => _FriendsCardsPageState();
}

class _FriendsCardsPageState extends State<FriendsCardsPage> {
  List<UserData> myFriends = [];
  List<UserData> pendingRequests = [];
  List<UserData> filteredFriends = [];
  bool showFriends = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void _filterUsers(String query) async {
    setState(() {
      filteredFriends = [];
    });

    List<UserData> dummySearchList = [];

    for (UserData user in myFriends) {
      if (user.name.toLowerCase().contains(query.toLowerCase()) ||
          user.headLine.toLowerCase().contains(query.toLowerCase()) ||
          user.uid.toLowerCase().contains(query.toLowerCase())) {
        dummySearchList.add(user);
      }
    }
    //to rebuild the user interface
    setState(() {
      filteredFriends = dummySearchList;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> fetchData() async {
    TheUser? user = Provider.of<TheUser?>(context, listen: false);
    if (user != null) {
      DatabaseService databaseService = DatabaseService(uid: user.uid);
      List<UserData> users = await databaseService.getAllUsersExceptCurrent();

      // Listen to changes in friend data stream
      databaseService.friendData.listen((friendsData) {
        List<Friends> friendRequestsRec =
            List.from(friendsData.listOfFriendRequestsRec);
        List<Friends> myfriendsList = List.from(friendsData.listOfFriends);
        setState(() {
          pendingRequests = users
              .where((friend) =>
                  friendRequestsRec.any((request) => request.uid == friend.uid))
              .toList();
          myFriends = users
              .where((friend) =>
                  myfriendsList.any((myFriend) => myFriend.uid == friend.uid))
              .toList();
        });
      });
    }
  }

  Future<void> handleDecline(UserData request) async {
    TheUser? user = Provider.of<TheUser?>(context, listen: false);
    DatabaseService databaseService = DatabaseService(uid: user!.uid);

    // Remove Friend from PERSONAL friendrequestrec
    FriendsData friendsData = await databaseService.friendData.first;
    List<Friends> friendRequestsRec =
        List.from(friendsData.listOfFriendRequestsRec);
    friendRequestsRec.removeWhere((friend) => friend.uid == request.uid);
    await databaseService.updateFriendDatabase(
      friendsData.listOfFriends,
      friendsData.listOfFriendRequestsSent,
      friendRequestsRec,
      friendsData.listOfFriendsPhysicalCard,
    );

    // Remove req from friend's sent requests
    DatabaseService databaseServiceFriend = DatabaseService(uid: request.uid);
    FriendsData friendsDataFriend =
        await databaseServiceFriend.friendData.first;
    List<Friends> friendRequestsSent =
        List.from(friendsDataFriend.listOfFriendRequestsSent);
    friendRequestsSent.removeWhere((friend) => friend.uid == user.uid);
    await databaseServiceFriend.updateFriendDatabase(
      friendsDataFriend.listOfFriends,
      friendRequestsSent,
      friendsDataFriend.listOfFriendRequestsRec,
      friendsDataFriend.listOfFriendsPhysicalCard,
    );

    setState(() {
      // Update the UI by removing the declined request from the pendingRequests list
      pendingRequests.remove(request);
    });
  }

  Future<void> handleAccept(UserData request) async {
    TheUser? user = Provider.of<TheUser?>(context, listen: false);
    DatabaseService databaseService = DatabaseService(uid: user!.uid);

    // Remove Friend from PERSONAL friendrequestrec
    FriendsData friendsData = await databaseService.friendData.first;
    List<Friends> friendRequestsRec =
        List.from(friendsData.listOfFriendRequestsRec);
    friendRequestsRec.removeWhere((friend) => friend.uid == request.uid);
    List<Friends> friendlist = List.from(friendsData.listOfFriends)
      ..add(Friends(uid: request.uid));
    await databaseService.updateFriendDatabase(
      friendlist,
      friendsData.listOfFriendRequestsSent,
      friendRequestsRec,
      friendsData.listOfFriendsPhysicalCard,
    );

    // Remove req from friend's sent requests
    DatabaseService databaseServiceFriend = DatabaseService(uid: request.uid);
    FriendsData friendsDataFriend =
        await databaseServiceFriend.friendData.first;
    List<Friends> friendRequestsSent =
        List.from(friendsDataFriend.listOfFriendRequestsSent);
    friendRequestsSent.removeWhere((friend) => friend.uid == user.uid);
    List<Friends> friendlistFriend = List.from(friendsDataFriend.listOfFriends)
      ..add(Friends(uid: user.uid));
    await databaseServiceFriend.updateFriendDatabase(
      friendlistFriend,
      friendRequestsSent,
      friendsDataFriend.listOfFriendRequestsRec,
      friendsDataFriend.listOfFriendsPhysicalCard,
    );

    setState(() {
      // Update the UI by removing the declined request from the pendingRequests list
      pendingRequests.remove(request);
      myFriends.add(request);
    });
  }

  @override
  Widget build(BuildContext context) {
    filteredFriends.sort((a, b) => a.name.compareTo(b.name));
    TheUser? user = Provider.of<TheUser?>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user!.uid).userProfile,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData? userData = snapshot.data;
          return DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: ProfileBar(userData: userData!),
              backgroundColor: Colors.yellow[800],
              bottomNavigationBar: NaviBar(currentIndex: 3),
              floatingActionButton: FloatingActionButton(
                onPressed: () async {
                  DatabaseService databaseService =
                      DatabaseService(uid: user!.uid);
                  List<UserData> users =
                      await databaseService.getAllUsersExceptCurrent();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          AddFriendsPage(users: users, uid: user!.uid),
                    ),
                  );
                },
                child: Icon(Icons.add),
              ),
              body: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: TabBar(
                        onTap: (index) {
                          setState(() {
                            showFriends = index == 0;
                          });
                        },
                        tabs: [
                          Tab(text: 'Friends'),
                          if (pendingRequests.isEmpty)
                            Tab(text: 'Friend Requests')
                          else
                            Tab(
                              child: Text(
                                '${pendingRequests.length} Friend Requests',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                onChanged: _filterUsers,
                                controller: _searchController,
                                decoration: InputDecoration(
                                  labelText: 'Search for Friends',
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.separated(
                                shrinkWrap: true,
                                itemCount: filteredFriends.isNotEmpty
                                    ? filteredFriends.length
                                    : myFriends
                                        .length, // Display myFriends if filteredFriends is empty
                                separatorBuilder: (context, index) => Divider(
                                  color: Colors.black,
                                  thickness: 1.0,
                                ),
                                itemBuilder: (context, index) {
                                  UserData friend;
                                  if (filteredFriends.isNotEmpty) {
                                    friend = filteredFriends[index];
                                  } else {
                                    friend = myFriends[index];
                                  }
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FriendCards(
                                            userData: friend,
                                            cards: friend.listOfCards,
                                          ),
                                        ),
                                      );
                                    },
                                    child: ListTile(
                                      contentPadding: EdgeInsets.all(10.0),
                                      leading: CircleAvatar(
                                        radius: 30.0,
                                        backgroundColor: Colors.grey,
                                        backgroundImage: friend
                                                .profilePic.isNotEmpty
                                            ? NetworkImage(friend.profilePic)
                                            : null,
                                        child: friend.profilePic.isNotEmpty
                                            ? null // If profilePic is available, don't display a child
                                            : Icon(
                                                Icons.person,
                                                size: 30.0,
                                                color: Colors.white,
                                              ),
                                      ),
                                      title: Text(
                                        '${friend.name}',
                                        style: TextStyle(fontSize: 18.0),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'UID: #${friend.uid.substring(friend.uid.length - 4)}',
                                            style: TextStyle(fontSize: 14.0),
                                          ),
                                          Text(
                                            friend.headLine,
                                            style: TextStyle(fontSize: 14.0),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        ListView.builder(
                          itemCount: pendingRequests.length,
                          itemBuilder: (context, index) {
                            UserData request = pendingRequests[index];
                            return Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.all(10.0),
                                  leading: CircleAvatar(
                                    radius: 30.0,
                                    backgroundImage:
                                        NetworkImage(request.profilePic),
                                    backgroundColor: Colors
                                        .grey, // Set a background color for the avatar
                                    child: request.profilePic.isNotEmpty
                                        ? null // If profilePic is available, don't display a child
                                        : Icon(
                                            Icons.person,
                                            size: 30.0,
                                            color: Colors.white,
                                          ),
                                  ),
                                  title: Text(
                                    '${request.name}',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'UID: #${request.uid.substring(request.uid.length - 4)}',
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                      Text(
                                        request.headLine,
                                        style: TextStyle(fontSize: 14.0),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        handleAccept(request);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.green,
                                      ),
                                      child: Text('Accept'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        handleDecline(request);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.red,
                                      ),
                                      child: Text('Decline'),
                                    ),
                                  ],
                                ),
                                Divider(
                                  color: Colors.black,
                                  thickness: 1.0,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
