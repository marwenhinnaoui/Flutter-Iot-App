import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projet_sem3_flutter/screens/auth/auth.dart';
import 'package:projet_sem3_flutter/screens/auth/login_screen.dart';
import '../../admin/screens/home_admin_screen.dart';
import '../bottom_bar.dart';

class authRoute extends StatefulWidget {
  @override
  State<authRoute> createState() => _AuthRouteState();
}

class _AuthRouteState extends State<authRoute> {
  late Stream<User?> _authStream;

  @override
  void initState() {
    super.initState();
    _authStream = Auth().authStateHandle;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(stream: Auth().authStateHandle, builder: (context, snpashot){





      String routeRedirect = '';

      // void getUser() async {
      //   try {
      //     DocumentSnapshot<Map<String, dynamic>> snapshotDoc =
      //     await FirebaseFirestore.instance
      //         .collection('users')
      //         .doc(snpashot.data?.uid)
      //         .get();
      //
      //     if (snapshotDoc.exists) {
      //
      //       Map<String, dynamic> userData  = snapshotDoc.data()!;
      //       if(userData['admin'] == true){
      //         routeRedirect = 'true';
      //       }else if(userData['admin'] == false){
      //         routeRedirect = 'false';
      //       }
      //
      //
      //
      //
      //
      //
      //
      //
      //
      //       // You can use userData as needed in your application.
      //     } else {
      //       // User data not found
      //       print('User not found in Firestore');
      //     }
      //   } catch (e) {
      //     print('Error getting user data: $e');
      //   }
      // }



        return  Login();
      },
    );
  }
}
