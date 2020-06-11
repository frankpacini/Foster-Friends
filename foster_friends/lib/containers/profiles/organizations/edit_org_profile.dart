import 'package:flutter/material.dart';
import 'package:foster_friends/state/appState.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:foster_friends/database.dart';

// Define a custom Form widget.
class EditOrgProfile extends StatefulWidget {
  final data;
  EditOrgProfile(this.data);

  @override
  EditOrgState createState() {
    return EditOrgState(this.data);
  }
}



class EditOrgState extends State<EditOrgProfile> {
  
  @override
  void initState() {
    super.initState();
    //setting local variables
    
  }

  Map<String, dynamic> data;

  EditOrgState(this.data);

  @override
  void dispose() {
    // store.dispatch(getFirebaseUser);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Text("hi");
  } 
}
