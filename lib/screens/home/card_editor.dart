import 'dart:io';

import 'package:connectcard/models/Cards.dart';
import 'package:connectcard/models/theUser.dart';
import 'package:connectcard/services/database.dart';
import 'package:connectcard/shared/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CardEditorScreen extends StatefulWidget {
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
  final _moreInfo1Key = GlobalKey<FormState>();
  final _moreInfo2Key = GlobalKey<FormState>();
  final _moreInfo3Key = GlobalKey<FormState>();

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
  String newMoreInfo1 = '';
  String newMoreInfo2 = '';
  String newMoreInfo3 = '';
  File? image;

  Future<void> _pickImage(ImageSource source) async {
    ImagePicker imagePicker = ImagePicker();
    //XFile? file = await imagePicker.pickImage(source: ImageSource.camera);
    XFile? file = await imagePicker.pickImage(source: source);
    if (file == null) {
      return;
    }

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      // Store the file
      await referenceImageToUpload.putFile(File(file.path));

      // Success: get the download URL
      imageUrl = await referenceImageToUpload.getDownloadURL();
    } catch (error) {
      // Some error occurred
      print(error);
    }

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

            if (imageUrl.isEmpty) {
              imageUrl = userData!.listOfCards.first.imageUrl;
            }

            return Scaffold(
              backgroundColor: Colors.yellow[800],
              appBar: AppBar(
                title: Text('Edit Your Card'),
                backgroundColor: Colors.yellow[800],
              ),
              body: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey, // Add _formKey here
                    child: Column(
                      children: <Widget>[
                        GestureDetector(
                          onTap: () => _pickImage(ImageSource.gallery),
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
                          initialValue: userData!.listOfCards.first.cardName,
                          decoration: InputDecoration(
                            hintText: 'New Card Name',
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
                          initialValue: userData!.listOfCards.first.companyName,
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
                          initialValue: userData.listOfCards.first.jobTitle,
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
                          initialValue: userData.listOfCards.first.phoneNum,
                          decoration: InputDecoration(
                            hintText: 'New Phone Number',
                            prefixIcon: Icon(Icons.phone),
                          ),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter a phone number' : null,
                          onChanged: (val) {
                            setState(() => newPhoneNum = val);
                          },
                        ),
                        SizedBox(height: 12.0),
                        TextFormField(
                          key: _emailKey,
                          initialValue: userData.listOfCards.first.email,
                          decoration: InputDecoration(
                            hintText: 'New Email',
                            prefixIcon: Icon(Icons.mail),
                          ),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter an email' : null,
                          onChanged: (val) {
                            setState(() => newEmail = val);
                          },
                        ),
                        SizedBox(height: 12.0),
                        TextFormField(
                          key: _websiteKey,
                          initialValue:
                              userData.listOfCards.first.companyWebsite,
                          decoration: InputDecoration(
                            hintText: 'New Website',
                            prefixIcon: Icon(Icons.language),
                          ),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter a website' : null,
                          onChanged: (val) {
                            setState(() => newWebsite = val);
                          },
                        ),
                        SizedBox(height: 12.0),
                        TextFormField(
                          key: _addressKey,
                          initialValue:
                              userData.listOfCards.first.companyAddress,
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
                          initialValue:
                              userData.listOfCards.first.personalStatement,
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
                          key: _moreInfo1Key,
                          initialValue: userData.listOfCards.first.moreInfo1,
                          decoration: InputDecoration(
                            hintText: 'New Additional Information',
                            prefixIcon: Icon(Icons.info),
                          ),
                          validator: (val) => val!.isEmpty
                              ? 'Enter additional information'
                              : null,
                          onChanged: (val) {
                            setState(() => newMoreInfo1 = val);
                          },
                        ),
                        SizedBox(height: 12.0),
                        TextFormField(
                          key: _moreInfo2Key,
                          initialValue: userData.listOfCards.first.moreInfo2,
                          decoration: InputDecoration(
                            hintText: 'New Additional Information',
                            prefixIcon: Icon(Icons.info),
                          ),
                          validator: (val) => val!.isEmpty
                              ? 'Enter additional information'
                              : null,
                          onChanged: (val) {
                            setState(() => newMoreInfo2 = val);
                          },
                        ),
                        SizedBox(height: 12.0),
                        TextFormField(
                          key: _moreInfo3Key,
                          initialValue: userData.listOfCards.first.moreInfo3,
                          decoration: InputDecoration(
                            hintText: 'New Additional Information',
                            prefixIcon: Icon(Icons.info),
                          ),
                          validator: (val) => val!.isEmpty
                              ? 'Enter additional information'
                              : null,
                          onChanged: (val) {
                            setState(() => newMoreInfo3 = val);
                          },
                        ),
                        SizedBox(height: 12.0),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // Check if each field is empty or not
                              final updateImageUrl = imageUrl.isNotEmpty
                                  ? imageUrl
                                  : userData.listOfCards.first.imageUrl;
                              final updatedCardName = newCardName.isNotEmpty
                                  ? newCardName
                                  : userData.listOfCards.first.cardName;
                              final updatedCompanyName =
                                  newCompanyName.isNotEmpty
                                      ? newCompanyName
                                      : userData.listOfCards.first.companyName;
                              final updatedJobTitle = newJobTitle.isNotEmpty
                                  ? newJobTitle
                                  : userData.listOfCards.first.jobTitle;
                              final updatedPhoneNum = newPhoneNum.isNotEmpty
                                  ? newPhoneNum
                                  : userData.listOfCards.first.phoneNum;
                              final updatedEmail = newEmail.isNotEmpty
                                  ? newEmail
                                  : userData.listOfCards.first.email;
                              final updatedWebsite = newWebsite.isNotEmpty
                                  ? newWebsite
                                  : userData.listOfCards.first.companyWebsite;
                              final updatedAddress = newAddress.isNotEmpty
                                  ? newAddress
                                  : userData.listOfCards.first.companyAddress;
                              final updatedPersonalStatement =
                                  newPersonalStatement.isNotEmpty
                                      ? newPersonalStatement
                                      : userData
                                          .listOfCards.first.personalStatement;
                              final updatedMoreInfo1 = newMoreInfo1.isNotEmpty
                                  ? newMoreInfo1
                                  : userData.listOfCards.first.moreInfo1;
                              final updatedMoreInfo2 = newMoreInfo2.isNotEmpty
                                  ? newMoreInfo2
                                  : userData.listOfCards.first.moreInfo2;
                              final updatedMoreInfo3 = newMoreInfo3.isNotEmpty
                                  ? newMoreInfo3
                                  : userData.listOfCards.first.moreInfo3;

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
                                moreInfo1: updatedMoreInfo1,
                                moreInfo2: updatedMoreInfo2,
                                moreInfo3: updatedMoreInfo3,
                              );

                              List<Cards> newListOfCards = [updatedCard];
                              //userData.listOfCards[0] = updatedCard;

                              await DatabaseService(uid: user!.uid)
                                  .updateUserData(
                                      userData.name, newListOfCards);
                              Navigator.pop(context);
                            }
                          },
                          child: Text(
                            'Confirm Edit',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
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
