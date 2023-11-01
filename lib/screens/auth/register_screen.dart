import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../send_mail.dart';
import '../../widgets/snackbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'auth.dart';



class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _SignupState();
}

class _SignupState extends State<Register> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FocusNode _focusNodeName = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodePhone = FocusNode();
  final FocusNode _focusNodeConfirmPassword = FocusNode();
  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConFirmPassword = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();


  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    Future addUserData(
        String email,
        String full_name,
        bool isValid,
        String phone,

    ) async{
      try{


        await FirebaseFirestore.instance.collection('users').doc(Auth().currentUser?.uid).set({
          'email':email,
          'full name':full_name,
          'isAdmin  ':isValid,
          'phone  ':phone,
        });
      }on FirebaseException catch(e){
        print('Store --------------- ${e.message}');
      }
    }
    return Scaffold(

      backgroundColor: Colors.white,

      body: Form(
        key: _formKey,
        child: SingleChildScrollView(

          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 20),



            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [


                Image.asset('assets/img/Smart-home-GIF.gif', width: 310),
                const SizedBox(height: 20),
                Text(
                  "Create your account",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),

                const SizedBox(height: 10),
                TextFormField(
                  controller: _controllerName,
                  focusNode: _focusNodeName,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                    labelText: "Full Name",
                    prefixIcon: const Icon(Icons.person_outline),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter email.";
                    }
                    return null;
                  },
                  onEditingComplete: () => _focusNodePassword.requestFocus(),
                ),
                const SizedBox(height: 10),

                TextFormField(
                  controller: _phoneController,
                  focusNode: _focusNodePhone,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                    labelText: "Phone",
                    prefixIcon: const Icon(Icons.phone),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your phone number.";
                    }
                    return null;
                  },
                  onEditingComplete: () => _focusNodePassword.requestFocus(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _controllerEmail,
                  focusNode: _focusNodeEmail,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                    labelText: "Email",
                    prefixIcon: const Icon(Icons.email_outlined),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter email.";
                    } else if (!(value.contains('@') && value.contains('.'))) {
                      return "Invalid email";
                    }
                    return null;
                  },
                  onEditingComplete: () => _focusNodePassword.requestFocus(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _controllerPassword,
                  obscureText: _obscurePassword,
                  focusNode: _focusNodePassword,
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
                    } else if (value.length < 8) {
                      return "Password must be at least 8 character.";
                    }
                    return null;
                  },
                  onEditingComplete: () =>
                      _focusNodeConfirmPassword.requestFocus(),
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _controllerConFirmPassword,
                  obscureText: _obscurePassword,
                  focusNode: _focusNodeConfirmPassword,
                  keyboardType: TextInputType.visiblePassword,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10, 15, 10, 15),
                    labelText: "Confirm Password",
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
                    } else if (value != _controllerPassword.text) {
                      return "Password doesn't match.";
                    }
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
                        String? RegisterStatus = '';
                        if (_formKey.currentState?.validate() ?? false) {

                          try{
                            var userData = await Auth().fireAuth.createUserWithEmailAndPassword(
                                email: _controllerEmail.text.toString().trim(),
                                password: _controllerPassword.text
                            );
                            if(userData.user != null ){
                              RegisterStatus = 'Sign up success';
                            }
                          }on FirebaseAuthException catch(e){
                            RegisterStatus = e.code;
                            color = 'danger';
                          }

                          final snackBar = CustomSnackBar.showErrorSnackBar(RegisterStatus, color);
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);


                          if(RegisterStatus =='Sign up success'){
                            print('${ _controllerName.text.toString().trim()} ++++++++++++++++++ ${_controllerEmail.text.toString().trim()}');
                            await addUserData(_controllerEmail.text.toString().trim(), _controllerName.text.toString().trim(), false, _phoneController.text.toString().trim());

                            Navigator.of(context).pushNamedAndRemoveUntil('login' , (Route <dynamic> route ) => false);
                            Mailer().sendMail(_controllerEmail.text.toString().trim(), _controllerName.text.toString().trim(), _controllerPassword.text);
                            _formKey.currentState?.reset();
                          }

                        }
                      },
                      child: const Text("Register"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Already have an account?"),
                        TextButton(
                          onPressed: () =>
                          {
                            Navigator.pop(context),

                          },
                          child: const Text("Login"),
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
    _focusNodeName.dispose();
    _focusNodePhone.dispose();
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    _focusNodeConfirmPassword.dispose();

    _controllerName.dispose();
    _phoneController.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllerConFirmPassword.dispose();
    super.dispose();
  }
}