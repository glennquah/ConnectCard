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

  @override
  void initState() {
    super.initState();
    filteredUsers = widget.users;
  }

  void _filterUsers(String query) {
    setState(() {
      filteredUsers = widget.users
          .where((user) =>
              user.name.toLowerCase().contains(query.toLowerCase()) ||
              user.headLine.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _showProfilePopup(UserData user) {
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
                user.name,
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
                      DatabaseService databaseService =
                          DatabaseService(uid: widget.uid);
                      FriendsData friendsData =
                          await databaseService.friendData.first;
                      List<Friends> friendRequests =
                          List.from(friendsData.listOfFriendRequests);
                      friendRequests.add(Friends(uid: user.uid));
                      await databaseService.updateFriendDatabase(
                        friendsData.listOfFriends,
                        friendRequests,
                        friendsData.listOfFriendsPhysicalCard,
                      );
                      Navigator.pop(context);
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

  @override
  Widget build(BuildContext context) {
    filteredUsers
        .sort((a, b) => a.name.compareTo(b.name)); // Sort in alphabetical order

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Friends'),
        backgroundColor: const Color(0xffFEAA1B),
      ),
      body: SingleChildScrollView(
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
              physics:
                  NeverScrollableScrollPhysics(), // Disable scrolling of ListView
              shrinkWrap: true, // Wrap content inside ListView
              itemCount: filteredUsers.length,
              separatorBuilder: (context, index) => Divider(
                color: Colors.black,
                thickness: 1.0,
              ),
              itemBuilder: (context, index) {
                UserData user = filteredUsers[index];
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
                      user.name,
                      style: TextStyle(fontSize: 18.0),
                    ),
                    subtitle: Text(
                      user.headLine,
                      style: TextStyle(fontSize: 14.0),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
