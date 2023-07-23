import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Auth class to handle authentication
class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  TheUser? _userFromFirebaseUser(User? user) {
    return user != null ? TheUser(uid: user.uid) : null;
  }

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<TheUser?> get user {
    return _firebaseAuth.authStateChanges().map(_userFromFirebaseUser);
  }

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User user = result.user!;
      return user;
    } catch (error) {
      print(error.toString());
      return null;
    }
  }

  // Register with email and password
  Future<TheUser?> registerWithEmailAndPassword(
      String phoneNum, String email, String password) async {
    try {
      UserCredential result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User user = result.user!;
      // Create a new document for the user with the uid
      await DatabaseService(uid: user.uid).updateUserData(
        'name',
        '',
        '',
        [
          Cards(
            imageUrl: '',
            cardName: 'Default card',
            companyName: '',
            jobTitle: '',
            phoneNum: phoneNum,
            email: email,
            companyWebsite: '',
            companyAddress: '',
            personalStatement: '',
            moreInfo: '',
          ),
        ],
      );
      // Create a new document for the user's friends with the uid
      await DatabaseService(uid: user.uid).updateFriendDatabase(
        [],
        [],
        [],
        [],
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
