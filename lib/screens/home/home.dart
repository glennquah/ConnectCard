import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[800],
      appBar: AppBar(
        //change to user ID using user obj
        title: Text('abc'),
        backgroundColor: Colors.yellow[800],
        elevation: 0.0,
        actions: <Widget>[
          ElevatedButton.icon(
            onPressed: () async {
              //go to edit page
            },
            icon: Icon(
              Icons.edit,
              color: Colors.black,
              size: 24.0,
            ),
            label: Text('Edit'),
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