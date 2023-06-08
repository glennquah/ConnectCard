import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/theUser.dart';
import 'package:connectcard/screens/home/cards_form.dart';
import 'package:connectcard/services/auth.dart';
import 'package:connectcard/services/database.dart';
import 'package:connectcard/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//updated it without splash screen

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

    return Scaffold(
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
      },
    );
  }
}
