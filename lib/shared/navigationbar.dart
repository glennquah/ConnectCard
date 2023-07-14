import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

// This class is used to display the navigation bar
class NaviBar extends StatelessWidget {
  final int currentIndex;

  NaviBar({required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
        child: GNav(
          backgroundColor: Colors.white,
          color: Colors.black,
          activeColor: Colors.white,
          tabBackgroundColor: Colors.grey.shade800,
          gap: 20,
          padding: const EdgeInsets.all(16),
          tabs: const [
            GButton(icon: Icons.home, text: 'Home'),
            GButton(icon: Icons.camera, text: 'Scan'),
            GButton(icon: Icons.card_membership, text: 'Cards'),
            GButton(icon: Icons.people, text: 'Friends'),
          ],
          selectedIndex: currentIndex,
          onTabChange: (index) {
            switch (index) {
              case 0:
                Navigator.pushReplacementNamed(context, '/home');
                break;
              case 1:
                Navigator.pushReplacementNamed(context, '/scan');
                break;
              case 2:
                Navigator.pushReplacementNamed(context, '/physicalcards');
                break;
              case 3:
                Navigator.pushReplacementNamed(context, '/friends');
                break;
            }
          },
        ),
      ),
    );
  }
}
