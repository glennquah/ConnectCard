import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectcard/models/userDetails.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileList extends StatefulWidget {
  @override
  _ProfileListState createState() => _ProfileListState();
}

class _ProfileListState extends State<ProfileList> {
  @override
  Widget build(BuildContext context) {
    final profiles = Provider.of<List<UserDetails>>(context);
    profiles.forEach((UserDetail) {
      print(UserDetail.phoneNum);
      print(UserDetail.address);
      print(UserDetail.jobTitle);
      print(UserDetail.moreInfo);
    });

    return Container(
        //child: Text('Profile List'),
        );
  }
}
