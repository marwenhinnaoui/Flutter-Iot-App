import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../widgets/snackbar.dart';
import 'auth/auth.dart';

class HomeScreen extends StatefulWidget{
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


  @override
  Widget build(BuildContext context) {
    return(
      Scaffold(
        appBar:AppBar(
          // leading: SizedBox(
          //   width: 100,
          //   child: Text(
          //     'Welcome back !'
          //   ),
          // ),
          actions: [
            IconButton(
              onPressed: () async{
                String? SignoutStatus = '';
                String? color = 'success';
                try{

                  await Auth().fireAuth.signOut();
                  print('Signout pressed');
                  SignoutStatus = 'Signout Success';
                  Navigator.of(context).pushNamedAndRemoveUntil('login' , (Route <dynamic> route ) => false);

                } on FirebaseAuthException catch(e){
                  SignoutStatus=e.code;
                  color ='danger';
                }
                final snackBar = CustomSnackBar.showErrorSnackBar(SignoutStatus, color);
                ScaffoldMessenger.of(context).showSnackBar(snackBar);


              },
              icon: Icon(Icons.logout_sharp),
            )
          ],
        ) ,
        body: Text(
          'User'
        ),
      )
    );
  }
}