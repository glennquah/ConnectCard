import 'package:connectcard/models/userDetails.dart';
import 'package:flutter/material.dart';

class CardTile extends StatelessWidget {
  final UserDetails userd;
  CardTile({this.userd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          title: Text(userd.name),
        ),
      ),
    );
  }
}
