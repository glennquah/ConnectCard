import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/theUser.dart';
import 'package:connectcard/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Create user object based on User
  TheUser? _userFromFirebaseUser(User user) {
    return user != null ? TheUser(uid: user.uid) : null;
  }

  User? get currentUser => _firebaseAuth.currentUser;

  // Auth change user stream
  Stream<TheUser?> get user {
    return _firebaseAuth
        .authStateChanges()
        .map((User? user) => _userFromFirebaseUser(user!));
  }

  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user!;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<TheUser?> registerWithEmailAndPassword(
      String phoneNum, String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user!;

      // create a new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData(
        'name',
        [
          Cards(
            profileImage: null,
            cardName: 'Default card',
            companyName: '',
            jobTitle: '',
            phoneNum: phoneNum,
            email: email,
            companyWebsite: '',
            companyAddress: '',
            personalStatement: '',
            moreInfo1: '',
            moreInfo2: '',
            moreInfo3: '',
          )
        ],
      );

      return _userFromFirebaseUser(user);
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
