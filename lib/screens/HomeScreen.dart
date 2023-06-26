import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promoterapp/screens/Dashboard.dart';
import 'package:promoterapp/screens/ReportsScreen.dart';
import 'package:slide_drawer/slide_drawer.dart';
import 'package:promoterapp/screens/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:promoterapp/screens/Attendance.dart';
import 'package:promoterapp/screens/DistributorStock.dart';
import '../models/TodayBeat.dart';
import 'ShopsDist.dart';
import '../config/Common.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget{
  String personName="";
  HomeScreen({required this.personName});

  @override
  State<StatefulWidget> createState() {
    return HomeScreenState();
  }

}

class HomeScreenState extends State<HomeScreen>{

  static const appTitle = 'Drawer Demo';
  int _selectedIndex = 0;
  final ScrollController _homeController = ScrollController();
  int userid=0,beatId=0;

  @override
  void initState() {
    super.initState();
    gettodaybeat();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      home:SlideDrawer (
        drawer: Container(
          color:Color(0xFF063A06),
          padding: EdgeInsets.only(left: 0,top: 100,right: 10),
          child:  Column(
            children: [

              Row(
                children: [

                  Expanded(
                      flex: 1,
                      child: Image.asset(
                          'assets/Images/logo.png', height: 40)),

                  Expanded(
                    flex: 3,
                    child: Text("Welcome ${widget.personName}",style: TextStyle(fontSize: 20,color: Colors.white,fontFamily: 'OpenSans',fontWeight: FontWeight.w900)),)

                ],

              ),

              Padding(
                  padding: EdgeInsets.only(top:60),
                  child:ListTile(
                    onTap: (){

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (contextt) =>
                                  HomeScreen(personName: widget.personName)

                          ));
                    },
                    leading: Image.asset(
                        'assets/Images/home.png', height: 25),
                    title: Text(
                      'Home',
                      style: TextStyle(color: Colors.white, fontSize: 14,fontFamily: 'OpenSans',fontWeight: FontWeight.w300),
                    ),
                  )
              ),

              ListTile(
                leading: Image.asset(
                    'assets/Images/attendance.png', height: 25),
                onTap: (){

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (contextt) =>
                              Attendance()));
                },
                title: Text(
                  'Attendance',
                  style: TextStyle(color: Colors.white, fontSize: 14,fontFamily: 'OpenSans',fontWeight: FontWeight.w600),
                ),
              ),

              ListTile(
                leading:  Image.asset(
                    'assets/Images/shop.png', height: 25),
                onTap: (){

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (contextt) =>
                              ShopsDist()));

                },
                title: Text(
                  'Shops & Distributor',
                  style: TextStyle(color: Colors.white, fontSize: 14,fontFamily: 'OpenSans',fontWeight: FontWeight.w600),
                ),
              ),

              ListTile(
                leading: Image.asset(
                    'assets/Images/report.png', height: 25),
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (contextt) =>
                              ReportsScreen()));
                },
                title: Text(
                  'Reports',
                  style: TextStyle(color: Colors.white, fontSize: 14,fontFamily: 'OpenSans',fontWeight: FontWeight.w600),
                ),
              ),

              ListTile(
                leading: Image.asset(
                    'assets/Images/stock.png', height: 25),
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              DistributorStock()));

                },
                title: Text(
                  'Distributor Stock',
                  style: TextStyle(color: Colors.white, fontSize: 14,fontFamily: 'OpenSans',fontWeight: FontWeight.w600),
                ),
              ),

              ListTile(
                leading: Image.asset(
                    'assets/Images/target.png', height: 25),
                onTap: (){

                },
                title: Text(
                  'Target',
                  style: TextStyle(color: Colors.white, fontSize: 14,fontFamily: 'OpenSans',fontWeight: FontWeight.w600),
                ),
              ),

              ListTile(
                leading: Image.asset(
                    'assets/Images/shutdown.png', height: 25),
                onTap: (){
                  logout(context);
                },
                title: Text(
                  'Logout',
                  style: TextStyle(color:Colors.white, fontSize: 14,fontFamily: 'OpenSans',fontWeight: FontWeight.w600),
                ),
              ),

              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: MaterialButton(
                    onPressed: () => {},
                    child: Text('V1.807 - Terms & Conditions',style: TextStyle(color: Colors.white),),
                  ),
                ),
              ),

            ],
          ),
        ),
        child: Dashboard(),
      ),
    );
  }

  void showModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) =>

          AlertDialog(
            content: const Text('Example Dialog'),
            actions: <TextButton>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Close'),
              )
            ],
          ),

    );
  }

  void logout(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (BuildContext context) =>
          AlertDialog(
            content: const Text('Logout'),
            actions: <TextButton>[
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () async {
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  await preferences.clear();

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (contextt) =>
                              LoginScreen()));
                },
                child: const Text('Yes'),
              )
            ],
          ),
    );
  }

  Future<void> gettodaybeat() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;

    TodayBeat details;
    int beatid =0;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.post(Uri.parse('${Common.IP_URL}checkTodayBeat?personId=$userid'), headers: headers);

    if(response.body.isNotEmpty){

      try{

        details = TodayBeat.fromJson(json.decode(response.body));
        beatid =  details.beatId == 0 ?-1:details.beatId;
        prefs.setInt(Common.BEAT_ID,beatid);
        prefs.setString(Common.BEAT_NAME,details.beatName);

      }catch(e){

      }

    }

  }

}
