import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/theUser.dart';
import 'package:connectcard/shared/carouselsliderwidget.dart';
import 'package:flutter/material.dart';

class HomeCardView extends StatelessWidget {
  final UserData userData;
  final List<Cards> cards;

  HomeCardView({required this.userData, required this.cards});

  @override
  Widget build(BuildContext context) {
    return CarouselSliderWidget(
      userData: userData,
      cards: cards,
    );
  }
}
