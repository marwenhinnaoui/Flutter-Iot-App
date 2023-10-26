import 'dart:js';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:projet_sem3_flutter/screens/auth/auth_route.dart';
import 'package:projet_sem3_flutter/screens/auth/login_screen.dart';
import 'package:projet_sem3_flutter/screens/auth/register_screen.dart';
import 'package:projet_sem3_flutter/screens/home_screen.dart';




void main() async {


  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: "AIzaSyDdY5jg5S_8j-ZniXcQFIbwvWiCa-KzQGo",
      appId: "1:432232439708:android:fc1ce8f0251f1d7e77f259",
      messagingSenderId: "432232439708",
      projectId: "fluttersempfe",
    ),
  );
  final ValueNotifier<ThemeMode> _notifier = ValueNotifier(ThemeMode.light);

  runApp(
      ValueListenableBuilder<ThemeMode>(
      valueListenable: _notifier,
      builder: (_, mode, __) {
        return
        MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: mode,
          initialRoute: 'auth',
          routes: <String, WidgetBuilder>{
            'auth': (context) => authRoute(),
            'login': (context) => Login(),
            'register': (context) => Register(),
            'home': (context) => Home(),
          },
        );
      }
  )
  );
}

