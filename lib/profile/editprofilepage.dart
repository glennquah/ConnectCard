import 'dart:io';

import 'package:connectcard/models/TheUser.dart';
import 'package:connectcard/services/database.dart';
import 'package:connectcard/shared/loading.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _editprofileKey = GlobalKey<FormState>();

  final _Name = GlobalKey<FormState>();
  String newName = '';
  final _Headline = GlobalKey<FormState>();
  String newHeadline = '';

  File? image;
  String profilepicUrl = '';

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<TheUser?>(context);

    if (user != null) {
      return StreamBuilder<UserData>(
          stream: DatabaseService(uid: user.uid).userProfile,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              UserData? userData = snapshot.data;

              if (profilepicUrl.isEmpty) {
                profilepicUrl = userData!.profilePic;
              }

              return Scaffold(
                backgroundColor: const Color(0xffFEAA1B),
                appBar: AppBar(
                  title: Text('Edit Profile'),
                  backgroundColor: const Color(0xffFEAA1B),
                ),
                body: SingleChildScrollView(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () => _showImagePickerDialog(),
                        child: Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey,
                          ),
                          child: profilepicUrl.isNotEmpty
                              ? ClipOval(
                                  child: image != null
                                      ? Image.file(
                                          image!,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.network(
                                          profilepicUrl,
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
                      SizedBox(height: 20.0),
                      Text(
                        'Edit Name',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        initialValue: userData!.name,
                        decoration: InputDecoration(
                          hintText: 'New Name',
                          prefixIcon: Icon(Icons.person),
                        ),
                        onChanged: (val) {
                          setState(() => newName = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      Text(
                        'Edit Headline',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextFormField(
                        initialValue: userData.headLine,
                        decoration: InputDecoration(
                          hintText: 'New Headline',
                          prefixIcon: Icon(Icons.text_fields),
                        ),
                        onChanged: (val) {
                          setState(() => newHeadline = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        onPressed: () async {
                          await DatabaseService(uid: user.uid).updateUserData(
                            newName.isNotEmpty ? newName : userData.name,
                            newHeadline.isNotEmpty
                                ? newHeadline
                                : userData.headLine,
                            profilepicUrl.isNotEmpty
                                ? profilepicUrl
                                : userData.profilePic,
                            userData.listOfCards,
                            userData.listOfFriends,
                            userData.listOfFriendRequests,
                          );
                          Navigator.pop(
                              context); // Navigate back to the previous page
                        },
                        child: Text(
                          'Save Changes',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Loading();
            }
          });
    } else {
      return Loading(); // Show a loading indicator if user is null
    }
  }

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
      profilepicUrl = await referenceImageToUpload.getDownloadURL();
    } catch (error) {
      // In case some error occurred
      print(error);
    }

    // Update the UI
    setState(() {
      if (file != null) {
        image = File(file.path);
      }
    });
  }
}