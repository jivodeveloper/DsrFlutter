import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promoterapp/models/Shops.dart';
import 'package:slide_drawer/slide_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config/Common.dart';
import 'dart:convert';

class Dashboard extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return Dashboardstate();
  }

}

class Dashboardstate extends State<Dashboard>{
  late Future<List> furturedist;

  @override
  void initState() {

    super.initState();

  }

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

// Future<List<Shops>> syncall() async {
//
//   List<Shops> statelist = [];
//   int userid=0;
//
//   SharedPreferences prefs= await SharedPreferences.getInstance();
//   userid = prefs.getInt(Common.USER_ID)!;
//
//   Map<String,String> headers={
//     'Content-Type': 'application/json',
//   };
//
//   var response = await http.get(Uri.parse(Common.IP_URL+'syncAllData?id=$userid'), headers: headers);
//
//   List<Shops> statedata = [];
//   final list = jsonDecode(response.body);
//
//   try{
//
//     statedata = list.map<Shops>((m) => Shops.fromJson(Map<String, dynamic>.from(m))).toList();
//
//     for(int i=0 ;i<statedata.length;i++){
//       statelist.add(statedata[i]);
//     }
//
//   }catch(e){
//     Fluttertoast.showToast(msg: "$e",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.black,
//         textColor: Colors.white,
//         fontSize: 16.0);
//   }
//
//   return statelist;
// }