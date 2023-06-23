import 'package:connectcard/shared/navigationbar.dart';
import 'package:flutter/material.dart';

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
    return Scaffold(
      //appBar: ProfileBar(userData: userData),
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
  }
}
