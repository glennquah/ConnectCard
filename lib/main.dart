import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'packages:connectcard/services/auth.dart';
import 'package:connectcard/screens/wrapper.dart';
import 'package:connectcard/models/TheUser.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  //Root of the app
  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: Auth().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
