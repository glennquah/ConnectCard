import 'package:connectcard/models/theUser.dart';
import 'package:flutter/material.dart';

class ProfileBar extends StatelessWidget implements PreferredSizeWidget {
  final UserData userData;

  ProfileBar({required this.userData});

  @override
  Widget build(BuildContext context) {
    Color bgColor = const Color(0xffFEAA1B);

    return AppBar(
      title: TextButton(
        onPressed: () {
          Navigator.pushNamed(context, '/profile');
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              userData.name,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.0,
              ),
            ),
            Text(
              'View Profile',
              style: TextStyle(
                color: Colors.green[800],
                fontSize: 14.0,
              ),
            ),
          ],
        ),
      ),
      leading: Padding(
        padding: const EdgeInsets.all(5.0),
        child: CircleAvatar(
          radius: 15.0,
          backgroundImage: NetworkImage(
            userData.listOfCards.isNotEmpty &&
                    userData.listOfCards.first.imageUrl.isNotEmpty
                ? userData.listOfCards.first.imageUrl
                : '',
          ),
          backgroundColor: Colors.white,
          child: userData.listOfCards.isNotEmpty &&
                  userData.listOfCards.first.imageUrl.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    userData.listOfCards.first.imageUrl,
                    width: 60.0,
                    height: 60.0,
                    fit: BoxFit.cover,
                  ),
                )
              : Icon(
                  Icons.add,
                  size: 40.0,
                  color: Colors.black,
                ),
        ),
      ),
      backgroundColor: bgColor,
      elevation: 0.0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
