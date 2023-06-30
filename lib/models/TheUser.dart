import 'package:connectcard/models/Cards.dart';

class TheUser {
  final String uid;

  TheUser({required this.uid});

  Future<String> getUserId() async {
    return uid;
  }
}

class UserData {
  final String uid;
  final String name;
  // final String headLine;
  final List<Cards> listOfCards;

  UserData(
      {required this.uid,
      //     required this.headLine,
      required this.name,
      required this.listOfCards});
}
