import 'package:connectcard/models/Cards.dart';

// TheUser class
class TheUser {
  final String uid;

  TheUser({required this.uid});

  Future<String> getUserId() async {
    return uid;
  }
}

// UserData class which stores the user's data
class UserData {
  final String uid;
  final String name;
  // final String headLine;
  final List<Cards> listOfCards;

  UserData(
      {required this.uid,
      //    required this.headLine,
      required this.name,
      required this.listOfCards});
}
