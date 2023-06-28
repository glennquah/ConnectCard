import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/theUser.dart';
import 'package:flutter/material.dart';

class HomeCardView extends StatelessWidget {
  final UserData userData;
  final List<Cards> cards;

  HomeCardView({required this.userData, required this.cards});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CarouselSlider.builder(
            itemCount: cards.length,
            itemBuilder: (context, index, _) {
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
            options: CarouselOptions(
              height: 400.0,
              enableInfiniteScroll: false,
              viewportFraction: 0.8,
              enlargeCenterPage: true,
            ),
          ),
        ),
      ],
    );
  }
}
