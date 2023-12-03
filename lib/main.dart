
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projet_sem3_flutter/screens/auth/auth_route.dart';
import 'package:projet_sem3_flutter/screens/auth/login_screen.dart';
import 'package:projet_sem3_flutter/screens/auth/register_screen.dart';
import 'package:projet_sem3_flutter/screens/bottom_bar.dart';
import 'package:projet_sem3_flutter/screens/home_screen.dart';

import 'package:projet_sem3_flutter/screens/profile_screen.dart';

import 'admin/screens/home_admin_screen.dart';

import 'package:onesignal_flutter/onesignal_flutter.dart';



void main() async {


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyB2PVR8c6IfmBRLVDs6lEDBv_Pem77RBqI",
      appId: "1:239139751033:android:cfa97e1720569caa37c0a8",
      messagingSenderId: "239139751033",
      projectId: "semiot-d539e",
    ),
  );


  runApp(

        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              scaffoldBackgroundColor: const Color(0xFFFFFFFF),
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




