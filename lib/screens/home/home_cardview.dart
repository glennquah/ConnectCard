import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/shared/carouselsliderwidget.dart';
import 'package:flutter/material.dart';

class HomeCardView extends StatelessWidget {
  final UserData userData;
  final List<Cards> cards;

  HomeCardView({required this.userData, required this.cards});

  void _showShareDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Center(child: Text('Share via')),
          content: FractionallySizedBox(
            heightFactor: 0.15,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      child: IconButton(
                        onPressed: () {
                          // Handle sharing via WhatsApp
                        },
                        icon: Image.asset('assets/logo/whatsapp.png'),
                      ),
                    ),
                    Text('WhatsApp'),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      height: 60,
                      width: 60,
                      child: IconButton(
                        onPressed: () {
                          // Handle sharing via Telegram
                        },
                        icon: Image.asset('assets/logo/telegram.png'),
                      ),
                    ),
                    Text('Telegram'),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        CarouselSliderWidget(
          userData: userData,
          cards: cards,
        ),
        SizedBox(height: 10.0),
        Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: 50),
                ElevatedButton(
                  onPressed: () {
                    // Handle connect button press
                  },
                  child: Text('Connect'),
                ),
                IconButton(
                  onPressed: () {
                    _showShareDialog(context);
                  },
                  icon: Icon(Icons.share),
                ),
              ],
            )),
      ],
    );
  }
}
