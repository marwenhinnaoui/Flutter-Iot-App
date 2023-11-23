
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projet_sem3_flutter/screens/auth/auth_route.dart';
import 'package:projet_sem3_flutter/screens/auth/login_screen.dart';
import 'package:projet_sem3_flutter/screens/auth/register_screen.dart';
import 'package:projet_sem3_flutter/screens/bottom_bar.dart';
import 'package:projet_sem3_flutter/screens/home_screen.dart';

import 'package:projet_sem3_flutter/screens/profile_screen.dart';

import 'admin/screens/home_admin_screen.dart';




void main() async {


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyCrWFcldy2lOaZa1dk-Y4Qy-E9cJCNFCEU",
      appId: "1:282229285407:android:abc05161274d54a3cc2b2a",
      messagingSenderId: "282229285407",
      projectId: "smart-house-sem3",
    ),
  );


  runApp(

        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Color(0xffFE725E)),
            useMaterial3: true
          ),

          initialRoute: 'auth',
          routes: <String, WidgetBuilder>{
            'auth': (context) => authRoute(),
            'login': (context) => Login(),

            'bottombar': (context) => BottomBar(),
            'profile': (context) => ProfileScreen(),
            'home': (context) => HomeScreen(),
            'home_admin': (context) => HomeAdminScreen(),
          },

  )
  );
}




