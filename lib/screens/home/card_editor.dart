import 'dart:io';

import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/services/database.dart';
import 'package:connectcard/shared/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'home.dart';

// Screen for users to be able to edit the information of their cards
class CardEditorScreen extends StatefulWidget {
  final String selectedCard;
  const CardEditorScreen({required this.selectedCard});

  @override
  _CardEditorScreenState createState() => _CardEditorScreenState();
}

class _CardEditorScreenState extends State<CardEditorScreen> {
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

  // Function to show the image picker dialog (Pop up)
  Future<void> _showImagePickerDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Select an Image')),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(ImageSource.camera);
                },
                child: CircleAvatar(
                  radius: 32.0,
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.camera_alt,
                    size: 32.0,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(width: 16.0),
              GestureDetector(
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickImage(ImageSource.gallery);
                },
                child: CircleAvatar(
                  radius: 32.0,
                  backgroundColor: Colors.transparent,
                  child: Icon(
                    Icons.photo_library,
                    size: 32.0,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // Pick image from camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: source);
    if (file == null) {
      return;
    }
    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    // Upload the file to Firebase Storage
    try {
      // Store the file
      await referenceImageToUpload.putFile(File(file.path));

      // Success: get the download URL
      imageUrl = await referenceImageToUpload.getDownloadURL();
    } catch (error) {
      // Incase some error occured
      print(error);
    }

    // Update the UI
    setState(() {
      if (file != null) {
        image = File(file.path);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<TheUser?>(context); // Retrieve user object
    if (user != null) {
      return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user!.uid).userProfile,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;

            // Find the selected card based on its name
            Cards selectedCard = userData!.listOfCards.firstWhere(
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
                        GestureDetector(
                          onTap: () => _showImagePickerDialog(),
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey,
                            ),
                            child: imageUrl.isNotEmpty
                                ? ClipOval(
                                    child: image != null
                                        ? Image.file(
                                            image!,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            imageUrl,
                                            fit: BoxFit.cover,
                                          ),
                                  )
                                : Icon(
                                    Icons.add_a_photo,
                                    size: 50,
                                    color: Colors.white,
                                  ),
                          ),
                        ),
                        SizedBox(height: 12.0),
                        TextFormField(
                          key: _cardName,
                          initialValue: selectedCard.cardName,
                          decoration: InputDecoration(
                            hintText: 'New Card Name',
                            prefixIcon: Icon(Icons.card_membership),
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
                            RegExp regex = RegExp(r'^\+?[0-9]+$');
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
                          validator: (val) =>
                              val!.isEmpty ? 'Enter a Address' : null,
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
                          validator: (val) => val!.isEmpty
                              ? 'Enter a personal statement'
                              : null,
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

                                bool isDuplicateCardName = userData.listOfCards
                                    .any((card) =>
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
                                      userData.listOfCards.map((card) {
                                    final selectedCardName =
                                        widget.selectedCard;
                                    if (card.cardName == selectedCardName) {
                                      return updatedCard;
                                    } else {
                                      return card;
                                    }
                                  }).toList();

                                  await DatabaseService(uid: user!.uid)
                                      .updateUserData(
                                    userData.name,
                                    userData.headLine,
                                    userData.profilePic,
                                    newListOfCards,
                                  );
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Home()),
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
                                                if (userData
                                                        .listOfCards.length ==
                                                    1) {
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
                                                      userData.listOfCards
                                                          .where((card) =>
                                                              card.cardName !=
                                                              widget
                                                                  .selectedCard)
                                                          .toList();
                                                  await DatabaseService(
                                                          uid: user!.uid)
                                                      .updateUserData(
                                                    userData.name,
                                                    userData.headLine,
                                                    userData.profilePic,
                                                    updatedListOfCards,
                                                  );
                                                  // Navigate to the Home screen
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            Home()),
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
