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
  final String moreInfo1;
  final String moreInfo2;
  final String moreInfo3;

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
      required this.moreInfo1,
      required this.moreInfo2,
      required this.moreInfo3});

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
      'moreInfo1': moreInfo1,
      'moreInfo2': moreInfo2,
      'moreInfo3': moreInfo3,
    };
  }
}
