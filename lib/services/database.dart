import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/theUser.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  // Collection reference
  final CollectionReference profileCollection =
      FirebaseFirestore.instance.collection('profile');

  Future<void> updateUserData(String name, List<Cards> listOfCards) async {
    final cardsData = listOfCards.map((card) => card.toJson()).toList();

    await profileCollection.doc(uid).set({
      'name': name,
      'cards': cardsData,
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
          moreInfo1: doc['moreInfo1'] ?? '',
          moreInfo2: doc['moreInfo2'] ?? '',
          moreInfo3: doc['moreInfo3'] ?? '');
    }).toList();
  }

  // UserData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot['name'],
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
            moreInfo1: card['moreInfo1'] ?? '',
            moreInfo2: card['moreInfo2'] ?? '',
            moreInfo3: card['moreInfo3'] ?? '',
          ),
        ),
      ),
    );
  }

  // get cards stream
  Stream<List<Cards>> get cardList {
    return profileCollection.snapshots().map(_cardListFromSnapshot);
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
