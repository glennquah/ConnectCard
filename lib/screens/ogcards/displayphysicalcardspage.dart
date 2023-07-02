import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/services/database.dart';
import 'package:connectcard/shared/loading.dart';
import 'package:connectcard/shared/navigationbar.dart';
import 'package:connectcard/shared/profilebar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// PhyssicalCard class
class PhysicalCardPage extends StatefulWidget {
  @override
  _PhysicalCardPageState createState() => _PhysicalCardPageState();
}

class _PhysicalCardPageState extends State<PhysicalCardPage> {
  final List<String> rewardCards = [
    'acai',
    'mac',
    'soobway',
    'stuffd',
    'sbox',
    'cbtl',
  ];
  List<String> filteredRewardCards = [];

  @override
  void initState() {
    super.initState();
    filteredRewardCards = rewardCards;
  }

  void filterCards(String query) {
    setState(() {
      filteredRewardCards = rewardCards
          .where((card) => card.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    TheUser? user;
    user = Provider.of<TheUser?>(context);

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
                  child: ListView.builder(
                    itemCount: filteredRewardCards.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(filteredRewardCards[index]),
                        // Add more information about each card if needed
                        // subtitle: Text('rewardCards details'),
                        // trailing: Icon(Icons.arrow_forward),
                        // onTap: () {
                        //   // Handle rewardcards tap
                        // },
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
