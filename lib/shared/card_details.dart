import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/theUser.dart';
import 'package:flutter/material.dart';

class CardDetailsPage extends StatelessWidget {
  final Cards card;
  final UserData userData;

  CardDetailsPage({required this.card, required this.userData});

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
            Text('Phone: ${card.phoneNum}'),
            Text('Email: ${card.email}'),
            Text('Website: ${card.companyWebsite}'),
            SizedBox(height: 20.0),
            Text(
              'Additional Information:',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
              ),
            ),
            Text('Address: ${card.companyAddress}'),
            Text('Personal Statement: ${card.personalStatement}'),
            SizedBox(height: 20.0),
            Text(card.moreInfo1),
            Text(card.moreInfo2),
            Text(card.moreInfo3),
          ],
        ),
      ),
    );
  }
}
