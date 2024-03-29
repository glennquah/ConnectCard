import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/screens/home/cards_form.dart';
import 'package:connectcard/screens/home/home_cardview.dart';
import 'package:connectcard/screens/home/home_listview.dart';
import 'package:connectcard/shared/showcaseWidget.dart';
import 'package:connectcard/services/database.dart';
import 'package:connectcard/shared/loading.dart';
import 'package:connectcard/shared/navigationbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:showcaseview/showcaseview.dart';

// This class is used to display the home page
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Color bgColor = const Color(0xffFEAA1B);
  bool isCardView = false;

  final GlobalKey globalKeyOne = GlobalKey();
  final GlobalKey globalKeyTwo = GlobalKey();
  final GlobalKey globalKeyThree = GlobalKey();
  final GlobalKey globalKeyFour = GlobalKey();

  // Toggle between card view and list view
  void toggleView() {
    if (isCardView) {
      setState(() {
        isCardView = false;
      });
    }
  }

  // Show the cards panel when the user clicks on the edit icon
  void _showCardsPanel() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 60.0),
          child: const CardsForm(),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
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
                        style: const TextStyle(
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
                      : const Icon(
                          Icons.person,
                          size: 30.0,
                          color: Colors.white,
                        ),
                ),
              ),
              backgroundColor: bgColor,
              elevation: 0.0,
              actions: <Widget>[
                InkWell(
                  onTap: () => ShowCaseWidget.of(context).startShowCase([
                    globalKeyOne,
                    globalKeyTwo,
                    globalKeyThree,
                    globalKeyFour
                  ]),
                  child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
                          Icon(
                            Icons.help,
                            color: Colors.black,
                          )
                        ],
                      )),
                ),
                ShowcaseView(
                  globalKey: globalKeyTwo,
                  title: 'Edit Card',
                  description:
                      'Add or Edit cards by clicking on this pen icon!',
                  child: InkWell(
                    onTap: () => _showCardsPanel(),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        children: [
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
                          style: const TextStyle(
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
                            const SizedBox(width: 5.0),
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
                                    Icons.credit_card,
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
                        ? HomeListView(
                            userData: userData,
                            cards: cards,
                          )
                        : HomeCardView(userData: userData, cards: cards)),
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
