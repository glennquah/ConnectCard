import 'package:connectcard/models/Friends.dart';

// UserData class which stores the user's data
class FriendsData {
  final String uid;
  final List<Friends> listOfFriends;
  final List<Friends> listOfFriendRequests;
  final List<Friends> listOfFriendsPhysicalCard;

  FriendsData(
      {required this.uid,
      required this.listOfFriends,
      required this.listOfFriendRequests,
      required this.listOfFriendsPhysicalCard});
}
