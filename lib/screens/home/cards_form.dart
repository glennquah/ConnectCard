import 'package:connectcard/models/theUser.dart';
import 'package:connectcard/services/database.dart';
import 'package:connectcard/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardsForm extends StatefulWidget {
  @override
  _CardsFormState createState() => _CardsFormState();
}

class _CardsFormState extends State<CardsForm> {
  final _formKey = GlobalKey<FormState>();
  final List<String> cards = ['BusinessCard']; // List of available cards
  List<String> selectedCards = []; // List of selected cards

  @override
  Widget build(BuildContext context) {
    TheUser user = Provider.of<TheUser>(context);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user.uid).userProfile,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData? userData = snapshot.data;
          //check below
          //selectedCards = userData.name; // Update selected cards from user data
          selectedCards = userData?.name as List<String>;

          return Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Text(
                  'Select your cards',
                  style: TextStyle(fontSize: 18.0),
                ),
                SizedBox(height: 20.0),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    String card = cards[index];
                    bool value = selectedCards.contains(card);

                    return CheckboxListTile(
                      title: Text(card),
                      value: value,
                      onChanged: (isChecked) {
                        setState(() {
                          if (value) {
                            selectedCards.add(card);
                          } else {
                            selectedCards.remove(card);
                          }
                        });
                      },
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await DatabaseService(uid: user.uid).updateUserData(
                        "abc",
                        "abc@abc",
                        "abc",
                        "abc",
                        "abc",
                        "moreInfo",
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: Text('Save'),
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
