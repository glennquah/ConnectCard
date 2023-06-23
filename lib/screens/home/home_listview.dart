import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/theUser.dart';
import 'package:flutter/material.dart';

class HomeListView extends StatelessWidget {
  final UserData userData;
  final List<Cards> cards;

  HomeListView({required this.userData, required this.cards});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 5.0),
        SizedBox(height: 5.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'List of NameCards',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(width: 140.0),
            InkWell(
              onTap: () => {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: const [
                    Icon(Icons.list, color: Colors.black),
                  ],
                ),
              ),
            ),
            SizedBox(width: 5.0),
            InkWell(
              onTap: () => {},
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: const [
                    Icon(Icons.grid_view, color: Colors.grey),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.0),
        Expanded(
          child: ListView.builder(
            itemCount: cards.length,
            itemBuilder: (context, index) {
              Cards card = cards[index];
              return Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.black),
                  ),
                ),
                padding: EdgeInsets.only(bottom: 8.0),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: CircleAvatar(
                    radius: 40.0,
                    backgroundColor: Colors.white,
                    child: card.imageUrl.isNotEmpty
                        ? ClipOval(
                            child: Image.network(
                              card.imageUrl,
                              width: 60.0,
                              height: 60.0,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            Icons.add,
                            size: 40.0,
                            color: Colors.black,
                          ),
                  ),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(userData.name),
                      Text(card.companyName.isNotEmpty
                          ? card.companyName
                          : "Insert Company Name"),
                      Text(card.jobTitle.isNotEmpty
                          ? card.jobTitle
                          : "Insert Job Title"),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(card.phoneNum.isNotEmpty
                          ? card.phoneNum
                          : "Insert Phone Number"),
                      Text(card.email.isNotEmpty ? card.email : "Insert Email"),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
