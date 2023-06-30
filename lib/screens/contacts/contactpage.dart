import 'package:connectcard/models/theUser.dart';
import 'package:connectcard/services/database.dart';
import 'package:connectcard/shared/loading.dart';
import 'package:connectcard/shared/navigationbar.dart';
import 'package:connectcard/shared/profilebar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ContactPage class
class ContactPage extends StatelessWidget {
  final List<String> friends = [
    'John',
    'Alice',
    'Bob',
    'Emily',
    'David',
    'Sarah',
  ];

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
            body: ListView.builder(
              itemCount: friends.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(friends[index]),
                  // Add more information about each friend if needed
                  // subtitle: Text('Friend details'),
                  // trailing: Icon(Icons.arrow_forward),
                  // onTap: () {
                  //   // Handle friend tap
                  // },
                );
              },
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
