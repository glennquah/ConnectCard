import 'package:connectcard/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Home extends StatelessWidget {
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: GNav(
            backgroundColor: Colors.white,
            color: Colors.black,
            activeColor: Colors.white,
            tabBackgroundColor: Colors.grey.shade800,
            gap: 20,
            padding: const EdgeInsets.all(16),
            tabs: const [
              GButton(icon: Icons.home, text: 'Home'),
              GButton(icon: Icons.camera, text: 'Scan'),
              GButton(icon: Icons.card_giftcard, text: 'My Cards'),
              GButton(icon: Icons.people, text: 'Contacts'),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.yellow[800],
      appBar: AppBar(
        title: Text('UserName'),
        backgroundColor: Colors.yellow[800],
        elevation: 0.0,
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person),
            label: Text('Logout'),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
    );
  }
}


  //when pressed the edit button then has this button to sign out
  /*
  on the top add
  import auth.dart
  final Auth _auth = Auth();

  FlatButton.icon(
    icon: Icon(Icons.person),
    label: Text('logout'),
    onPressed: () async {
      await _auth.signOut();
    },
  )


  */