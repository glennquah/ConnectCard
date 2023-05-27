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
  final String email;
  final String phoneNum;
  final String address;
  final String jobTitle;
  final String moreInfo;

  UserData(
      {required this.uid,
      required this.name,
      required this.email,
      required this.phoneNum,
      required this.address,
      required this.jobTitle,
      required this.moreInfo});
}
