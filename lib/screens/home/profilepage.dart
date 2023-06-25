import 'package:connectcard/models/theUser.dart';
import 'package:connectcard/services/database.dart';
import 'package:connectcard/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TheUser? user;
    user = Provider.of<TheUser?>(context);

    Color bgColor = const Color(0xffFEAA1B);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user!.uid).userProfile,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData? userData = snapshot.data;
          return Scaffold(
            backgroundColor: bgColor,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.grey,
                    backgroundImage: userData!.listOfCards.isNotEmpty &&
                            userData.listOfCards[0].imageUrl.isNotEmpty
                        ? NetworkImage(userData.listOfCards[0].imageUrl)
                        : null,
                    child: userData.listOfCards.isEmpty ||
                            userData.listOfCards[0].imageUrl.isEmpty
                        ? Icon(Icons.add, size: 60)
                        : null,
                  ),
                  SizedBox(height: 20),
                  Text(
                    userData.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 40),
                  SizedBox(
                    width: 200,
                    child: OvalButton(
                      icon: Icons.mail,
                      label: 'Contact Us',
                      onPressed: () {
                        // Handle contact us button press
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    child: OvalButton(
                      icon: Icons.settings,
                      label: 'Settings',
                      onPressed: () {
                        // Handle settings button press
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    child: OvalButton(
                      icon: Icons.logout,
                      label: 'Log Out',
                      onPressed: () {
                        // Handle log out button press
                      },
                    ),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}

class OvalButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  OvalButton(
      {required this.icon, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(vertical: 10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40),
          SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}
