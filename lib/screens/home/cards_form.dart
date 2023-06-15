import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/theUser.dart';
import 'package:connectcard/screens/home/card_editor.dart';
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
  TheUser? user; // User object
  List<String> cards = []; // List of available cards
  String selectedCard = ''; // Selected card

  final _Name = GlobalKey<FormState>();
  String newName = '';

  @override
  Widget build(BuildContext context) {
    user = Provider.of<TheUser?>(context); // Retrieve user object

    void _showEditorPage(String selectedCard) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CardEditorScreen(selectedCard: selectedCard),
        ),
      );
    }

    if (user != null) {
      return Scaffold(
        body: SingleChildScrollView(
          child: StreamBuilder<UserData>(
            stream: DatabaseService(uid: user!.uid).userProfile,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                UserData? userData = snapshot.data;
                cards = [
                  ...userData!.listOfCards.map((card) => card.cardName),
                ]; // Update the list of available cards
                if (cards.isNotEmpty && selectedCard.isEmpty) {
                  selectedCard = cards.first;
                }

                return Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Edit Name',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        key: _Name,
                        initialValue: userData.name,
                        decoration: InputDecoration(
                          hintText: 'New Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                        validator: (val) =>
                            val!.isEmpty ? 'Enter a name' : null,
                        onChanged: (val) {
                          setState(() => newName = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () async {
                          await DatabaseService(uid: user!.uid).updateUserData(
                            newName,
                            userData.listOfCards,
                          );
                        },
                        child: Text(
                          'Confirm Edit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Select your cards',
                        style: TextStyle(fontSize: 18.0),
                      ),
                      SizedBox(height: 20.0),
                      DropdownButtonFormField<String>(
                        value: selectedCard,
                        items: cards.map<DropdownMenuItem<String>>((card) {
                          return DropdownMenuItem<String>(
                            value: card,
                            child: Text('$card'),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            selectedCard = value!;
                          });
                        },
                      ),
                      SizedBox(height: 12.0),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ElevatedButton(
                              onPressed: () => _showEditorPage(selectedCard),
                              child: Text(
                                'Edit Card',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            SizedBox(width: 12.0),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  final cardName =
                                      "New Card ${userData.listOfCards.length + 1}"; // Set the card name

                                  // Create a new card object
                                  final newCard = Cards(
                                    imageUrl: '',
                                    cardName: cardName,
                                    companyName: '',
                                    jobTitle: '',
                                    phoneNum: '',
                                    email: '',
                                    companyWebsite: '',
                                    companyAddress: '',
                                    personalStatement: '',
                                    moreInfo1: '',
                                    moreInfo2: '',
                                    moreInfo3: '',
                                  );

                                  // Update the list of cards in the user's document
                                  userData.listOfCards.add(newCard);
                                  await DatabaseService(uid: user!.uid)
                                      .updateUserData(
                                    userData.name,
                                    userData.listOfCards,
                                  );

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('New card added!'),
                                    ),
                                  );
                                }
                              },
                              child: Text(
                                'Add Card',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return Loading();
              }
            },
          ),
        ),
      );
    } else {
      return Loading();
    }
  }
}
