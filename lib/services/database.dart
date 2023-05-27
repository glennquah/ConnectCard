import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectcard/models/theUser.dart';
import 'package:connectcard/models/userDetails.dart';

class DatabaseService {
  final String uid;

  DatabaseService({required this.uid});

  // collection reference
  final CollectionReference profileCollection =
      FirebaseFirestore.instance.collection('profile');

  Future<void> updateUserData(String name, String email, String phoneNum,
      String address, String jobTitle, String moreInfo) async {
    await profileCollection.doc(uid).set({
      'name': name,
      'email': email,
      'phoneNum': phoneNum,
      'address': address,
      'jobTitle': jobTitle,
      'moreInfo': moreInfo,
    });
  }

  // get profile from snapshot
  List<UserDetails> _profileListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return UserDetails(
        name: doc['name'] ?? '',
        email: doc['email'] ?? '',
        phoneNum: doc['phoneNum'] ?? '',
        address: doc['address'] ?? '',
        jobTitle: doc['jobTitle'] ?? '',
        moreInfo: doc['moreInfo'] ?? '',
      );
    }).toList();
  }

  // userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(
      uid: uid,
      name: snapshot['name'],
      email: snapshot['email'],
      phoneNum: snapshot['phoneNum'],
      address: snapshot['address'],
      jobTitle: snapshot['jobTitle'],
      moreInfo: snapshot['moreInfo'],
    );
  }

  // get profile stream
  Stream<List<UserDetails>> get profile {
    return profileCollection.snapshots().map(_profileListFromSnapshot);
  }

  // get user profile stream
  Stream<UserData> get userProfile {
    return profileCollection.doc(uid).snapshots().map(_userDataFromSnapshot);
  }
}
