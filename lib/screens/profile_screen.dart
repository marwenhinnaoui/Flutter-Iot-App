import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'auth/auth.dart';

class ProfileScreen extends StatefulWidget{
  ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() =>  _ProfileScreenState();

}

Future<void> getUserData(Map<String, dynamic> userData) async{


  CollectionReference users = FirebaseFirestore.instance.collection('users');

// Get the user's document
  DocumentSnapshot userDoc = await users.doc(Auth().currentUser?.uid).get();

// Access data from the document
  if (userDoc.exists) {
    userData.addAll(userDoc.data() as Map<String, dynamic>);

    print('User Data: $userData');
  } else {
    print('User document does not exist');

  }
}
class _ProfileScreenState extends State<ProfileScreen>  {
   Map<String, dynamic> userData ={};

  @override
  Widget build(BuildContext context) {

    return(
    Scaffold(
      body:
      Container(
        child: Text(
            'dffd'
        ),
      ),
    )
    );
  }
}






