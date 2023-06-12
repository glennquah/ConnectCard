import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/theUser.dart';
import 'package:connectcard/screens/home/cards_form.dart';
import 'package:connectcard/services/auth.dart';
import 'package:connectcard/services/database.dart';
import 'package:connectcard/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//updated it without splash screen
import 'package:google_nav_bar/google_nav_bar.dart';

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

    /*void _signOut(BuildContext context) async {
      await _auth.signOut();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SignIn(toggleView: null)),
      );
    }*/

    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: Provider.of<TheUser?>(context)!.uid)
            .userProfile, // Assuming you have a userData stream in your DatabaseService
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data!;
            return StreamProvider<List<Cards>>.value(
              value: DatabaseService(uid: userData.uid).cardList,
              initialData: [],
              child: Scaffold(
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
                  title: Text(userData.name),
                  backgroundColor: Colors.yellow[800],
                  elevation: 0.0,
                  actions: <Widget>[
                    TextButton.icon(
                      icon: const Icon(Icons.person),
                      label: const Text('Log Out'),
                      onPressed: () {
                        //_signOut(context);
                      },
                    ),
                    TextButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text('Edit'),
                      onPressed: () => _showCardsPanel(),
                    )
                  ],
                ),
                //body: CardList(),
                body: const ListTile(
                  leading: CircleAvatar(
                    radius: 25.0,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.add_a_photo, color: Colors.black),
                  ),
                  title: Text("First Card: Insert name"),
                  subtitle: Text("Insert Job Title"),
                ),
              ),
            );
          } else {
            return Loading();
          }
        });
  }
}
