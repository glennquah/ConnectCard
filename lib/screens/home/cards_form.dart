import 'package:connectcard/models/theUser.dart';
import 'package:connectcard/screens/home/card_editor.dart';
import 'package:connectcard/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardsForm extends StatefulWidget {
  @override
  _CardsFormState createState() => _CardsFormState();
}

class _CardsFormState extends State<CardsForm> {
  final _formKey = GlobalKey<FormState>();
  List<String> cards = ['NewCard', 'NewCard2']; // List of available cards
  String selectedCard = 'NewCard'; // Selected card
  TheUser? user; // User object

  @override
  Widget build(BuildContext context) {
    user = Provider.of<TheUser?>(context); // Retrieve user object

    void _showEditorPage() {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CardEditorScreen()),
      );
    }

    if (user != null) {
      return Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Text(
              'Select your cards',
              style: TextStyle(fontSize: 18.0),
            ),
            SizedBox(height: 20.0),
            DropdownButtonFormField(
              value: selectedCard,
              items: cards.map((card) {
                return DropdownMenuItem(
                  value: card,
                  child: Text('$card Card'),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedCard = value.toString();
                });
              },
            ),
            SizedBox(height: 12.0),
            Center(
              // Wrap the Row with Center widget
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: () => _showEditorPage(),
                    child: Text('Edit Card',
                        style: TextStyle(color: Colors.white)),
                  ),
                  SizedBox(width: 12.0),
                  ElevatedButton(
                    onPressed: () async {
                      // Another form to add a new card
                    },
                    child:
                        Text('Add Card', style: TextStyle(color: Colors.white)),
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
  }
}
