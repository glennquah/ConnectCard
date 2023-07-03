import 'package:connectcard/models/Friends.dart';
import 'package:connectcard/models/FriendsDatabase.dart';
import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/screens/friendcards/addfriendspage.dart';
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
  //to be displayed under friends tab
  List<UserData> myFriends = [];
  //to be displayed under friend requests tab
  List<UserData> pendingRequests = [];
  //for search history
  List<UserData> filteredFriends = [];

  //to toggle between friends and friend requests
  bool showFriends = true;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  //fetches data from database
  Future<void> fetchData() async {
    TheUser? user = Provider.of<TheUser?>(context, listen: false);
    DatabaseService databaseService = DatabaseService(uid: user!.uid);
    //get all users except current user
    List<UserData> users = await databaseService.getAllUsersExceptCurrent();
    FriendsData friendsData = await databaseService.friendData.first;
    //get friend requests that has been received
    List<Friends> friendRequestsRec =
        List.from(friendsData.listOfFriendRequestsRec);
    //get list of friends
    List<Friends> myfriendsList = List.from(friendsData.listOfFriends);
    //go thru all the users & filter out the list of friends details based on the req & friends list
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
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                          Tab(text: 'Friend Requests'),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        TabBarView(
                          children: [
                            ListView.builder(
                              itemCount: myFriends.length,
                              itemBuilder: (context, index) {
                                UserData friend = myFriends[index];
                                return ListTile(
                                  title: Text(friend.name),
                                  // Add more information about the friend here
                                );
                              },
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
                                            // Handle accept button press for this request
                                          },
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.green),
                                          child: Text('Accept'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            // Remove Friend from PERSONAL friendrequestrec
                                            DatabaseService databaseService =
                                                DatabaseService(uid: user.uid);
                                            FriendsData friendsData =
                                                await databaseService
                                                    .friendData.first;
                                            List<Friends> friendRequestsRec =
                                                List.from(friendsData
                                                    .listOfFriendRequestsRec);
                                            friendRequestsRec.removeWhere(
                                                (friend) =>
                                                    friend.uid == request.uid);
                                            await databaseService
                                                .updateFriendDatabase(
                                              friendsData.listOfFriends,
                                              friendsData
                                                  .listOfFriendRequestsSent,
                                              friendRequestsRec,
                                              friendsData
                                                  .listOfFriendsPhysicalCard,
                                            );

                                            // Remove req from friends sent req
                                            DatabaseService
                                                databaseServiceFriend =
                                                DatabaseService(
                                                    uid: request.uid);
                                            FriendsData friendsDataFriend =
                                                await databaseServiceFriend
                                                    .friendData.first;
                                            List<Friends> friendRequestsSent =
                                                List.from(friendsDataFriend
                                                    .listOfFriendRequestsSent);
                                            friendRequestsSent.removeWhere(
                                                (friend) =>
                                                    friend.uid == user.uid);
                                            await databaseServiceFriend
                                                .updateFriendDatabase(
                                              friendsDataFriend.listOfFriends,
                                              friendRequestsSent,
                                              friendsDataFriend
                                                  .listOfFriendRequestsRec,
                                              friendsDataFriend
                                                  .listOfFriendsPhysicalCard,
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                              primary: Colors.red),
                                          child: Text('Decline'),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                      // Add this line
                                      color: Colors.black,
                                      thickness: 1.0,
                                    ),
                                  ],
                                );
                              },
                            ),
                          ],
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
