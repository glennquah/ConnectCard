import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/screens/authenticate/authenticate.dart';
import 'package:connectcard/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

// This class is used to toggle between the sign in and register pages
class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser?>(context);

    // return either the Home or Authenticate widget
    if (user == null) {
      return const Authenticate();
    } else {
      return ShowCaseWidget(
          builder: Builder(
        builder: (context) => const Home(),
      ));
    }
  }
}
