import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/profile/editprofilepage.dart';
import 'package:connectcard/screens/authenticate/authenticate.dart';
import 'package:connectcard/services/database.dart';
import 'package:connectcard/shared/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    TheUser? user;
    user = Provider.of<TheUser?>(context);

    Color bgColor = const Color(0xffFEAA1B);

    if (user == null) {
      // User is not logged in, show a different UI
      return Authenticate(); // Replace with your login screen widget
    }

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user!.uid).userProfile,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData? userData = snapshot.data;
          return Scaffold(
            backgroundColor: bgColor,
            appBar: AppBar(
              title: Text('View Profile'),
              backgroundColor: const Color(0xffFEAA1B),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.grey,
                    backgroundImage: userData!.profilePic.isNotEmpty
                        ? NetworkImage(userData.profilePic)
                        : null,
                    child: userData.profilePic.isEmpty
                        ? Icon(Icons.person, size: 60, color: Colors.white)
                        : null,
                  ),
                  SizedBox(height: 20),
                  Text(
                    userData.name,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'UID: #${user?.uid?.substring(user.uid.length - 4) ?? ''}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    userData.headLine,
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 40),
                  SizedBox(
                    width: 200,
                    child: OvalButton(
                      icon: Icons.person,
                      label: 'Edit Profile',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    child: OvalButton(
                      icon: Icons.mail,
                      label: 'Contact Us',
                      onPressed: () {
                        _showContactOptions(context, userData);
                      },
                    ),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: 200,
                    child: OvalButton(
                      icon: Icons.logout,
                      label: 'Log Out',
                      onPressed: () async {
                        FirebaseAuth auth = FirebaseAuth.instance;
                        try {
                          await auth.signOut();
                          print('User signed out successfully.');
                        } catch (e) {
                          print('Error signing out: $e');
                        }
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

  void _showContactOptions(BuildContext context, UserData userData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Contact Method'),
          content: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.mail, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                    _sendEmail(context, userData);
                  },
                ),
              ),
              Expanded(
                child: IconButton(
                  icon: Icon(Icons.phone, size: 30),
                  onPressed: () {
                    Navigator.pop(context);
                    _makePhoneCall(context, userData);
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _sendEmail(BuildContext context, UserData userData) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'connectcard.customerservice@gmail.com',
      query: encodeQueryParameters(<String, String>{
        'subject': 'Help Required from User: ${userData.name}',
        'body': 'Dear customer service,\n\n',
      }),
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No email client found'),
        ),
      );
    }
  }

  void _makePhoneCall(BuildContext context, UserData userData) async {
    final Uri phoneUrl = Uri(scheme: 'tel', path: '87534510');
    if (await canLaunchUrl(phoneUrl)) {
      await launchUrl(phoneUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Phone app not found'),
        ),
      );
    }
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
