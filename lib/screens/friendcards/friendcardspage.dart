import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/services/database.dart';
import 'package:connectcard/shared/loading.dart';
import 'package:connectcard/shared/navigationbar.dart';
import 'package:connectcard/shared/profilebar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// FriendCardsPage class
class FriendCardsPage extends StatelessWidget {
  final List<String> rewardCards = [
    'acai',
    'mac',
    'soobway',
    'stuffd',
    'sbox',
    'cbtl',
  ];

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
            appBar: ProfileBar(userData: userData!),
            backgroundColor: bgColor,
            bottomNavigationBar: NaviBar(currentIndex: 2),
            body: ListView.builder(
              itemCount: rewardCards.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(rewardCards[index]),
                  // Add more information about each cards if needed
                  // subtitle: Text('rewardCards details'),
                  // trailing: Icon(Icons.arrow_forward),
                  // onTap: () {
                  //   // Handle rewardcards tap
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
