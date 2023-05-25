import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/screens/wrapper.dart';
import 'package:connectcard/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<TheUser?>.value(
      value: Auth().user,
      initialData: null,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
