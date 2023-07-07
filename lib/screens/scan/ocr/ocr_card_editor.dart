// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:provider/provider.dart';

// class OCRCardEditorScreen extends StatefulWidget {
//   const OCRCardEditorScreen();

//   @override
//   _OCRCardEditorScreenState createState() => _OCRCardEditorScreenState();
// }

// class _OCRCardEditorScreenState extends State<OCRCardEditorScreen> {
//   final _formKey = GlobalKey<FormState>();
//   final _imageUrl = GlobalKey<FormState>();
//   final _cardName = GlobalKey<FormState>();
//   final _companyNameKey = GlobalKey<FormState>();
//   final _jobTitleKey = GlobalKey<FormState>();
//   final _phoneNumKey = GlobalKey<FormState>();
//   final _emailKey = GlobalKey<FormState>();
//   final _websiteKey = GlobalKey<FormState>();
//   final _addressKey = GlobalKey<FormState>();
//   final _personalStatementKey = GlobalKey<FormState>();
//   final _moreInfoKey = GlobalKey<FormState>();

//   TheUser? user; // User object
//   String imageUrl = '';
//   String newCardName = '';
//   String newCompanyName = '';
//   String newJobTitle = '';
//   String newPhoneNum = '';
//   String newEmail = '';
//   String newWebsite = '';
//   String newAddress = '';
//   String newPersonalStatement = '';
//   String newMoreInfo = '';
//   File? image;

//   Color bgColor = const Color(0xffFEAA1B);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Card Editor'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 // Image URL Field
//                 TextFormField(
//                   key: _imageUrl,
//                   decoration: const InputDecoration(labelText: 'Image URL'),
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter an image URL.';
//                     }
//                     return null;
//                   },
//                   onChanged: (value) {
//                     setState(() {
//                       imageUrl = value;
//                     });
//                   },
//                 ),
//                 // Rest of the form fields...
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate()) {
//                       // Save the card data
//                       _saveCardData();
//                     }
//                   },
//                   child: const Text('Save'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void _saveCardData() {
//     // Implement the logic to save card data
//     // Retrieve form field values and store them in the respective variables
//     // Perform any additional operations as needed
//     // For example:
//     newCardName = _cardName.currentState!.value.toString();
//     newCompanyName = _companyNameKey.currentState!.value.toString();
//     newJobTitle = _jobTitleKey.currentState!.value.toString();
//     newPhoneNum = _phoneNumKey.currentState!.value.toString();
//     newEmail = _emailKey.currentState!.value.toString();
//     newWebsite = _websiteKey.currentState!.value.toString();
//     newAddress = _addressKey.currentState!.value.toString();
//     newPersonalStatement = _personalStatementKey.currentState!.value.toString();
//     newMoreInfo = _moreInfoKey.currentState!.value.toString();

//     // Create a new card object using the retrieved data
//     final newCard = Card(
//       cardName: newCardName,
//       companyName: newCompanyName,
//       jobTitle: newJobTitle,
//       phoneNum: newPhoneNum,
//       email: newEmail,
//       website: newWebsite,
//       address: newAddress,
//       personalStatement: newPersonalStatement,
//       moreInfo: newMoreInfo,
//       imageUrl: imageUrl,
//     );

//     // Perform any further actions with the new card object (e.g., save to a database)
//     // ...
//   }
// }

// class TheUser {
//   // User class implementation
//   // ...
// }

// class Card {
//   final String cardName;
//   final String companyName;
//   final String jobTitle;
//   final String phoneNum;
//   final String email;
//   final String website;
//   final String address;
//   final String personalStatement;
//   final String moreInfo;
//   final String imageUrl;

//   Card({
//     required this.cardName,
//     required this.companyName,
//     required this.jobTitle,
//     required this.phoneNum,
//     required this.email,
//     required this.website,
//     required this.address,
//     required this.personalStatement,
//     required this.moreInfo,
//     required this.imageUrl,
//   });
// }

// void main() {
//   runApp(MaterialApp(
//     title: 'Card Editor',
//     home: OCRCardEditorScreen(),
//   ));
// }
