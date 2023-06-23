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
    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user!.uid).userProfile,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData? userData = snapshot.data;
          return Scaffold(
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 100),
                CircleAvatar(
                  radius: 80,
                  backgroundColor: Colors
                      .grey, // Set a default background color for the CircleAvatar
                  backgroundImage: userData!.listOfCards.isNotEmpty &&
                          userData.listOfCards[0].imageUrl.isNotEmpty
                      ? NetworkImage(userData.listOfCards[0].imageUrl)
                      : null,
                  child: userData.listOfCards.isEmpty ||
                          userData.listOfCards[0].imageUrl.isEmpty
                      ? Icon(Icons.add,
                          size: 60) // Display "+" icon if no image URL
                      : null,
                ),
                SizedBox(height: 20),
                Text(
                  userData.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OvalButton(
                      icon: Icons.mail,
                      label: 'Contact Us',
                      onPressed: () {
                        // Handle contact us button press
                      },
                    ),
                    OvalButton(
                      icon: Icons.settings,
                      label: 'Settings',
                      onPressed: () {
                        // Handle settings button press
                      },
                    ),
                    OvalButton(
                      icon: Icons.logout,
                      label: 'Log Out',
                      onPressed: () {
                        // Handle log out button press
                      },
                    ),
                  ],
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
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Icon(icon, size: 40),
            SizedBox(height: 8),
            Text(label, style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
