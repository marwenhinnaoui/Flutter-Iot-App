import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:projet_sem3_flutter/screens/gaz_screen.dart';
import 'package:projet_sem3_flutter/screens/profile_screen.dart';
import 'package:projet_sem3_flutter/screens/temp_screen.dart';


import '../ui/colors.dart';
import '../widgets/snackbar.dart';
import 'auth/auth.dart';


class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {



  final _advancedDrawerController = AdvancedDrawerController();
  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
  @override
  Widget build(BuildContext context) {





    return
      AdvancedDrawer(
      backdrop: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blueGrey, Colors.blueGrey.withOpacity(0.2)],
          ),
        ),
      ),
      controller: _advancedDrawerController,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 300),
      animateChildDecoration: true,
      rtlOpening: false,
      // openScale: 1.0,
      disabledGestures: false,

      childDecoration: const BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Client Dashnoard'),
          leading: IconButton(
            onPressed: _handleMenuButtonPressed,
            icon: ValueListenableBuilder<AdvancedDrawerValue>(
              valueListenable: _advancedDrawerController,
              builder: (_, value, __) {
                return AnimatedSwitcher(
                  duration: Duration(milliseconds: 250),
                  child: Icon(
                    value.visible ? Icons.clear : Icons.menu,
                    key: ValueKey<bool>(value.visible),
                  ),
                );
              },
            ),
          ),
        ),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Container(

              width: double.infinity,
              padding:  EdgeInsets.all(5),
              child: Card(
                surfaceTintColor:Color(0xFFFFFFFF),
                color: Colors.white,
                child: InkWell(

                  borderRadius: BorderRadius.circular(10),
                  onTap: () {},
                  child: Padding(
                    padding:  EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Center(
                          child: Text(
                              'Slide'
                          ),
                        ),

                      ],
                    ),
                  ),
                ),
              ),
            ),











          ],
        ),
      ),
      drawer: SafeArea(
        child: Container(
          child: ListTileTheme(
            textColor: Colors.white,
            iconColor: Colors.white,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  width: 128.0,
                  height: 128.0,
                  margin: const EdgeInsets.only(
                    top: 24.0,
                    bottom: 64.0,
                  ),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.black26,
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/img/dribbble-icon_4x.png',

                      fit: BoxFit.cover
                  ),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeScreen()));

                  },
                  leading: Icon(Icons.home),
                  title: Text('Home'),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TempScreen()));

                  },
                  leading: Icon(Icons.navigate_next_sharp),
                  title: Text('Temperature'),
                ),
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.navigate_next_sharp),
                  title: Text('Humidity'),
                ),
                ListTile(
                  onTap: () {

                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => GazScreen()));

                  },
                  leading: Icon(Icons.navigate_next_sharp),
                  title: Text('Gaz'),
                ),
                ListTile(
                  onTap: () {

                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen()));

                  },
                  leading: Icon(Icons.account_circle_rounded),
                  title: Text('Profile'),
                ),

                ListTile(
                  onTap: ()async {

                    String? signoutStatus = '';
                    String? color = 'success';
                    try {
                      await Auth().fireAuth.signOut();
                      print('Signout pressed');
                      signoutStatus = 'Signout Success';
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('login', (Route<dynamic> route) => false);
                    } on FirebaseAuthException catch (e) {
                      signoutStatus = e.code;
                      color = 'danger';
                    }
                    final snackBar = CustomSnackBar.showErrorSnackBar(signoutStatus, color);
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);




                  },
                  leading: Icon(Icons.exit_to_app),
                  title: Text('Sign Out'),
                ),
                Spacer(),
                DefaultTextStyle(
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.white54,
                  ),
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 16.0,
                    ),
                    child: Text('Terms of Service | Privacy Policy Sem3 7050'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

  }
}