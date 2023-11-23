import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';


import '../../screens/auth/auth.dart';
import '../../send_mail.dart';
import '../../ui/colors.dart';
import '../../widgets/snackbar.dart';


class HomeAdminScreen extends StatefulWidget{

  @override
  State<HomeAdminScreen> createState() => _HomeAdminScreenState();

}

class _HomeAdminScreenState extends State<HomeAdminScreen> {
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
  final GlobalKey<FormState> _formKey = GlobalKey();

  List<Map<String, dynamic>>? usersList = [];


  Widget _buildPopupDialogDelete(BuildContext context, String? userId) {
    return  AlertDialog(

      title:  Text('Delete client'),
      content:  SizedBox(
        width: MediaQuery.of(context).size.width,

        child: Text('Are you sure to delete this client!!'),
      ),
      actions: <Widget>[
        TextButton(onPressed: ()=> Navigator.pop(context, 'Cancel') , child: Text('Cancel')),
        TextButton(
            onPressed: () async{
              CollectionReference users = FirebaseFirestore.instance.collection('users');

              String? color = 'success';
              String? DeleteStatus = 'Deleted successfully';
              try{
                Navigator.pop(context, 'Cancel');
                await users.doc(userId).delete();
                print('User with ID $userId deleted successfully');


              }on FirebaseAuthException catch(e){
                DeleteStatus = e.code;
                color = 'danger';
              }
              final snackBar = CustomSnackBar.showErrorSnackBar(DeleteStatus, color);
              ScaffoldMessenger.of(context).showSnackBar(snackBar);

            },
            child: Text('Delete')

        ),


      ],
    );
  }



  Future addUserData(
      String email,
      String full_name,
      bool isValid,
      String phone,
      String createDate,

      ) async{
    try{


      await FirebaseFirestore.instance.collection('users').doc(Auth().currentUser?.uid).set({
        'email':email,
        'fullname':full_name,
        'admin':isValid,
        'phone':phone,
        'createDate':createDate,
      });
    }on FirebaseException catch(e){
      print('Store --------------- ${e.message}');
    }
  }

  Widget _buildPopupDialog(BuildContext context) {
    return  AlertDialog(

      title:  Text('Add client'),
      content:  SizedBox(
        width: MediaQuery.of(context).size.width,

        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [


              const SizedBox(height: 20),
              Text(
                "Fields can't be empty",
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

            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
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
                    RegisterStatus = 'Register success';
                  }
                }on FirebaseAuthException catch(e){
                  RegisterStatus = e.code;
                  color = 'danger';
                }

                final snackBar = CustomSnackBar.showErrorSnackBar(RegisterStatus, color);
                final date =new DateTime.now();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);


                if(RegisterStatus =='Register success'){
                  print('${ _controllerName.text.toString().trim()} ++++++++++++++++++ ${_controllerEmail.text.toString().trim()}');
                  await addUserData(_controllerEmail.text.toString().trim(), _controllerName.text.toString().trim(), false, _phoneController.text.toString().trim(), date.toString());
                  Navigator.pop(context, 'Add');
                  Mailer().sendMail(to: _controllerEmail.text.toString().trim(), fullName: _controllerName.text.toString().trim(), password: _controllerPassword.text);

                  _formKey.currentState?.reset();






                }

              }
            },
            child: Text('Add'))

      ],
    );
  }

  Widget _buildPopupDialogUpdate(BuildContext context, [DocumentSnapshot? documentSnapshot]) {
    _controllerName.text = documentSnapshot?['fullname'];
    _phoneController.text = documentSnapshot?['phone'];
    _controllerEmail.text = documentSnapshot?['email'];

    return  AlertDialog(

      title:  Text('Update client'),
      content:  SizedBox(
        width: MediaQuery.of(context).size.width,

        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [


              const SizedBox(height: 20),
              Text(
                "Fields can't be empty",
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



            ],
          ),
        ),
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () async{

              String? color = 'success';
              String? UpdateStatus = 'Update successfully';


                try{
                  if (_formKey.currentState?.validate() ?? false) {
                  _items.doc(documentSnapshot!.id)
                  .update({"email":_controllerEmail.text , "fullname": _controllerName.text, "phone": _phoneController.text});
                  }

                }on FirebaseAuthException catch(e){
                  UpdateStatus = e.code;
                  color = 'danger';
                }

                final snackBar = CustomSnackBar.showErrorSnackBar(UpdateStatus, color);
                final date =new DateTime.now();
                ScaffoldMessenger.of(context).showSnackBar(snackBar);


              Navigator.of(context).pop();
              _controllerName.text = '';
              _phoneController.text = '';
              _controllerEmail.text = '';
            },
            child: Text('Update'))

      ],
    );
  }


  final CollectionReference _items =
  FirebaseFirestore.instance.collection('users');

  @override
  Widget build(BuildContext context) {


    return(

        Scaffold(
          floatingActionButton: IconButton(
            style: IconButton.styleFrom(backgroundColor: cutomColor().dangerColorBg),
            padding:EdgeInsets.symmetric(horizontal: 13, vertical: 13),
            icon: Icon(
                Icons.add_rounded,
                color: cutomColor().dangerColorText,
                size:30.0
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) => _buildPopupDialog(context),
              );
            },
          ),
          appBar:AppBar(
            elevation:100,
            bottomOpacity:20,
            leadingWidth: double.infinity,
            leading: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                  style: TextStyle(
                    fontSize: 16,
                  ),
                  "Admin Dhashboard"
              ),
            ),
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
          body: StreamBuilder(
            stream: _items.snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot)  {
                    if (streamSnapshot.hasData) {
                      final List<DocumentSnapshot> items = streamSnapshot.data!.docs.where((doc)=>doc['admin'] == false).toList();
                      print('----------------------- ${items}');
                      return ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final DocumentSnapshot documentSnapshot = items[index];
                          print('------------------sssss----- ${documentSnapshot.data()}');

                          return Card(

                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            margin: const EdgeInsets.all(10),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 17,
                                backgroundColor: cutomColor().dangerColorBg,
                                child: Text(
                                  documentSnapshot['fullname'][0].toString(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold, color: Color(0xff8C1D18)),
                                ),
                              ),
                              title: Text(
                                documentSnapshot['fullname'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, color: Colors.black),
                              ),
                              subtitle: Text(documentSnapshot['email'].toString()),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [

                                    IconButton(
                                        color: Colors.blue,
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) => _buildPopupDialogUpdate(context, documentSnapshot),
                                          );
                                        },
                                        icon: const Icon(Icons.edit)),
                                    IconButton(
                                        color: cutomColor().dangerColorText,
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) => _buildPopupDialogDelete(context, documentSnapshot.id),
                                          );
                                        },
                                        icon: const Icon(Icons.delete)),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }

                      );
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
            }
            
          )
        )
    );
  }

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
