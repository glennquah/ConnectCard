import 'package:connectcard/screens/authenticate/register.dart';
import 'package:connectcard/screens/authenticate/sign_in.dart';
import 'package:flutter/material.dart';

// This class is used to toggle between the sign in and register pages
class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  // This method returns the sign in or register page depending on the value of showSignIn
  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      return SignIn(toggleView: toggleView);
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
