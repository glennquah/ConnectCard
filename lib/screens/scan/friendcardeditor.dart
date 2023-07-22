import 'dart:io';

import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/FriendsDatabase.dart';
import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/screens/ogcards/displayphysicalcardspage.dart';
import 'package:connectcard/services/database.dart';
import 'package:connectcard/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Screen for users to be able to edit the information of their cards
class FriendCardEditorScreen extends StatefulWidget {
  final String selectedCard;
  const FriendCardEditorScreen({required this.selectedCard});

  @override
  _FriendCardEditorScreenState createState() => _FriendCardEditorScreenState();
}

class _FriendCardEditorScreenState extends State<FriendCardEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _imageUrl = GlobalKey<FormState>();
  final _cardName = GlobalKey<FormState>();
  final _companyNameKey = GlobalKey<FormState>();
  final _jobTitleKey = GlobalKey<FormState>();
  final _phoneNumKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  final _websiteKey = GlobalKey<FormState>();
  final _addressKey = GlobalKey<FormState>();
  final _personalStatementKey = GlobalKey<FormState>();
  final _moreInfoKey = GlobalKey<FormState>();

  TheUser? user; // User object
  String imageUrl = '';
  String newCardName = '';
  String newCompanyName = '';
  String newJobTitle = '';
  String newPhoneNum = '';
  String newEmail = '';
  String newWebsite = '';
  String newAddress = '';
  String newPersonalStatement = '';
  String newMoreInfo = '';
  File? image;

  Color bgColor = const Color(0xffFEAA1B);

  Future<FriendsData> _getFriendsData() async {
    user = Provider.of<TheUser?>(context);
    if (user != null) {
      UserData? userData =
          await DatabaseService(uid: user!.uid).userProfile.first;
      DatabaseService databaseService = DatabaseService(uid: user!.uid);
      return await databaseService.friendData.first;
    } else {
      throw Exception("User is null");
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<TheUser?>(context); // Retrieve user object
    if (user != null) {
      return FutureBuilder<FriendsData>(
        future: _getFriendsData(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            FriendsData friendsData = snapshot.data!;
            List<Cards> listOfCards = friendsData.listOfFriendsPhysicalCard;
            DatabaseService databaseService = DatabaseService(uid: user!.uid);
            // Find the selected card based on its name
            Cards selectedCard = listOfCards.firstWhere(
              (card) => card.cardName == widget.selectedCard,
              orElse: () => Cards(
                cardName: '',
                companyName: '',
                jobTitle: '',
                phoneNum: '',
                email: '',
                companyWebsite: '',
                companyAddress: '',
                personalStatement: '',
                moreInfo: '',
                imageUrl: '',
              ),
            );

            if (imageUrl.isEmpty) {
              imageUrl = selectedCard.imageUrl;
            }

            return Scaffold(
              backgroundColor: bgColor,
              appBar: AppBar(
                title: Text('Edit Your Card'),
                backgroundColor: bgColor,
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey, // Add _formKey here
                    child: Column(
                      children: <Widget>[
                        Container(
                          width: 150.0,
                          height: 150.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: image != null
                              ? Image.file(
                                  image!,
                                  fit: BoxFit.cover,
                                )
                              : Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        SizedBox(height: 12.0),
                        TextFormField(
                          key: _cardName,
                          initialValue: selectedCard.cardName,
                          decoration: InputDecoration(
                            hintText: 'Insert Name',
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter a Card name' : null,
                          onChanged: (val) {
                            setState(() => newCardName = val);
                          },
                        ),
                        SizedBox(height: 12.0),
                        TextFormField(
                          key: _companyNameKey,
                          initialValue: selectedCard.companyName,
                          decoration: InputDecoration(
                            hintText: 'New Company Name',
                            prefixIcon: Icon(Icons.business),
                          ),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter a company name' : null,
                          onChanged: (val) {
                            setState(() => newCompanyName = val);
                          },
                        ),
                        SizedBox(height: 12.0),
                        TextFormField(
                          key: _jobTitleKey,
                          initialValue: selectedCard.jobTitle,
                          decoration: InputDecoration(
                            hintText: 'New Job Title',
                            prefixIcon: Icon(Icons.work),
                          ),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter a job title' : null,
                          onChanged: (val) {
                            setState(() => newJobTitle = val);
                          },
                        ),
                        SizedBox(height: 12.0),
                        TextFormField(
                          key: _phoneNumKey,
                          initialValue: selectedCard.phoneNum,
                          decoration: InputDecoration(
                            hintText: 'New Phone Number',
                            prefixIcon: Icon(Icons.phone),
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Enter a phone number';
                            }
                            //(+ and integers only)
                            RegExp regex = RegExp(r'^\+?[0-9 ]+$');
                            if (!regex.hasMatch(val)) {
                              return 'Invalid phone number';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            setState(() => newPhoneNum = val);
                          },
                        ),
                        SizedBox(height: 12.0),
                        TextFormField(
                          key: _emailKey,
                          initialValue: selectedCard.email,
                          decoration: InputDecoration(
                            hintText: 'New Email',
                            prefixIcon: Icon(Icons.mail),
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Enter an email';
                            }
                            // must contain @
                            if (!val.contains('@')) {
                              return 'Invalid email';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            setState(() => newEmail = val);
                          },
                        ),
                        SizedBox(height: 12.0),
                        TextFormField(
                          key: _websiteKey,
                          initialValue: selectedCard.companyWebsite,
                          decoration: InputDecoration(
                            hintText: 'New Website',
                            prefixIcon: Icon(Icons.language),
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Enter a website';
                            }
                            //must contain www.
                            if (!val.startsWith('www.')) {
                              return 'Website must start with www.';
                            }
                            return null;
                          },
                          onChanged: (val) {
                            setState(() => newWebsite = val);
                          },
                        ),
                        SizedBox(height: 12.0),
                        TextFormField(
                          key: _addressKey,
                          initialValue: selectedCard.companyAddress,
                          decoration: InputDecoration(
                            hintText: 'New Company Address',
                            prefixIcon: Icon(Icons.location_city),
                          ),
                          onChanged: (val) {
                            setState(() => newAddress = val);
                          },
                        ),
                        SizedBox(height: 12.0),
                        TextFormField(
                          key: _personalStatementKey,
                          initialValue: selectedCard.personalStatement,
                          decoration: InputDecoration(
                            hintText: 'New Personal Statement',
                            prefixIcon: Icon(Icons.comment),
                          ),
                          onChanged: (val) {
                            setState(() => newPersonalStatement = val);
                          },
                        ),
                        SizedBox(height: 12.0),
                        TextFormField(
                          key: _moreInfoKey,
                          initialValue: selectedCard.moreInfo,
                          decoration: InputDecoration(
                            hintText: 'More Information',
                            prefixIcon: Icon(Icons.info),
                          ),
                          maxLines: 10, // MAX LINE TO WRITE
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          onChanged: (val) {
                            setState(() => newMoreInfo = val);
                          },
                        ),
                        SizedBox(height: 12.0),
                        Row(children: <Widget>[
                          SizedBox(width: 130.0),
                          ElevatedButton(
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                // Check if each field is empty, if not use previous values
                                final updateImageUrl = imageUrl.isNotEmpty
                                    ? imageUrl
                                    : selectedCard.imageUrl;
                                final updatedCardName = newCardName.isNotEmpty
                                    ? newCardName
                                    : selectedCard.cardName;
                                final updatedCompanyName =
                                    newCompanyName.isNotEmpty
                                        ? newCompanyName
                                        : selectedCard.companyName;
                                final updatedJobTitle = newJobTitle.isNotEmpty
                                    ? newJobTitle
                                    : selectedCard.jobTitle;
                                final updatedPhoneNum = newPhoneNum.isNotEmpty
                                    ? newPhoneNum
                                    : selectedCard.phoneNum;
                                final updatedEmail = newEmail.isNotEmpty
                                    ? newEmail
                                    : selectedCard.email;
                                final updatedWebsite = newWebsite.isNotEmpty
                                    ? newWebsite
                                    : selectedCard.companyWebsite;
                                final updatedAddress = newAddress.isNotEmpty
                                    ? newAddress
                                    : selectedCard.companyAddress;
                                final updatedPersonalStatement =
                                    newPersonalStatement.isNotEmpty
                                        ? newPersonalStatement
                                        : selectedCard.personalStatement;
                                final updatedMoreInfo = newMoreInfo.isNotEmpty
                                    ? newMoreInfo
                                    : selectedCard.moreInfo;

                                bool isDuplicateCardName = listOfCards.any(
                                    (card) =>
                                        card.cardName == updatedCardName &&
                                        card.cardName != widget.selectedCard);

                                //Checker to see if card name already exists
                                if (isDuplicateCardName) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Card name already exists. Please enter a different card name.'),
                                    ),
                                  );
                                  return;
                                } else {
                                  Cards updatedCard = Cards(
                                    imageUrl: updateImageUrl,
                                    cardName: updatedCardName,
                                    companyName: updatedCompanyName,
                                    jobTitle: updatedJobTitle,
                                    phoneNum: updatedPhoneNum,
                                    email: updatedEmail,
                                    companyWebsite: updatedWebsite,
                                    companyAddress: updatedAddress,
                                    personalStatement: updatedPersonalStatement,
                                    moreInfo: updatedMoreInfo,
                                  );

                                  List<Cards> newListOfCards =
                                      listOfCards.map((card) {
                                    final selectedCardName =
                                        widget.selectedCard;
                                    if (card.cardName == selectedCardName) {
                                      return updatedCard;
                                    } else {
                                      return card;
                                    }
                                  }).toList();

                                  await databaseService.updateFriendDatabase(
                                    friendsData.listOfFriends,
                                    friendsData.listOfFriendRequestsSent,
                                    friendsData.listOfFriendRequestsRec,
                                    newListOfCards,
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PhysicalCardPage()),
                                  );
                                }
                              }
                            },
                            child: Text(
                              'Confirm Edit',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          SizedBox(width: 12.0),
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  // Pop up to confirm delete
                                  return AlertDialog(
                                    title:
                                        Center(child: Text('Confirm Delete')),
                                    content: Text(
                                        'Are you sure you want to delete?'),
                                    actions: <Widget>[
                                      Center(
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            TextButton(
                                              child: Text('Yes'),
                                              onPressed: () async {
                                                if (listOfCards.length == 1) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                          'You must have at least one card.'),
                                                    ),
                                                  );
                                                  return;
                                                } else {
                                                  List<Cards>
                                                      updatedListOfCards =
                                                      listOfCards
                                                          .where((card) =>
                                                              card.cardName !=
                                                              widget
                                                                  .selectedCard)
                                                          .toList();
                                                  await databaseService
                                                      .updateFriendDatabase(
                                                    friendsData.listOfFriends,
                                                    friendsData
                                                        .listOfFriendRequestsSent,
                                                    friendsData
                                                        .listOfFriendRequestsRec,
                                                    updatedListOfCards,
                                                  );

                                                  // Navigate to the Home screen
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PhysicalCardPage()),
                                                  );
                                                }
                                              },
                                            ),
                                            TextButton(
                                              child: Text('No'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          )
                        ]),
                      ],
                    ),
                  ),
                ),
              ),
            );
          } else {
            return Loading();
          }
        },
      );
    } else {
      return Loading();
    }
  }
}
