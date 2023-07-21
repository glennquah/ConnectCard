import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/profile/profilepage.dart';
import 'package:connectcard/screens/friendcards/friendscardpage.dart';
import 'package:connectcard/screens/home/home.dart';
import 'package:connectcard/screens/ogcards/displayphysicalcardspage.dart';
import 'package:connectcard/screens/scan/ocr/ocr.dart';
import 'package:connectcard/screens/wrapper.dart';
import 'package:connectcard/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<TheUser?>.value(
      value: Auth().user,
      initialData: null,
      child: MaterialApp(
        home: Wrapper(),
        // to route to a page, use Navigator.pushNamed(context, '/pageName')
        routes: {
          '/home': (context) => Home(),
          '/scan': (context) => OcrScreen(),
          '/physicalcards': (context) => PhysicalCardPage(),
          '/friends': (context) => FriendsCardsPage(),
          '/profile': (context) => ProfilePage(),
        },
      ),
    );
  }
}
