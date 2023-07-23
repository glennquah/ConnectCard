//Friends class to store UID of the user's friends
class Friends {
  //Only store uid so that we can retrieve the user's data from the database
  final String uid;

  Friends({
    required this.uid,
  });

  // Convert the data to JSON format
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
    };
  }
}
