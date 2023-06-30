import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/Friends.dart';
import 'package:connectcard/models/TheUser.dart';

// This class is used to update the user's data in the database
class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  // Collection reference
  final CollectionReference profileCollection =
      FirebaseFirestore.instance.collection('profile');

  Future<void> updateUserData(
      String name,
      String headLine,
      String profilePic,
      List<Cards> listOfCards,
      List<Friends> listOfFriends,
      List<Friends> listOfFriendRequests) async {
    final cardsData = listOfCards.map((card) => card.toJson()).toList();
    final friendsData = listOfFriends.map((friend) => friend.toJson()).toList();
    final friendRequestsData =
        listOfFriendRequests.map((friend) => friend.toJson()).toList();

    await profileCollection.doc(uid).set({
      'name': name,
      'headLine': headLine,
      'profilePic': profilePic,
      'cards': cardsData,
      'friends': friendsData,
      'friendRequests': friendRequestsData,
    });
  }

  // Get card list from snapshot
  List<Cards> _cardListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Cards(
        imageUrl: doc['imageUrl'] ?? '', // Replace with the actual image file
        cardName: doc['companyName'] ?? '',
        companyName: doc['companyName'] ?? '',
        jobTitle: doc['jobTitle'] ?? '',
        phoneNum: doc['phoneNum'] ?? '',
        email: doc['email'] ?? '',
        companyWebsite: doc['companyWebsite'] ?? '',
        companyAddress: doc['companyAddress'] ?? '',
        personalStatement: doc['personalStatement'] ?? '',
        moreInfo: doc['moreInfo1'] ?? '',
      );
    }).toList();
  }

  List<Friends> _friendListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Friends(
        uid: doc['uid'] ?? '',
      );
    }).toList();
  }

  List<Friends> _friendRequestListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Friends(
        uid: doc['uid'] ?? '',
      );
    }).toList();
  }

  // UserData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot['name'],
      headLine: snapshot['headLine'],
      profilePic: snapshot['profilePic'],
      listOfCards: List<Cards>.from(
        (snapshot['cards'] as List<dynamic> ?? []).map(
          (card) => Cards(
            imageUrl:
                card['imageUrl'] ?? '', // Replace with the actual image file
            cardName: card['cardName'] ?? '',
            companyName: card['companyName'] ?? '',
            jobTitle: card['jobTitle'] ?? '',
            phoneNum: card['phoneNum'] ?? '',
            email: card['email'] ?? '',
            companyWebsite: card['companyWebsite'] ?? '',
            companyAddress: card['companyAddress'] ?? '',
            personalStatement: card['personalStatement'] ?? '',
            moreInfo: card['moreInfo1'] ?? '',
          ),
        ),
      ),
      listOfFriends: List<Friends>.from(
        (snapshot['friends'] as List<dynamic> ?? []).map(
          (friend) => Friends(
            uid: friend['uid'] ?? '',
          ),
        ),
      ),
      listOfFriendRequests: List<Friends>.from(
        (snapshot['friendRequests'] as List<dynamic> ?? []).map(
          (friend) => Friends(
            uid: friend['uid'] ?? '',
          ),
        ),
      ),
    );
  }

  Future<List<UserData>> getAllUsers() async {
    QuerySnapshot snapshot = await profileCollection.get();
    return snapshot.docs.map((doc) => _userDataFromSnapshot(doc)).toList();
  }

  // get cards stream
  Stream<List<Cards>> get cardList {
    return profileCollection.snapshots().map(_cardListFromSnapshot);
  }

  // get friends stream
  Stream<List<Friends>> get friendList {
    return profileCollection.snapshots().map(_friendListFromSnapshot);
  }

  // get friend requests stream
  Stream<List<Friends>> get friendRequestList {
    return profileCollection.snapshots().map(_friendRequestListFromSnapshot);
  }

  // get user profile stream
  // to get the object of the user profile
  Stream<UserData> get userProfile {
    return profileCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }

  String get userId {
    return uid;
  }
}
