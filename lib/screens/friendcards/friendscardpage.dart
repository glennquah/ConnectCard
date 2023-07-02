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
  final List<String> friends = [
    'John',
    'Alice',
    'Bob',
    'Emily',
    'David',
    'Sarah',
  ];
  List<String> filteredFriends = [];

  @override
  void initState() {
    super.initState();
    filteredFriends = List.from(friends);
  }

  void filterFriends(String query) {
    setState(() {
      filteredFriends = friends
          .where((friend) => friend.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    TheUser? user;
    user = Provider.of<TheUser?>(context);
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user!.uid).userProfile,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData? userData = snapshot.data;
          return Scaffold(
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
                    builder: (context) => AddFriendsPage(users: users),
                  ),
                );
              },
              child: Icon(Icons.add),
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: filterFriends,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Your Friends',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredFriends.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredFriends[index]),
                        // Add more information about each friend if needed
                        // subtitle: Text('Friend details'),
                        // trailing: Icon(Icons.arrow_forward),
                        // onTap: () {
                        //   // Handle friend tap
                        // },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
