import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddFriendsPage extends StatefulWidget {
  @override
  _AddFriendsPageState createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage> {
  TextEditingController searchController = TextEditingController();
  List<UserData> userList = [];
  List<UserData> filteredUserList = [];

  @override
  void initState() {
    super.initState();
    fetchUserList();
  }

  void fetchUserList() async {
    // Fetch the user list from the database
    TheUser? user = Provider.of<TheUser?>(context, listen: false);
    List<UserData> users = await DatabaseService(uid: user!.uid).getAllUsers();
    setState(() {
      userList = users;
      filteredUserList = users;
    });
  }

  void filterUsers(String query) {
    List<UserData> filteredUsers = [];
    if (query.isNotEmpty) {
      filteredUsers = userList.where((user) {
        final String lowercaseQuery = query.toLowerCase();
        final String lowercaseName = user.name.toLowerCase();
        return lowercaseName.contains(lowercaseQuery);
      }).toList();
    } else {
      filteredUsers = List.from(userList);
    }
    setState(() {
      filteredUserList = filteredUsers;
    });
  }

  Widget buildSearchResults() {
    if (filteredUserList.isEmpty) {
      return Center(
        child: Image.asset('assets/search.png', height: 300.0),
      );
    } else {
      return ListView.builder(
        itemCount: filteredUserList.length,
        itemBuilder: (context, index) {
          UserData user = filteredUserList[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(user.profilePic),
            ),
            title: Text(user.name),
            subtitle: Text(user.headLine),
            // Add more information about each user if needed
            // trailing: Icon(Icons.add),
            // onTap: () {
            //   // Handle user tap
            // },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Friends'),
        backgroundColor: Colors.yellow[800],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              onChanged: filterUsers,
              decoration: InputDecoration(
                labelText: 'Search for friends',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: buildSearchResults(),
          ),
        ],
      ),
    );
  }
}
