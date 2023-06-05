import 'package:connectcard/models/theUser.dart';
import 'package:connectcard/services/database.dart';
import 'package:connectcard/shared/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CardEditorScreen extends StatefulWidget {
  @override
  _CardEditorScreenState createState() => _CardEditorScreenState();
}

class _CardEditorScreenState extends State<CardEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameKey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  final _phoneNumKey = GlobalKey<FormState>();
  final _addressKey = GlobalKey<FormState>();
  final _jobTitleKey = GlobalKey<FormState>();
  final _moreInfoKey = GlobalKey<FormState>();

  TheUser? user; // User object
  String newName = '';
  String newEmail = '';
  String newPhoneNum = '';
  String newAddress = '';
  String newJobTitle = '';
  String newMoreInfo = '';

  @override
  Widget build(BuildContext context) {
    user = Provider.of<TheUser?>(context); // Retrieve user object
    if (user != null) {
      return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user!.uid).userProfile,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData? userData = snapshot.data;

            return Scaffold(
              backgroundColor: Colors.yellow[800],
              appBar: AppBar(
                title: Text('Edit Your Profile'),
                backgroundColor: Colors.yellow[800],
              ),
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey, // Add _formKey here
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          key: _nameKey,
                          initialValue: userData!.name,
                          decoration: InputDecoration(
                            hintText: 'New Name',
                            prefixIcon: Icon(Icons.person),
                          ),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter a name' : null,
                          onChanged: (val) {
                            setState(() => newName = val);
                          },
                        ),
                        SizedBox(height: 12.0),
                        TextFormField(
                          key: _emailKey,
                          initialValue: userData!.email,
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
                          key: _phoneNumKey,
                          initialValue: userData!.phoneNum,
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
                          key: _addressKey,
                          initialValue: userData!.address,
                          decoration: InputDecoration(
                            hintText: 'New Address',
                            prefixIcon: Icon(Icons.location_city),
                          ),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter an address' : null,
                          onChanged: (val) {
                            setState(() => newAddress = val);
                          },
                        ),
                        SizedBox(height: 12.0),
                        TextFormField(
                          key: _jobTitleKey,
                          initialValue: userData!.jobTitle,
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
                          key: _moreInfoKey,
                          initialValue: userData!.moreInfo,
                          decoration: InputDecoration(
                            hintText: 'New Information',
                            prefixIcon: Icon(Icons.info),
                          ),
                          validator: (val) =>
                              val!.isEmpty ? 'Enter information' : null,
                          onChanged: (val) {
                            setState(() => newMoreInfo = val);
                          },
                        ),
                        SizedBox(height: 12.0),
                        ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              // Check if each field is empty or not
                              final updatedName =
                                  newName.isNotEmpty ? newName : userData!.name;
                              final updatedEmail = newEmail.isNotEmpty
                                  ? newEmail
                                  : userData!.email;
                              final updatedPhoneNum = newPhoneNum.isNotEmpty
                                  ? newPhoneNum
                                  : userData!.phoneNum;
                              final updatedAddress = newAddress.isNotEmpty
                                  ? newAddress
                                  : userData!.address;
                              final updatedJobTitle = newJobTitle.isNotEmpty
                                  ? newJobTitle
                                  : userData!.jobTitle;
                              final updatedMoreInfo = newMoreInfo.isNotEmpty
                                  ? newMoreInfo
                                  : userData!.moreInfo;

                              await DatabaseService(uid: user!.uid)
                                  .updateUserData(
                                updatedName,
                                updatedEmail,
                                updatedPhoneNum,
                                updatedAddress,
                                updatedJobTitle,
                                updatedMoreInfo,
                              );
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
