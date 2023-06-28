import 'package:carousel_slider/carousel_slider.dart';
import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/theUser.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CarouselSliderWidget extends StatefulWidget {
  final UserData userData;
  final List<Cards> cards;

  CarouselSliderWidget({required this.userData, required this.cards});

  @override
  _CarouselSliderWidgetState createState() => _CarouselSliderWidgetState();
}

class _CarouselSliderWidgetState extends State<CarouselSliderWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text(
          widget.cards[_currentIndex]
              .cardName, // Show the type of the current card
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Flexible(
          child: CarouselSlider.builder(
            itemCount: widget.cards.length,
            itemBuilder: (context, index, _) {
              Cards card = widget.cards[index];
              return Container(
                // ... existing code for the card item
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(8.0),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ... existing code for other card details
                        GestureDetector(
                          onTap: () {
                            if (card.phoneNum.isNotEmpty) {
                              launch('tel:${card.phoneNum}');
                            }
                          },
                          child: Text(
                            card.phoneNum.isNotEmpty
                                ? card.phoneNum
                                : "Insert Phone Number",
                            style: TextStyle(
                              color: Colors.grey[700],
                              decoration: card.phoneNum.isNotEmpty
                                  ? TextDecoration.underline
                                  : TextDecoration.none,
                            ),
                          ),
                        ),
                        // ... existing code for other card details
                      ],
                    ),
                  ),
                ),
              );
            },
            options: CarouselOptions(
              // ... existing carousel options
              onPageChanged: (index, _) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
          ),
        ),
        SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.cards.length,
            (index) => Container(
                // ... existing code for the indicator dots
                ),
          ),
        ),
      ],
    );
  }
}
