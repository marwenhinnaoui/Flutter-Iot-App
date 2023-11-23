import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:projet_sem3_flutter/screens/auth/auth.dart';
import 'package:projet_sem3_flutter/screens/auth/register_screen.dart';

import '../../ui/colors.dart';

import '../../widgets/snackbar.dart';




class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
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

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  var Firebase_errors =  "";
  bool _obscurePassword = true;
  Map<String, dynamic> userData ={};



  @override
  Widget build(BuildContext context) {


    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
            child: Container(
              // height: MediaQuery.of(context).size.height ,
              child: Column(

                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [

                  Image.asset('assets/img/918c27_5cb54df7343246c3898d3a49712ce58c~mv2.gif', width: 315,),
                  const SizedBox(height: 40),
                  Text(
                    "Login to your account",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 40),
                  TextFormField(

                    controller: _controllerEmail,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      labelText: "Email",
                      prefixIcon: const Icon(Icons.person_outline),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onEditingComplete: () => _focusNodePassword.requestFocus(),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter Email.";
                      } else if (!(value.contains('@') && value.contains('.'))) {
                        return "Invalid email";
                      }

                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _controllerPassword,
                    focusNode: _focusNodePassword,
                    obscureText: _obscurePassword,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                      labelText: "Password",
                      prefixIcon: const Icon(Icons.password_outlined),
                      suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          icon: _obscurePassword
                              ? const Icon(Icons.visibility_outlined)
                              : const Icon(Icons.visibility_off_outlined)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter password.";
                      }
                      // else if (value !=
                      //     _boxAccounts.get(_controllerEmail.text)) {
                      //   return "Wrong password.";
                      // }

                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  Column(
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () async{

                          String? color = 'success';
                          String? LoginStatus = 'Sign in success';
                          if (_formKey.currentState?.validate() ?? false) {

                            print('Login Screen');
                            print('Email: ${_controllerEmail.text.toString().trim()}');
                            print(_controllerPassword.text.toString());


                            //Firebase Validation
                            try{
                              var userDataAuth = await Auth().fireAuth.signInWithEmailAndPassword(
                                  email: _controllerEmail.text,
                                  password: _controllerPassword.text
                              );
                              final user = userDataAuth.user;
                              // while (user == null){
                              // }
                              // CustomLoading().LoadingProgress();

                              if(user != null ){
                                await getUserData(userData);

                                if(userData['admin']== false){
                                  Navigator.of(context).pushNamedAndRemoveUntil('home' , (Route <dynamic> route ) => false);

                                }else if(userData['admin']== true){
                                  Navigator.of(context).pushNamedAndRemoveUntil('home_admin' , (Route <dynamic> route ) => false);

                                }

                              }
                            }on FirebaseAuthException catch(e){
                              LoginStatus = e.code;
                              color = 'danger';

                            }

                            final snackBar = CustomSnackBar.showErrorSnackBar(LoginStatus, color);
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);


                          }
                        },
                        child: const Text("Login"),
                      ),

                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNodePassword.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}