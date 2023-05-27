import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promoterapp/screens/AllShops.dart';
import 'package:promoterapp/screens/BeatShops.dart';
import 'package:promoterapp/screens/Distributor.dart';
import 'LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../config/Common.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ShopsDist extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return ShopsDistState();
  }

}

class ShopsDistState extends State<ShopsDist> with TickerProviderStateMixin {

  late TabController _controller;
  int beatId =0;
  String beatname="";

  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 5, vsync: this);
    getbeatname();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            iconTheme: const IconThemeData(color:Color(0xFF063A06)),
            bottom: TabBar(
              unselectedLabelColor:Color(0xFF063A06) ,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [ Color(0xFF063A06),Color(0xFF032603), Color(
                          0xFF001800)]),
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0xFF063A06)),
              // indicatorColor: Color(0xFF095909),
              labelColor: Colors.white,
              tabs: [

                Tab(text:"Beat"),
                Tab(text:"All Shops"),
                Tab(text:"Distributors"),

              ],
            ),
            title: Text('${beatname} BEAT', style: TextStyle(color:  Color(0xFF095909),fontFamily: 'OpenSans',fontWeight: FontWeight.w300)),
          ),
          body: TabBarView(
            children: [
              BeatShops(),
              AllShops(),
              Distributor(),
            ],
          ),
        ),
      ),
    );
  }

  void getbeatname() async {

    SharedPreferences prefs= await SharedPreferences.getInstance();
    int bid = prefs.getInt(Common.BEAT_ID)!;
    String baname = prefs.getString(Common.BEAT_NAME)!;

    setState((){
      beatId = bid;
      beatname = baname.toUpperCase();
    });

  }

}