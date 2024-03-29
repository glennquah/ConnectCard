import 'package:connectcard/models/TheUser.dart';
import 'package:flutter/material.dart';

// This class is used to display the profile bar
class ProfileBar extends StatelessWidget implements PreferredSizeWidget {
  final UserData userData;

  const ProfileBar({super.key, required this.userData});

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
              style: const TextStyle(
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
            userData.profilePic.isNotEmpty ? userData.profilePic : '',
          ),
          backgroundColor: Colors.grey,
          child: userData.profilePic.isNotEmpty
              ? ClipOval(
                  child: Image.network(
                    userData.profilePic,
                    width: 60.0,
                    height: 60.0,
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(
                  Icons.person,
                  size: 30.0,
                  color: Colors.white,
                ),
        ),
      ),
      backgroundColor: bgColor,
      elevation: 0.0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
