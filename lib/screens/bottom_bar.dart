
import 'package:flashy_tab_bar2/flashy_tab_bar2.dart';
import 'package:flutter/material.dart';
import 'package:projet_sem3_flutter/screens/home_screen.dart';
import 'package:projet_sem3_flutter/screens/profile_screen.dart';





class BottomBar extends StatefulWidget {
  BottomBar({super.key});

  @override
  State<BottomBar> createState() => _HomeState();
}




class _HomeState extends State<BottomBar> {

  late List userDataList;
  List<Widget> tabItems = [
    HomeScreen(),
    ProfileScreen(),
  ];
  int _selectedIndex = 0;






  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {




    return(
       Scaffold(

         bottomNavigationBar:
         FlashyTabBar(

           animationCurve: Curves.linear,
           selectedIndex: _selectedIndex,
           iconSize: 30,
           showElevation: false, // use this to remove appBar's elevation
           onItemSelected: (index) => setState(() {
             _selectedIndex = index;
           }),
           items: [
             FlashyTabBarItem(

               icon: Icon(Icons.home),
               title: Text('Home'),
             ),


             FlashyTabBarItem(
               icon: Icon(Icons.account_circle_rounded),
               title: Text('Profile'),
             ),

           ],
         ),


         body: Center(
           child: tabItems[_selectedIndex],
         ),

          )
          );
  }
}