import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/shared/carouselsliderwidget.dart';
import 'package:flutter/material.dart';

class FriendCards extends StatelessWidget {
  final UserData userData;
  final List<Cards> cards;

  FriendCards({required this.userData, required this.cards});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFEAA1B),
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
