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
  Map<String, dynamic> userData = {};

  @override
  void initState() {
    super.initState();
    // Call the function to get user data when the screen is initialized
    getUserData();
  }

  Future<void> getUserData() async {
    // Ensure there is a current user before trying to fetch data
    if (Auth().currentUser != null) {
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      // Get the user's document
      DocumentSnapshot userDoc = await users.doc(Auth().currentUser!.uid).get();

      // Access data from the document
      if (userDoc.exists) {
        setState(() {
          userData.addAll(userDoc.data() as Map<String, dynamic>);
        });
        print('User Data: $userData');
      } else {
        print('User document does not exist');
      }
    } else {
      print('No current user');
    }
  }

  @override
  Widget build(BuildContext context) {

    return(
    Scaffold(
      appBar: AppBar(
        backgroundColor:                Color(0xFFFFFFFF),
        leading: new IconButton(onPressed: () => {Navigator.of(context).pop()}, icon: Icon(Icons.keyboard_arrow_left),),

        title: Text(
          'Profile'
        ),
      ),
      body:
      Container(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 50,),
              ClipOval(
                child: Image.asset("assets/img/profile.png", width: 150,),
              ),
              SizedBox(height: 15,),


              Card(
                  surfaceTintColor:Color(0xFFFFFFFF),
                  color:  Color(0xFFFFFFFF),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Name: ${userData['fullname']}', style: TextStyle(
                        fontSize: 17
                    ),),
                  )
              ),
              SizedBox(height: 5,),
              Card(
                  surfaceTintColor:Color(0xFFFFFFFF),
                  color:  Color(0xFFFFFFFF),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Email: ${userData['email']}', style: TextStyle(
                        fontSize: 17
                    ),),
                  )
              ),
              SizedBox(height: 5,),
              Card(
                  surfaceTintColor:Color(0xFFFFFFFF),
                  color:  Color(0xFFFFFFFF),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Phone: ${userData['phone']}', style: TextStyle(
                        fontSize: 17
                    ),),
                  )
              ),
              SizedBox(height: 5,),


            ],
          ),
        )
      ),
    )
    );
  }
}






