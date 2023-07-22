import 'package:connectcard/models/TheUser.dart';
import 'package:flutter/material.dart';

class ProfilePopup extends StatelessWidget {
  final UserData user;
  final VoidCallback onAddFriend;

  ProfilePopup({required this.user, required this.onAddFriend});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Add ${user.name} as a friend?",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          CircleAvatar(
            radius: 30.0,
            backgroundImage: NetworkImage(user.profilePic),
            backgroundColor: Colors.grey,
            child: user.profilePic.isNotEmpty
                ? null
                : Icon(
                    Icons.person,
                    size: 30.0,
                    color: Colors.white,
                  ),
          ),
          SizedBox(height: 16.0),
          Text(
            '${user.name} #${user.uid.substring(user.uid.length - 4)}',
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8.0),
          Text(
            user.headLine,
            style: TextStyle(fontSize: 14.0, color: Colors.grey),
          ),
          SizedBox(height: 24.0),
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
                            SizedBox(height: 16.0),
                            CircleAvatar(
                              radius: 30.0,
                              backgroundImage: NetworkImage(user.profilePic),
                              backgroundColor: Colors.grey,
                              child: user.profilePic.isNotEmpty
                                  ? null
                                  : Icon(
                                      Icons.person,
                                      size: 30.0,
                                      color: Colors.white,
                                    ),
                            ),
                            SizedBox(height: 16.0),
                            Text(
                              '${user.name} #${user.uid.substring(user.uid.length - 4)}',
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              user.headLine,
                              style:
                                  TextStyle(fontSize: 14.0, color: Colors.grey),
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Close'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Add Friend'),
              ),
              SizedBox(width: 16.0),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
