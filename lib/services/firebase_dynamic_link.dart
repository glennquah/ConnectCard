import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/services/database.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/Friends.dart';
import '../models/FriendsDatabase.dart';
import '../screens/friendcards/friendscardpage.dart';

FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

class FirebaseDynamicLinkService {
  static Future<String> createDynamicLink(UserData userData) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://connectcard.page.link',
      link: Uri.parse('https://connectcard.page.link/Zi7X/${userData.uid}'),
      androidParameters: AndroidParameters(
        packageName: 'com.example.connectcard',
        minimumVersion: 30,
      ),
    );

    final Uri dynamicLongLink =
        await FirebaseDynamicLinks.instance.buildLink(parameters);
    final String longLink = dynamicLongLink.toString();

    return longLink;
  }

  static Future<void> initDynamicLink(BuildContext context) async {
    print('initDynamicLink');
    FirebaseDynamicLinks.instance.onLink.listen((dynamicLink) async {
      final Uri? deepLink = dynamicLink?.link;

      var isIn = deepLink?.pathSegments.contains('Zi7X');

      if (isIn != null && isIn) {
        print('check');
        String id = deepLink!.pathSegments.last;

        try {
          print('check1');
          TheUser? user = Provider.of<TheUser?>(context, listen: false);
          if (user != null) {
            DatabaseService databaseService = DatabaseService(uid: user.uid);

            // Add sender's UID to the user's friend list
            FriendsData friendsData = await databaseService.friendData.first;
            List<Friends> friendlist = List.from(friendsData.listOfFriends)
              ..add(Friends(uid: id));
            await databaseService.updateFriendDatabase(
              friendlist,
              friendsData.listOfFriendRequestsSent,
              friendsData.listOfFriendRequestsRec,
              friendsData.listOfFriendsPhysicalCard,
            );

            // Add user's UID to the sender's friend list
            DatabaseService databaseServiceSender = DatabaseService(uid: id);
            FriendsData friendsDataSender =
                await databaseServiceSender.friendData.first;
            List<Friends> friendlistSender =
                List.from(friendsDataSender.listOfFriends)
                  ..add(Friends(uid: user.uid));
            await databaseServiceSender.updateFriendDatabase(
              friendlistSender,
              friendsDataSender.listOfFriendRequestsSent,
              friendsDataSender.listOfFriendRequestsRec,
              friendsDataSender.listOfFriendsPhysicalCard,
            );
            print('check2');
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FriendsCardsPage()),
            );
          } else {
            print('User not found');
          }
        } catch (e) {
          print('check3');
          print(e);
        }
      } else if (deepLink != null) {
        print('not in');
      } else {
        print('no link');
      }
    });
  }
}
