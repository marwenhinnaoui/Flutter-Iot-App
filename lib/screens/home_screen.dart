

import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_neon/flutter_neon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:iconify_flutter/icons/wi.dart';
import 'package:projet_sem3_flutter/api.dart';
import 'package:projet_sem3_flutter/screens/gaz_screen.dart';
import 'package:projet_sem3_flutter/screens/profile_screen.dart';
import 'package:projet_sem3_flutter/screens/temp_screen.dart';
import 'package:iconify_flutter/iconify_flutter.dart';
import 'package:colorful_iconify_flutter/icons/emojione.dart';
import 'package:projet_sem3_flutter/ui/colors.dart';
import 'package:web_socket_channel/io.dart';
import '../widgets/snackbar.dart';
import 'auth/auth.dart';
import 'package:neon_widgets/neon_widgets.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

import 'humidity_screen.dart';
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  double valueGaz=0.0;
  String valueDoor='ouverte';
  double valueTmp=0.0;
  double valueHumdity=0.0;
  num sliderValue=0;
  double sliderValueGaz=0;
  double sliderValueHumidity=0;
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.ref();
  final _advancedDrawerController = AdvancedDrawerController();
  void _handleMenuButtonPressed() {
    // NOTICE: Manage Advanced Drawer state through the Controller.
    // _advancedDrawerController.value = AdvancedDrawerValue.visible();
    _advancedDrawerController.showDrawer();
  }
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    final channel = IOWebSocketChannel.connect('ws://192.168.43.3:8080');


    channel.stream.listen((data) {
      if (data != null && valueGaz > sliderValueGaz && data =='Gaz') {

        print('----------------------------------------------- ---------------${data}');
setState(() {
  Api.showNotification(
      title: 'Gaz WARNING ⚠️',
      body: 'Gaz reached limit, You must turn on fan ⚠',
      payload: 'test'
  );
});


      }else if(data != null && valueTmp > sliderValue && data =='Tmp'){
        setState(() {
          Api.showNotification(
              title: 'Temperature WARNING ⚠️',
              body: 'Temperature reached limit, You must turn on fan ⚠',
              payload: 'test'
          );
        });
      }else if(data != null && valueTmp > sliderValue && data =='Hum'){
        setState(() {
          Api.showNotification(
              title: 'Humidity WARNING ⚠️',
              body: 'Humidity reached limit, You must turn on fan ⚠',
              payload: 'test'
          );
        });
      }
    });
    // Api.showNotification(
    //   title: 'test',
    //   body: 'test',
    //   payload: 'test'
    // );
    OneSignal.initialize("d9b1207e-a576-4150-bbfe-ba17ac48066d");
    OneSignal.Notifications.requestPermission(true);

    _databaseReference.child('tmp').onValue.listen((event) {
      final data = event.snapshot.value as double;

      setState(() {
        valueTmp = data;
      });

    });
    _databaseReference.child('sliderValue').onValue.listen((event) {
      final data = event.snapshot.value as double;

      setState(() {
         sliderValue= data;
      });

    });  _databaseReference.child('sliderValueHumidity').onValue.listen((event) {
      final data = event.snapshot.value as double;

      setState(() {
        sliderValueHumidity = data;
      });

    });
    _databaseReference.child('sliderValueGaz').onValue.listen((event) {
      final data = event.snapshot.value as double;

      setState(() {
        sliderValueGaz = data;
      });

    });

    _databaseReference.child('gaz').onValue.listen((event) {
      final data = event.snapshot.value as double;

      setState(() {
        valueGaz = data;
      });

    });    _databaseReference.child('hum').onValue.listen((event) {
      final data = event.snapshot.value as double;

      setState(() {
        valueHumdity = data;

      });

    });
    _databaseReference.child('rfid').onValue.listen((event) {
      final data = event.snapshot.value as String;

      setState(() {
        valueDoor = data;
      });

    });




  }


  Widget GetTextWidget(sliderValue, value, who){
    if(sliderValue > value){
      if(who == 'Humidity' && sliderValue > value){

        return Text(
          '${value}%',
          style: TextStyle(
              fontSize: 17
          ),
        );
      }else
      return Text(
        '${value}${who == 'Gas' ? '%' : '°C'}',
        style: TextStyle(
            fontSize: 17
        ),
      );
  }else{
      if(who == 'Humidity'){
        return FlickerNeonText(
          text: '${value}%',
          flickerTimeInMilliSeconds: 700,
          spreadColor: cutomColor().dangerColorText,
          blurRadius: 20,
          textSize: 20,
        );
      }
      return FlickerNeonText(
        text: '${value}${who == 'Gas' ? '%' : '°C'}',
        flickerTimeInMilliSeconds: 700,
        spreadColor: cutomColor().dangerColorText,
        blurRadius: 20,
        textSize: 20,
      );

    }
  }
  Widget GetTextWidgetDoor(value){
    if(value=="fermée"){
      return Text(
        'Door is closed',
        style: TextStyle(
            fontSize: 17
        ),
      );
  }else{
      return FlickerNeonText(
        text: 'Door is open!',
        flickerTimeInMilliSeconds: 700,
        spreadColor: cutomColor().dangerColorText,
        blurRadius: 20,
        textSize: 20,
      );

    }
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
                  leading: Iconify(Wi.day_windy, color: Colors.white,),
                  title: Text('Temperature'),
                ),
                ListTile(
                  onTap: () {                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HumidityScreen()));
                  },
                  leading: Iconify(Wi.humidity, color: Colors.white,),
                  title: Text('Humidity'),
                ),
                ListTile(
                  onTap: () {

                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => GazScreen()));

                  },
                  leading: Iconify(Wi.strong_wind, color: Colors.white,),
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
      child: Scaffold(
        appBar: AppBar(
          backgroundColor:                Color(0xFFFFFFFF),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(

                children: [
                  IconButton(icon:Icon(Icons.account_circle_outlined), onPressed: (){
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen()));

                  },),

                  IconButton(icon: Icon(Icons.exit_to_app),


                    onPressed: ()async {

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
                  ),

                ],
              ),
            )
          ],
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

                surfaceTintColor: sliderValue <= valueTmp ? cutomColor().dangerColorText : Colors.white ,
                color: Colors.white,
                child:
                InkWell(

                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => TempScreen()));

                  },
                  child: Padding(
                    padding:  EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Iconify(Wi.day_windy, size: 30,),
                                Text(
                                    '  Temperature',
                                  style: TextStyle(
                                    fontSize: 17
                                  ),
                                ),
                              ],
                            ),
                            GetTextWidget(sliderValue, valueTmp, 'Temperature')

                          ],
                        ),





                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(

              width: double.infinity,
              padding:  EdgeInsets.all(5),
              child: Card(

                surfaceTintColor: sliderValueHumidity <= valueHumdity ? cutomColor().dangerColorText : Colors.white ,
                color: Colors.white,
                child:
                InkWell(

                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HumidityScreen()));

                  },
                  child: Padding(
                    padding:  EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Iconify(Wi.humidity, size: 30,),
                                Text(
                                    '  Humidity',
                                  style: TextStyle(
                                    fontSize: 17
                                  ),
                                ),
                              ],
                            ),
                            GetTextWidget(sliderValueHumidity, valueHumdity, 'Humidity')

                          ],
                        ),





                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(

              width: double.infinity,
              padding:  EdgeInsets.all(5),
              child: Card(
                surfaceTintColor: sliderValueGaz <= valueGaz ? cutomColor().dangerColorText : Colors.white ,
                color: Colors.white,
                child: InkWell(

                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => GazScreen()));

                  },
                  child: Padding(
                    padding:  EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Iconify(Wi.strong_wind, size: 30,),
                                Text(
                                    '  Gas',
                                  style: TextStyle(
                                    fontSize: 17
                                  ),
                                ),
                              ],
                            ),
                            GetTextWidget(sliderValueGaz, valueGaz, 'Gas')


                          ],
                        ),





                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(

              width: double.infinity,
              padding:  EdgeInsets.all(5),
              child: Card(
                surfaceTintColor: valueDoor =='ouverte' ? cutomColor().dangerColorText : Colors.white ,
                color: Colors.white,
                child: InkWell(

                  borderRadius: BorderRadius.circular(10),
                  onTap: () {

                  },
                  child: Padding(
                    padding:  EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.door_sliding_outlined, size: 30,),
                                Text(
                                    '  Door',
                                  style: TextStyle(
                                    fontSize: 17
                                  ),
                                ),
                              ],
                            ),
                            GetTextWidgetDoor(valueDoor)


                          ],
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
    );

  }
}