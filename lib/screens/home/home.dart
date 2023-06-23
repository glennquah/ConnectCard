import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/theUser.dart';
import 'package:connectcard/screens/home/cards_form.dart';
import 'package:connectcard/services/auth.dart';
import 'package:connectcard/services/database.dart';
import 'package:connectcard/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    void _showCardsPanel() {
      showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
            child: CardsForm(),
          );
        },
      );
    }

    return StreamBuilder<UserData>(
      stream:
          DatabaseService(uid: Provider.of<TheUser?>(context)!.uid).userProfile,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData? userData = snapshot.data;
          List<Cards> cards = userData!.listOfCards;
          return Scaffold(
            bottomNavigationBar: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 15.0, vertical: 20.0),
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
                    GButton(icon: Icons.card_giftcard, text: 'My Cards'),
                    GButton(icon: Icons.people, text: 'Contacts'),
                  ],
                ),
              ),
            ),
            backgroundColor: Colors.yellow[800],
            appBar: AppBar(
              title: TextButton(
                onPressed: () {
                  // Move to profile page
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userData.name,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                    Text(
                      'View Profile',
                      style: TextStyle(
                        color: Colors.green[800],
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.all(5.0),
                child: CircleAvatar(
                  radius: 15.0,
                  backgroundImage: NetworkImage(
                    userData.listOfCards.isNotEmpty &&
                            userData.listOfCards.first.imageUrl.isNotEmpty
                        ? userData.listOfCards.first.imageUrl
                        : '',
                  ),
                  backgroundColor: Colors.white,
                  child: userData.listOfCards.isNotEmpty &&
                          userData.listOfCards.first.imageUrl.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            userData.listOfCards.first.imageUrl,
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
              ),
              backgroundColor: Colors.yellow[800],
              elevation: 0.0,
              actions: <Widget>[
                InkWell(
                  onTap: () => _showCardsPanel(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: const [
                        Icon(Icons.edit, color: Colors.black),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                SizedBox(
                  height: 5.0,
                ),
                SizedBox(height: 5.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'List of NameCards',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        //fontFamily: 'YourCustomFont',
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
                            Icon(Icons.list,
                                color: Colors.black), //icon for list view
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
                            Icon(Icons.grid_view,
                                color: Colors.grey), //icon for grid view
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
                    itemExtent: 60,
                    itemBuilder: (context, index) {
                      Cards card = cards[index];
                      return ListTile(
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
                              Text(card.companyName),
                              Text(card.jobTitle),
                            ]),
                        subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(card.phoneNum),
                              Text(card.email),
                            ]),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
