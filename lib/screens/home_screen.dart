
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:projet_sem3_flutter/screens/auth/login_screen.dart';

import '../widgets/snackbar.dart';
import 'auth/auth.dart';



class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final User? user = Auth().currentUser;



  Widget userEmail(){
    return (
      Text(
        'Email ${user?.email}'
      )
    );
  }

  Widget signOutButton(context){
    return (
      IconButton(
        onPressed: () async{
          String? SignoutStatus = '';



          try{

            await Auth().fireAuth.signOut();
            print('Signout pressed');
            SignoutStatus = 'Signout Success';
            Navigator.of(context).pushNamedAndRemoveUntil('login' , (Route <dynamic> route ) => false);

          } on FirebaseAuthException catch(e){
            SignoutStatus=e.code;
          }
          final snackBar = CustomSnackBar.showErrorSnackBar('Sign out success');
          ScaffoldMessenger.of(context).showSnackBar(snackBar);


        },
        icon: Icon(Icons.logout),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return(
       Scaffold(
        appBar: AppBar(
          title: Text(
            style: TextStyle(
              color: Colors.white,

            ),
            'Home page'
          ),
          actions: [
            signOutButton(context)
          ],

        ),
      )
    );
  }
}