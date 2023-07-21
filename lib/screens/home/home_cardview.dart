import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/shared/carouselsliderwidget.dart';
import 'package:flutter/material.dart';

// This class is used to display the cards on the home page in cardview
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
          content: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          child: IconButton(
                            onPressed: () async {
                              // Add logic for WhatsApp sharing
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
                            onPressed: () async {
                              // Add logic for Telegram sharing
                            },
                            icon: Image.asset('assets/logo/telegram.png'),
                          ),
                        ),
                        Text('Telegram'),
                      ],
                    ),
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

  void _showConnectDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Share Cards'),
          content: Text('Implement the sharing functionality here.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
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
                  _showConnectDialog(context);
                },
                child: Text('Connect'),
              ),
              IconButton(
                onPressed: () {
                  _showShareDialog(context); // Un-commented the method call
                },
                icon: Icon(Icons.share),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
