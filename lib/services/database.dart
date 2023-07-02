import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/Friends.dart';
import 'package:connectcard/models/FriendsDatabase.dart';
import 'package:connectcard/models/TheUser.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  final CollectionReference profileCollection =
      FirebaseFirestore.instance.collection('profile');

  CollectionReference get friendCollection {
    return FirebaseFirestore.instance.collection('profile/$uid/friends');
  }

  Future<void> updateUserData(String name, String headLine, String profilePic,
      List<Cards> listOfCards) async {
    final cardsData = listOfCards.map((card) => card.toJson()).toList();

    await profileCollection.doc(uid).set({
      'name': name,
      'headLine': headLine,
      'profilePic': profilePic,
      'cards': cardsData,
    });
  }

  Future<void> updateFriendDatabase(
      List<Friends> listOfFriends,
      List<Friends> listOfFriendRequests,
      List<Friends> listOfFriendsPhysicalCard) async {
    final friendsData = listOfFriends.map((friend) => friend.toJson()).toList();
    final friendRequestsData =
        listOfFriendRequests.map((friend) => friend.toJson()).toList();
    final friendsPhysicalCardData =
        listOfFriendsPhysicalCard.map((friend) => friend.toJson()).toList();

    await friendCollection.doc(uid).set({
      'friends': friendsData,
      'friendRequests': friendRequestsData,
      'friendsPhysicalCard': friendsPhysicalCardData,
    });
  }

  List<Cards> _cardListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Cards(
        imageUrl: doc['imageUrl'] ?? '',
        cardName: doc['companyName'] ?? '',
        companyName: doc['companyName'] ?? '',
        jobTitle: doc['jobTitle'] ?? '',
        phoneNum: doc['phoneNum'] ?? '',
        email: doc['email'] ?? '',
        companyWebsite: doc['companyWebsite'] ?? '',
        companyAddress: doc['companyAddress'] ?? '',
        personalStatement: doc['personalStatement'] ?? '',
        moreInfo: doc['moreInfo'] ?? '',
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

  FriendsData friendsDataFromSnapshot(DocumentSnapshot snapshot) {
    return FriendsData(
      uid: uid,
      listOfFriends: List<Friends>.from(
        (snapshot.reference.collection('friends').get().then((subSnapshot) {
          return _friendListFromSnapshot(subSnapshot);
        }) as List<dynamic>),
      ),
      listOfFriendRequests: List<Friends>.from(
        (snapshot.reference
            .collection('friendRequests')
            .get()
            .then((subSnapshot) {
          return _friendRequestListFromSnapshot(subSnapshot);
        }) as List<dynamic>),
      ),
      listOfFriendsPhysicalCard: List<Friends>.from(
        (snapshot['friendsPhysicalCard'] as List<dynamic> ?? []).map(
          (friend) => Friends(
            uid: friend['uid'] ?? '',
          ),
        ),
      ),
    );
  }

  UserData userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: snapshot.id, // Use the document ID as the UID
      name: snapshot['name'],
      headLine: snapshot['headLine'],
      profilePic: snapshot['profilePic'],
      listOfCards: List<Cards>.from(
        (snapshot['cards'] as List<dynamic> ?? []).map(
          (card) => Cards(
            imageUrl: card['imageUrl'] ?? '',
            cardName: card['cardName'] ?? '',
            companyName: card['companyName'] ?? '',
            jobTitle: card['jobTitle'] ?? '',
            phoneNum: card['phoneNum'] ?? '',
            email: card['email'] ?? '',
            companyWebsite: card['companyWebsite'] ?? '',
            companyAddress: card['companyAddress'] ?? '',
            personalStatement: card['personalStatement'] ?? '',
            moreInfo: card['moreInfo'] ?? '',
          ),
        ),
      ),
    );
  }

  Future<List<UserData>> getAllUsersExceptCurrent() async {
    QuerySnapshot snapshot = await profileCollection.get();
    List<UserData> users = [];
    for (var doc in snapshot.docs) {
      if (doc.id != uid) {
        UserData user = userDataFromSnapshot(doc);
        users.add(user);
      }
    }
    return users;
  }

  Stream<List<Cards>> get cardList {
    return profileCollection.snapshots().map(_cardListFromSnapshot);
  }

  Stream<List<Friends>> get friendList {
    return friendCollection.snapshots().map(_friendListFromSnapshot);
  }

  Stream<List<Friends>> get friendRequestList {
    return friendCollection.snapshots().map(_friendRequestListFromSnapshot);
  }

  Stream<UserData> get userProfile {
    return profileCollection.doc(uid).snapshots().map(userDataFromSnapshot);
  }

  Stream<FriendsData> get friendData {
    return friendCollection.doc(uid).snapshots().map(friendsDataFromSnapshot);
  }

  String get userId {
    return uid;
  }
}
