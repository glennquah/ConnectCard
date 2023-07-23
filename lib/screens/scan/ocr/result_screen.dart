import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/FriendsDatabase.dart';
import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/screens/home/card_editor.dart';
import 'package:connectcard/screens/scan/friendcardeditor.dart';
import 'package:connectcard/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Color bgColor = const Color(0xffFEAA1B);

// Form for user to see the result of the OCR scan
// Result is split into
// 1. Filtered Information (Phone Number, Email, Website, Address)
// 2. Remaining Information
class ResultScreen extends StatelessWidget {
  final String text;
  final String imagePath;

  const ResultScreen({Key? key, required this.text, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    TheUser? user = Provider.of<TheUser?>(context);

    // Show personal card editor page
    void showEditorPage(String newCard) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CardEditorScreen(selectedCard: newCard),
        ),
      );
    }

    // Show friend card editor page
    void showFriendEditorPage(String newCard) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FriendCardEditorScreen(selectedCard: newCard),
        ),
      );
    }

    final List<String> lines = text.split('\n');
    final List<String> remainingLines = [];
    final List<String> filteredLines = [];

    // Filter the lines into filteredLines and remainingLines
    // prefill for website, phone number, email, address
    for (final line in lines) {
      final trimmedLine = line.trim();
      if (trimmedLine.contains('www.')) {
        filteredLines.add('Website: $trimmedLine');
      } else if (RegExp(r'\+65 9\d{3} \d{4}').hasMatch(trimmedLine)) {
        filteredLines.add('Phone Number: $trimmedLine');
      } else if (trimmedLine.contains('@')) {
        filteredLines.add('Email: $trimmedLine');
      } else if (trimmedLine.contains('Singapore')) {
        final addressPattern = RegExp(r'Singapore \d{6}');
        if (addressPattern.hasMatch(trimmedLine)) {
          filteredLines.add('Address: $trimmedLine');
        } else {
          remainingLines.add(trimmedLine);
        }
      } else {
        remainingLines.add(trimmedLine);
      }
    }

    // Remove duplicate labels from filteredLines
    final uniqueFilteredLines = filteredLines.toSet().toList();

    String getFilteredLineValue(String label) {
      final index =
          uniqueFilteredLines.indexWhere((line) => line.startsWith(label));
      if (index != -1) {
        final line = uniqueFilteredLines[index];
        return line.substring(label.length).trim();
      }
      return '';
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text('Scanned NameCard Information'),
      ),
      body: StreamBuilder<UserData>(
        stream: DatabaseService(uid: user!.uid).userProfile,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;
            return Container(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filtered Information:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: uniqueFilteredLines.length,
                      itemBuilder: (context, index) {
                        final line = uniqueFilteredLines[index];
                        return Text(line);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Remaining Information:',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: remainingLines.length,
                      itemBuilder: (context, index) {
                        return Text(remainingLines[index]);
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Select Card Type'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    leading: const Icon(Icons.person),
                                    title: const Text('Personal Card'),
                                    onTap: () async {
                                      final cardName =
                                          "Scanned Card ${userData!.listOfCards.length + 1}";

                                      // Create a new card object for the user, filling in the prefilled fields
                                      final newCard = Cards(
                                        imageUrl: '',
                                        cardName: cardName,
                                        companyName: '',
                                        jobTitle: '',
                                        phoneNum: getFilteredLineValue(
                                            'Phone Number:'),
                                        email: getFilteredLineValue('Email:'),
                                        companyWebsite:
                                            getFilteredLineValue('Website:'),
                                        companyAddress:
                                            getFilteredLineValue('Address:'),
                                        personalStatement: '',
                                        moreInfo: remainingLines.join('\n'),
                                      );

                                      // Update the list of cards in the user's document
                                      userData.listOfCards.add(newCard);
                                      await DatabaseService(uid: user!.uid)
                                          .updateUserData(
                                        userData.name,
                                        userData.headLine,
                                        userData.profilePic,
                                        userData.listOfCards,
                                      );

                                      showEditorPage(cardName);
                                    },
                                  ),
                                  ListTile(
                                    leading: const Icon(Icons.group),
                                    title: const Text('Friend Card'),
                                    onTap: () async {
                                      DatabaseService databaseService =
                                          DatabaseService(uid: user.uid);
                                      FriendsData friendsData =
                                          await databaseService
                                              .friendData.first;
                                      List<Cards> friendCards =
                                          friendsData.listOfFriendsPhysicalCard;

                                      final cardName =
                                          "Scanned Card ${friendCards.length + 1}";

                                      // Create a new card object and filling in the prefilled fields
                                      final newCard = Cards(
                                        imageUrl: imagePath,
                                        cardName: cardName,
                                        companyName: '',
                                        jobTitle: '',
                                        phoneNum: getFilteredLineValue(
                                            'Phone Number:'),
                                        email: getFilteredLineValue('Email:'),
                                        companyWebsite:
                                            getFilteredLineValue('Website:'),
                                        companyAddress:
                                            getFilteredLineValue('Address:'),
                                        personalStatement: '',
                                        moreInfo: remainingLines.join('\n'),
                                      );

                                      // Update the list of cards in the user's document
                                      friendCards.add(newCard);
                                      await databaseService
                                          .updateFriendDatabase(
                                        friendsData.listOfFriends,
                                        friendsData.listOfFriendRequestsSent,
                                        friendsData.listOfFriendRequestsRec,
                                        friendCards,
                                      );

                                      showFriendEditorPage(cardName);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                      child: const Text('Add Card'),
                    ),
                  ),
                ],
              ),
            );
          }
          return Container(); // Placeholder for when data is loading
        },
      ),
    );
  }
}
