import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/theUser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    UserData? userData = Provider.of<UserData?>(context);

    return ListView.separated(
      itemCount: userData?.listOfCards.length ?? 0,
      separatorBuilder: (context, index) => Divider(),
      itemBuilder: (context, index) {
        Cards card = userData!.listOfCards[index];
        return ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.white,
            child: Icon(Icons.add_a_photo, color: Colors.black),
          ),
          title: Text(card.phoneNum),
          subtitle: Text(card.phoneNum),
        );
      },
    );
  }
}
