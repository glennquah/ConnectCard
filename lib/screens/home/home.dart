import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/screens/home/cards_form.dart';
import 'package:connectcard/screens/home/home_cardview.dart';
import 'package:connectcard/screens/home/home_listview.dart';
import 'package:connectcard/screens/showcaseWidget.dart';
import 'package:connectcard/services/auth.dart';
import 'package:connectcard/services/database.dart';
import 'package:connectcard/shared/loading.dart';
import 'package:connectcard/shared/navigationbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

// This class is used to display the home page
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final Auth _auth = Auth();
  Color bgColor = const Color(0xffFEAA1B);
  bool isCardView = false;

  void toggleView() {
    if (isCardView) {
      setState(() {
        isCardView = false;
      });
    }
  }

  bool isShowcaseActive = true;

  void toggleShowcase() {
    setState(() {
      isShowcaseActive = !isShowcaseActive;
    });
  }

  final GlobalKey globalKeyOne = GlobalKey();
  final GlobalKey globalKeyTwo = GlobalKey();
  final GlobalKey globalKeyThree = GlobalKey();
  final GlobalKey globalKeyFour = GlobalKey();
  final GlobalKey globalKeyFive = GlobalKey();
  final GlobalKey globalKeySix = GlobalKey();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        ShowCaseWidget.of(context).startShowCase(
            [globalKeyOne, globalKeyTwo, globalKeyThree, globalKeyFour]));
    super.initState();
  }

  void _showCardsPanel() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: CardsForm(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UserData>(
      stream:
          DatabaseService(uid: Provider.of<TheUser?>(context)!.uid).userProfile,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData? userData = snapshot.data;
          List<Cards> cards = userData!.listOfCards;
          return Scaffold(
            bottomNavigationBar: NaviBar(currentIndex: 0),
            backgroundColor: bgColor,
            appBar: AppBar(
              title: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/profile');
                },
                child: ShowcaseView(
                  title: 'View Profile',
                  description: 'Click here to edit your profile!',
                  globalKey: globalKeyOne,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userData.name,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 16.0,
                        ),
                      ),
                      Text(
                        'View Profile',
                        style: TextStyle(
                          color: Colors.green[800],
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              leading: Padding(
                padding: const EdgeInsets.all(5.0),
                child: CircleAvatar(
                  radius: 15.0,
                  backgroundImage: NetworkImage(
                    userData.profilePic.isNotEmpty ? userData.profilePic : '',
                  ),
                  backgroundColor: Colors.grey,
                  child: userData.profilePic.isNotEmpty
                      ? ClipOval(
                          child: Image.network(
                            userData.profilePic,
                            width: 60.0,
                            height: 60.0,
                            fit: BoxFit.cover,
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: 30.0,
                          color: Colors.white,
                        ),
                ),
              ),
              backgroundColor: bgColor,
              elevation: 0.0,
              actions: <Widget>[
                ShowcaseView(
                  globalKey: globalKeyTwo,
                  title: 'Edit Card',
                  description:
                      'Add or Edit cards by clicking on this pen icon!',
                  child: InkWell(
                    onTap: () => _showCardsPanel(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: const [
                          Icon(Icons.edit, color: Colors.black),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          isCardView ? '  List View' : '  Card View',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          children: [
                            InkWell(
                              onTap: () {
                                if (!isCardView) {
                                  setState(() {
                                    isCardView = true;
                                  });
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: ShowcaseView(
                                  globalKey: globalKeyThree,
                                  title: 'List View',
                                  description:
                                      'click here to view your cards in a list view!',
                                  child: Icon(
                                    Icons.list,
                                    color:
                                        isCardView ? Colors.black : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 5.0),
                            InkWell(
                              onTap: () {
                                if (isCardView) {
                                  setState(() {
                                    isCardView = false;
                                  });
                                }
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: ShowcaseView(
                                  globalKey: globalKeyFour,
                                  title: 'Card View',
                                  description:
                                      'Click here to view your cards in card view!',
                                  child: Icon(
                                    Icons.grid_view,
                                    color:
                                        isCardView ? Colors.grey : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                    child: isCardView
                        ? HomeListView(userData: userData, cards: cards)
                        : HomeCardView(
                            userData: userData,
                            cards: cards,
                          )),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Handle connect button press
                          },
                          child: Text('Connect'),
                        ),
                        IconButton(
                          onPressed: () {
                            // Add your functionality here
                          },
                          icon: Icon(Icons.share),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
