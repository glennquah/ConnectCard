import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/screens/home/card_details.dart';
import 'package:flutter/material.dart';

// This class is used to display the cards on the home page in listview
class HomeListView extends StatelessWidget {
  final UserData userData;
  final List<Cards> cards;

  const HomeListView({super.key, required this.userData, required this.cards});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cards.length,
            itemBuilder: (context, index) {
              Cards card = cards[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CardDetailsPage(
                        card: card,
                        userData: userData,
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black),
                    ),
                  ),
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      radius: 40.0,
                      backgroundColor: Colors.grey,
                      child: card.imageUrl.isNotEmpty
                          ? ClipOval(
                              child: Image.network(
                                card.imageUrl,
                                width: 60.0,
                                height: 60.0,
                                fit: BoxFit.cover,
                              ),
                            )
                          : const Icon(
                              Icons.person,
                              size: 40.0,
                              color: Colors.white,
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
                        Text(card.email.isNotEmpty
                            ? card.email
                            : "Insert Email"),
                      ],
                    ),
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
