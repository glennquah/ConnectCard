import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/screens/home/card_editor.dart';
import 'package:connectcard/services/database.dart';
import 'package:connectcard/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Form for user to see and edit their cards
// users can also add new cards
class CardsForm extends StatefulWidget {
  const CardsForm({super.key});

  @override
  _CardsFormState createState() => _CardsFormState();
}

class _CardsFormState extends State<CardsForm> {
  final _formKey = GlobalKey<FormState>();
  TheUser? user;
  List<String> cards = [];
  String selectedCard = ''; // Selected card
  String newName = '';

  @override
  Widget build(BuildContext context) {
    user = Provider.of<TheUser?>(context); // Retrieve user object

    void showEditorPage(String selectedCard) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CardEditorScreen(selectedCard: selectedCard),
        ),
      );
    }

    if (user != null) {
      return Container(
        constraints: const BoxConstraints(maxHeight: 200),
        child: Scaffold(
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
                        const Text(
                          'Select your cards',
                          style: TextStyle(fontSize: 18.0),
                        ),
                        const SizedBox(height: 20.0),
                        DropdownButtonFormField<String>(
                          value: selectedCard,
                          items: cards.map<DropdownMenuItem<String>>((card) {
                            return DropdownMenuItem<String>(
                              value: card,
                              child: Text(card),
                            );
                          }).toList(),
                          onChanged: (String? value) {
                            setState(() {
                              selectedCard = value!;
                            });
                          },
                        ),
                        const SizedBox(height: 12.0),
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: () => showEditorPage(selectedCard),
                                child: const Text(
                                  'Edit Card',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 12.0),
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    final cardName =
                                        "New Card ${userData.listOfCards.length + 1}";
                                    // Set the card name so that it wont be the same as other cards

                                    // Create a new card object
                                    final newCard = Cards(
                                      imageUrl: '',
                                      cardName: cardName,
                                      companyName: '',
                                      jobTitle: '',
                                      phoneNum:
                                          userData.listOfCards.first.phoneNum,
                                      email: userData.listOfCards.first.email,
                                      companyWebsite: '',
                                      companyAddress: '',
                                      personalStatement: '',
                                      moreInfo: '',
                                    );

                                    // Update the list of cards in the user's document
                                    userData.listOfCards.add(newCard);
                                    await DatabaseService(uid: user!.uid)
                                        .updateUserData(
                                            userData.name,
                                            userData.headLine,
                                            userData.profilePic,
                                            userData.listOfCards);

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('New card added!'),
                                      ),
                                    );
                                  }
                                },
                                child: const Text(
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
        ),
      );
    } else {
      return Loading();
    }
  }
}
