import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/screens/authenticate/authenticate.dart';
import 'package:connectcard/screens/home/home.dart';
import 'package:connectcard/screens/home/ocr/ocr.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser?>(context);
    print(user);

    // return either the Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return OcrScreen();
    }
  }
}
