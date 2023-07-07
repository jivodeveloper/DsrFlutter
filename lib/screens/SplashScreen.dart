import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promoterapp/screens/HomeScreen.dart';
import 'package:promoterapp/screens/LoginScreen.dart';
import 'package:swipeable_page_route/swipeable_page_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/Common.dart';

class SplashScreen extends StatefulWidget{

  @override
  SplashScreenState createState() => new SplashScreenState();

}

class SplashScreenState extends State<SplashScreen>{

  @override
  void initState() {
    super.initState();

    checkisalreadyloggedin();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
            children: [
              Expanded(
                  flex: 2,
                  child: Container(
                    child:Image.asset('assets/Images/jivo_logo.png'),
                  )),
              CircularProgressIndicator()
            ],
          )
      ),
    );
  }

  void checkisalreadyloggedin() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_id = prefs.getInt(Common.USER_ID);
    String personName= prefs.getString(Common.PERSON_NAME).toString();
    if(prefs.getInt(Common.USER_ID)!=0 && prefs.getInt(Common.USER_ID)!=null){

      Timer(Duration(seconds: 3), () =>Navigator.of(context).push(SwipeablePageRoute(
        builder: (BuildContext context) => HomeScreen(personName:personName),
      )));

    }else{

      Timer(Duration(seconds: 3), () =>Navigator.of(context).push(SwipeablePageRoute(
        builder: (BuildContext context) => LoginScreen(),)));

    }

  }


}