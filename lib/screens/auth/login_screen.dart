import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projet_sem3_flutter/screens/auth/auth.dart';
import 'package:projet_sem3_flutter/screens/auth/register_screen.dart';




class Login extends StatefulWidget {
  const Login({
    Key? key,
  }) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FocusNode _focusNodePassword = FocusNode();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  var Firebase_errors =  "";
  bool _obscurePassword = true;



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white70,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            children: [
              const SizedBox(height: 100),
              Image.asset('assets/img/iot_image.jpg'),
              const SizedBox(height: 30),
              Text(
                "Login to your account",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 60),
              TextFormField(
                controller: _controllerEmail,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
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
              const SizedBox(height: 60),
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
                      String? LoginStatus = '';
                      if (_formKey.currentState?.validate() ?? false) {

                        print('Login Screen');
                        print('Email: ${_controllerEmail.text.toString().trim()}');
                        print(_controllerPassword.text.toString());


                        //Firebase Validation
                        try{
                          var userData = await Auth().fireAuth.signInWithEmailAndPassword(
                              email: _controllerEmail.text,
                              password: _controllerPassword.text
                          );
                          if(userData.user != null ){
                            print('Login Success');
                            LoginStatus= 'Login Success';
                            Navigator.of(context).pushNamedAndRemoveUntil('home' , (Route <dynamic> route ) => false);

                          }
                        }on FirebaseAuthException catch(e){
                          LoginStatus = e.code;




                        }
                        final snackBar = SnackBar(
                          content: Text(LoginStatus!),
                          action: SnackBarAction(
                            label: 'Hide',
                            onPressed: () {
                              // Some code to undo the change.
                            },
                          ),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);


                      }
                    },
                    child: const Text("Login"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {

                          _formKey.currentState?.reset();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return Register();
                              },
                            ),
                          );
                        },
                        child: const Text("Signup"),
                      ),
                    ],
                  ),
                ],
              ),
            ],
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