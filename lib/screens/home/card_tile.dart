//not working

import 'package:connectcard/models/userDetails.dart';
import 'package:flutter/material.dart';

class CardTile extends StatelessWidget {
  final UserDetails userdetails;
  const CardTile({required this.userdetails});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: ListTile(
          leading: CircleAvatar(
            radius: 25.0,
            backgroundColor: Colors.brown[100],
          ),
          //title: Text(userdetails.name),
          title: Text('abc'),
          subtitle: Text('xyz'),
          //subtitle: Text('${userdetails.name}'),
        ),
      ),
    );
  }
}
