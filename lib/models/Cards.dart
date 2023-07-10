// Purpose: Create a Cards class to store the data of the Name card
class Cards {
  final String imageUrl;
  final String cardName;
  final String companyName;
  final String jobTitle;
  final String phoneNum;
  final String email;
  final String companyWebsite;
  final String companyAddress;
  final String personalStatement;
  final String? moreInfo; // optional as people might not want to add more info

// Cards Constructor
  Cards(
      {required this.imageUrl,
      required this.cardName,
      required this.companyName,
      required this.jobTitle,
      required this.phoneNum,
      required this.email,
      required this.companyWebsite,
      required this.companyAddress,
      required this.personalStatement,
      required this.moreInfo});

// Convert the data to JSON format
  Map<String, dynamic> toJson() {
    return {
      'imageUrl': imageUrl,
      'cardName': cardName,
      'companyName': companyName,
      'jobTitle': jobTitle,
      'phoneNum': phoneNum,
      'email': email,
      'companyWebsite': companyWebsite,
      'companyAddress': companyAddress,
      'personalStatement': personalStatement,
      'moreInfo': moreInfo,
    };
  }
}
