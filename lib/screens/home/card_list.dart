import 'package:connectcard/models/userDetails.dart';
import 'package:connectcard/screens/home/card_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardList extends StatefulWidget {
  @override
  _CardListState createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  @override
  Widget build(BuildContext context) {
    final userDetails = Provider.of<List<UserDetails>>(context) ?? [];

    return ListView.builder(
      itemCount: userDetails.length,
      itemBuilder: (context, index) {
        return CardTile(userdetails: userDetails[index]);
      },
    );
  }
}
