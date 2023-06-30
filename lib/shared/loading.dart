import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

// This class is used to display a loading screen
class Loading extends StatelessWidget {
  Color bgColor = const Color(0xffFEAA1B);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: bgColor,
      child: Center(
        child: SpinKitRing(
          color: Colors.white,
          size: 50.0,
        ),
      ),
    );
  }
}
