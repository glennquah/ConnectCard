import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/theUser.dart';
import 'package:connectcard/screens/home/cards_form.dart';
import 'package:connectcard/screens/home/home_listview.dart';
import 'package:connectcard/services/auth.dart';
import 'package:connectcard/services/database.dart';
import 'package:connectcard/shared/loading.dart';
import 'package:connectcard/shared/navigationbar.dart';
import 'package:flutter/material.dart';
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
            bottomNavigationBar: NaviBar(currentIndex: 0),
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
            body: HomeListView(userData: userData, cards: cards),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
