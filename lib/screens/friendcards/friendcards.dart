import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/shared/carouselsliderwidget.dart';
import 'package:flutter/material.dart';

// This class is used to display the cards of a friend by using the CarouselSliderWidget
class FriendCards extends StatelessWidget {
  final UserData userData;
  final List<Cards> cards;

  const FriendCards({super.key, required this.userData, required this.cards});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffFEAA1B),
        title: Text('${userData.name}\'s Cards'),
      ),
      body: Material(
        // Wrap the widget with Material
        child: CarouselSliderWidget(
          userData: userData,
          cards: cards,
          backgroundColor: const Color(0xffFEAA1B),
        ),
      ),
    );
  }
}
