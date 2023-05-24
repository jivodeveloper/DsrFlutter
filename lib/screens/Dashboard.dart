import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slide_drawer/slide_drawer.dart';

class Dashboard extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return Dashboardstate();
  }

}

class Dashboardstate extends State<Dashboard>{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
       appBar: AppBar(
       backgroundColor: Colors.white,
       title: Text("Dashboard", style: TextStyle(color:  Color(0xFF095909),fontFamily: 'OpenSans',fontWeight: FontWeight.w300)),
       leading:GestureDetector(
           onTap: (){
             SlideDrawer.of(context)?.toggle();
           },
           child:Image.asset('assets/Icons/nav_menu.png', width: 104.0,
             height: 104.0,) ,
       )
    ),

   );
  }

}