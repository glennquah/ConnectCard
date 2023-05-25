import 'package:connectcard/services/auth.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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