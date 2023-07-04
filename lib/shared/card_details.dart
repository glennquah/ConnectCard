import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/TheUser.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// This class is used to display the details of the user
class CardDetailsPage extends StatelessWidget {
  final Cards card;
  final UserData userData;

  CardDetailsPage({required this.card, required this.userData});

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffFEAA1B),
        title: Text(
          card.cardName,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (card.imageUrl.isNotEmpty)
                  CircleAvatar(
                    radius: 50.0,
                    backgroundImage: NetworkImage(card.imageUrl),
                  )
                else
                  Container(
                    width: 100.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.person,
                        size: 50.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                SizedBox(width: 10.0),
                Text(
                  userData.name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.0),
            Text(
              card.companyName,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
              ),
            ),
            Text(card.jobTitle),
            SizedBox(height: 20.0),
            Text(
              'Contact Information:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            GestureDetector(
              onTap: () async {
                final Uri phoneUrl = Uri(scheme: 'tel', path: card.phoneNum);
                if (await canLaunchUrl(phoneUrl)) {
                  await launchUrl(phoneUrl);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Phone app not found'),
                    ),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.phone,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      card.phoneNum.isNotEmpty
                          ? card.phoneNum
                          : "Insert Phone Number",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: card.phoneNum.isNotEmpty
                            ? TextDecoration.underline
                            : TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                final Uri emailUri = Uri(
                  scheme: 'mailto',
                  path: card.email,
                  query: encodeQueryParameters(<String, String>{
                    'subject': 'From ConnectCard',
                    'body': 'Dear ${userData.name},\n\n',
                  }),
                );
                if (await canLaunchUrl(emailUri)) {
                  await launchUrl(emailUri);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('No email client found'),
                    ),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.email,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      card.email.isNotEmpty ? card.email : "Insert Email",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: card.email.isNotEmpty
                            ? TextDecoration.underline
                            : TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                final String companyWebsite = card.companyWebsite;
                final String prefixedUrl = companyWebsite.startsWith('http')
                    ? companyWebsite
                    : 'https://$companyWebsite';

                final Uri _url = Uri.parse(prefixedUrl);
                if (await canLaunchUrl(_url)) {
                  await launchUrl(_url);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Website not found'),
                    ),
                  );
                }
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.0),
                child: Row(
                  children: [
                    Icon(
                      Icons.public,
                      color: Colors.blue,
                    ),
                    SizedBox(width: 4.0),
                    Text(
                      card.companyWebsite.isNotEmpty
                          ? card.companyWebsite
                          : "Insert Company Website",
                      style: TextStyle(
                        color: Colors.blue,
                        decoration: card.companyWebsite.isNotEmpty
                            ? TextDecoration.underline
                            : TextDecoration.none,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20.0),
            Text(
              'Details:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            Text('Work Address: ${card.companyAddress}'),
            Text('Personal Statement: ${card.personalStatement}'),
            SizedBox(height: 20.0),
            Text(
              'More Information:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            Text(card.moreInfo!),
          ],
        ),
      ),
    );
  }
}
