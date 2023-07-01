import 'package:connectcard/models/TheUser.dart';
import 'package:flutter/material.dart';

class AddFriendsPage extends StatefulWidget {
  final List<UserData> users;

  AddFriendsPage({required this.users});

  @override
  _AddFriendsPageState createState() => _AddFriendsPageState();
}

class _AddFriendsPageState extends State<AddFriendsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Friends'),
      ),
      body: ListView.builder(
        itemCount: widget.users.length,
        itemBuilder: (context, index) {
          UserData user = widget.users[index];
          return ListTile(
            title: Text(user.name),
          );
        },
      ),
    );
  }
}
