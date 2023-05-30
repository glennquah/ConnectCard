import 'package:connectcard/models/userDetails.dart';
import 'package:connectcard/screens/home/profile.dart';
import 'package:connectcard/services/auth.dart';
import 'package:connectcard/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    void _showCardsPanel() {
      showModalBottomSheet(
          context: context,
          builder: (context) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
              child: CardsForm(),
            );
          });
    }

    return StreamProvider<List<UserDetails>>.value(
      value: DatabaseService().profiles,
      child: Scaffold(
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
            TextButton.icon(
              icon: Icon(Icons.edit),
              label: Text('edit'),
              onPressed: () => _showCardsPanel(),
            )
          ],
        ),
        body: ProfileList(),
      ),
    );
  }
}
