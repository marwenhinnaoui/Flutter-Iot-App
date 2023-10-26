import 'package:flutter/material.dart';
import 'package:projet_sem3_flutter/screens/auth/auth.dart';
import 'package:projet_sem3_flutter/screens/auth/login_screen.dart';


import '../home_screen.dart';


class authRoute extends StatefulWidget{
  @override
  State<authRoute> createState() => _authRouteState();


}
class _authRouteState extends State<authRoute>{
  @override
  Widget build(BuildContext context) {
      return StreamBuilder(stream: Auth().authStateHandle, builder: (context, snpashot){
        if(snpashot.hasData){
          print('Has data');
          return Home();
        }else
          print('No data found');
          return Login();
      });
  }

}