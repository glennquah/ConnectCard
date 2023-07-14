import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/FriendsDatabase.dart';
import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/screens/scan/friendcardeditor.dart';
import 'package:connectcard/services/database.dart';
import 'package:connectcard/shared/friendphysicalcard_details.dart';
import 'package:connectcard/shared/loading.dart';
import 'package:connectcard/shared/navigationbar.dart';
import 'package:connectcard/shared/profilebar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// PhysicalCard class
class PhysicalCardPage extends StatefulWidget {
  @override
  _PhysicalCardPageState createState() => _PhysicalCardPageState();
}

class _PhysicalCardPageState extends State<PhysicalCardPage> {
  List<Cards> friendCards = [];
  List<Cards> filteredFriendCards = [];

  void _showCardOptionsDialog(Cards card) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.symmetric(vertical: 25.0),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Center(child: Text(card.cardName)),
                SizedBox(height: 25.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FriendCardDetailsPage(
                                  card: card,
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.visibility),
                        ),
                        Text("View"),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FriendCardEditorScreen(
                                  selectedCard: card.cardName,
                                ),
                              ),
                            );
                          },
                          icon: Icon(Icons.edit),
                        ),
                        Text("Edit"),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    TheUser? user = Provider.of<TheUser?>(context, listen: false);
    if (user != null) {
      DatabaseService databaseService = DatabaseService(uid: user.uid);
      FriendsData friendsData = await databaseService.friendData.first;
      setState(() {
        friendCards = friendsData.listOfFriendsPhysicalCard;
        filteredFriendCards = friendCards;
      });
    }
  }

  void filterCards(String query) {
    setState(() {
      filteredFriendCards = [];
    });

    List<Cards> dummySearchList = [];

    for (Cards card in friendCards) {
      if (card.cardName.toLowerCase().contains(query.toLowerCase()) ||
          card.companyName.toLowerCase().contains(query.toLowerCase())) {
        dummySearchList.add(card);
      }
    }

    setState(() {
      filteredFriendCards = dummySearchList;
    });
  }

  @override
  Widget build(BuildContext context) {
    filteredFriendCards.sort((a, b) => a.cardName.compareTo(b.cardName));
    TheUser? user = Provider.of<TheUser?>(context);

    Color bgColor = const Color(0xffFEAA1B);

    return StreamBuilder<UserData>(
      stream: DatabaseService(uid: user!.uid).userProfile,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserData? userData = snapshot.data;
          return Scaffold(
            appBar: ProfileBar(userData: userData!),
            backgroundColor: bgColor,
            bottomNavigationBar: NaviBar(currentIndex: 2),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "List of Scanned Cards",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    onChanged: filterCards,
                    decoration: InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: filteredFriendCards.length,
                    separatorBuilder: (context, index) => Divider(
                      color: Colors.black,
                      thickness: 1,
                    ),
                    itemBuilder: (context, index) {
                      Cards card = filteredFriendCards[index];
                      return InkWell(
                        onTap: () {
                          _showCardOptionsDialog(card);
                        },
                        child: ListTile(
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(card.cardName),
                              Text(
                                card.companyName.isNotEmpty
                                    ? card.companyName
                                    : "Insert Company Name",
                              ),
                              Text(
                                card.jobTitle.isNotEmpty
                                    ? card.jobTitle
                                    : "Insert Job Title",
                              ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                card.phoneNum.isNotEmpty
                                    ? card.phoneNum
                                    : "Insert Phone Number",
                              ),
                              Text(
                                card.email.isNotEmpty
                                    ? card.email
                                    : "Insert Email",
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
