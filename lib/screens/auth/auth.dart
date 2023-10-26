import 'dart:html';
import 'dart:js';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:projet_sem3_flutter/screens/auth/register_screen.dart';


class Auth  {
  final FirebaseAuth fireAuth = FirebaseAuth.instance;
  User? get currentUser => fireAuth.currentUser;
  Stream<User?> get authStateHandle => fireAuth.authStateChanges();




}