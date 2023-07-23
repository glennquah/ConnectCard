import 'package:connectcard/models/TheUser.dart';
import 'package:flutter/material.dart';

// Popup widget to show the user's profile and to add user as friend
class ProfilePopup extends StatelessWidget {
  final UserData user;
  final VoidCallback onAddFriend;

  const ProfilePopup(
      {super.key, required this.user, required this.onAddFriend});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Add ${user.name} as a friend?",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage(user.profilePic),
            backgroundColor: Colors.grey,
            child: user.profilePic.isNotEmpty
                ? null
                : const Icon(
                    Icons.person,
                    size: 30.0,
                    color: Colors.white,
                  ),
          ),
          const SizedBox(height: 16.0),
          Text(
            '${user.name} #${user.uid.substring(user.uid.length - 4)}',
            style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Text(
            user.headLine,
            style: const TextStyle(fontSize: 14.0, color: Colors.grey),
          ),
          const SizedBox(height: 24.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  onAddFriend();
                  Navigator.pop(context);
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('Friend request sent to ${user.name}.'),
                            const SizedBox(height: 16.0),
                            CircleAvatar(
                              radius: 30.0,
                              backgroundImage: NetworkImage(user.profilePic),
                              backgroundColor: Colors.grey,
                              child: user.profilePic.isNotEmpty
                                  ? null
                                  : const Icon(
                                      Icons.person,
                                      size: 30.0,
                                      color: Colors.white,
                                    ),
                            ),
                            const SizedBox(height: 16.0),
                            Text(
                              '${user.name} #${user.uid.substring(user.uid.length - 4)}',
                              style: const TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8.0),
                            Text(
                              user.headLine,
                              style: const TextStyle(
                                  fontSize: 14.0, color: Colors.grey),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Add Friend'),
              ),
              const SizedBox(width: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
