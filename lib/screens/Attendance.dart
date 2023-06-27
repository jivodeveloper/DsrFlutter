import 'dart:collection';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../config/Common.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:geolocator/geolocator.dart';
import '../models/Shops.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

import 'HomeScreen.dart';

class Attendance extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return AttendanceState();
  }

}

class AttendanceState extends State<Attendance>{

  double lat =0.0 ,lng=0.0;
  List beatnamelist = [];
  List<int> beatIdlist = [];
  int userid=0,beatId=0;
  String attStatus="";
  bool present = false, hd = false, wo=false,eod =false;

  @override
  void initState() {
    super.initState();
    _handleLocationPermission();
    getAttendanceStatus();
    getallshops();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            leading: GestureDetector(
            onTap: (){

            Navigator.push(
            context,
              MaterialPageRoute(
              builder: (context) =>
                  HomeScreen(personName: "")));

              },

              child: Icon(Icons.arrow_back,color:Color(0xFF063A06)),
            ),

            title: const Text("Attendance",
                style: TextStyle(color:Color(0xFF063A06),fontFamily: 'OpenSans',fontWeight: FontWeight.w300)
           )
        ),
        body:ProgressHUD(
            child:Builder(
            builder: (context) => Scaffold(
             body: SizedBox(
        width: double.infinity,
         height: double.infinity,
        child:  Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[

                GestureDetector(

                  onTap: (){
                    showdilaog("P");
                  },

                  child:Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:  present ? Colors.grey : const Color(0xff0e0e0e),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                        child:Text(
                          "PRESENT",
                          style: TextStyle(color:Colors.white
                          ),
                        )
                    ),
                  ),

                ),

                GestureDetector(
                  onTap: (){
                    showdilaog("EOD");
                  },
                  child:  Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: eod ? Colors.grey : const Color(0xff0e0e0e),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                        child:Text("END OF DAY",style: TextStyle(
                            color: Colors.white
                        ),
                        )
                    ),
                  ),
                ),

              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children:[

                GestureDetector(
                  onTap: (){
                    showdilaog("HD");
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: hd ? Colors.grey : const Color(0xff0e0e0e),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                        child: Text("HALF DAY",style: TextStyle(
                            color: Colors.white
                        ),
                        )
                    ),
                  ),
                ),

                GestureDetector(

                  onTap: (){
                    showdilaog("WO");
                  },

                  child:Container(
                    height: 100,
                    width: 100,
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: wo ? Colors.grey : const Color(0xff0e0e0e),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(
                        child: Text("WEEK OFF",style: TextStyle(
                            color: Colors.white
                        ),
                        )
                    ),
                  ),
                )

                ],
              ),
             ]
            ),
            )
           )
          )
        )
    );

  }

  void getAttendanceStatus() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    attStatus = prefs.getString(Common.ATT_STATUS).toString();

    if(attStatus=="P"){
        present = true;
        wo = true;

    }else if(attStatus=="EOD"){
      present = true;
      eod = true;
      wo = true;
      hd = true;
    }else if(attStatus=="HD"){
      present = true;
      eod = true;
      wo = true;
      hd = true;
    }else if(attStatus=="EOD"){

      present = true;
      eod = true;
      wo = true;
      hd = true;

    }

  }

  Future<bool> _handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {

      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {

      return false;
    }

    return true;

  }

  Future<void> showdilaog(String status) async {

    return showDialog(
        context: context,
        builder:(BuildContext context) {
      return AlertDialog(
        title: const Text('Attendance'),
        content: const Text('Are you really present?'),
        actions: <Widget>[

          TextButton(
            onPressed: () => Navigator.pop(context, 'Cancel'),
            child: const Text('No'),
          ),

          TextButton(
            onPressed: () =>
             showbeat(status,context),
            child: const Text('Yes'),
          ),

         ],
       );
      }
    );
  }

  Future<void> showbeat(String status,BuildContext contextt) async {

    if(beatnamelist.length == 0){

      Navigator.pop(contextt);
      Fluttertoast.showToast(msg: "You don't have any beat! \n Please contact admin",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }else{

      Navigator.pop(contextt);

      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          contextt = context;
          return AlertDialog(
            title: const Text('Select Beat'),
            content:ListView.builder(
                shrinkWrap: true,
                itemCount: beatnamelist.length,
                itemBuilder: (context,i){
                  return GestureDetector(
                      onTap: (){
                        markattendance(status,beatnamelist[i].toString(),contextt);
                      },

                      child: Container(
                        height: 30,
                        child: Text("${beatnamelist[i]}"),
                      )
                  );
                }
            ),
          );
        },
      );

    }
  }

  void getallshops() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.post(Uri.parse(Common.IP_URL+'syncAllData?id=$userid'), headers: headers);

    if(response.statusCode == 200){

      try{

        final list = jsonDecode(response.body)[0];

        //  debugPrint("Successfully login ${jsonDecode(response.body)[0]}");

        // Shops shops= Shops.fromJson(list);
        // beatlist.add(shops);
        // final jsonLanguages = jsonDecode(response.body.toString());

        List<Shops> retailerdata = [];
        retailerdata = list.map<Shops>((m) => Shops.fromJson(Map<String, dynamic>.from(m))).toList();

        for(int i=0 ;i<retailerdata.length;i++){
           if(retailerdata[i].beatName != ""){

               setState(() {
                 beatnamelist.add(retailerdata[i].beatName.toString());
                 beatIdlist.add(retailerdata[i].beatId!.toInt());
               });

           }
        }

        beatnamelist = LinkedHashSet<String>.from(beatnamelist).toList();
        beatIdlist = LinkedHashSet<int>.from(beatIdlist).toList();


    Fluttertoast.showToast(msg: "Successfully login ${beatnamelist.length}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);

      }catch(e){

        Fluttertoast.showToast(msg: "Successfully login ${e}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);

      }

    }else{

      Fluttertoast.showToast(msg: " ${response.body}",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }

  }

  Future<void> markattendance(String status, String beatname,BuildContext context) async {

    for(int i=0;i<beatnamelist.length;i++){

      if(beatname == beatnamelist[i]){
          beatId = beatIdlist[i];
      }

    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.post(Uri.parse('${Common.IP_URL}AddSalesPersonAttendanceV3?personId=$userid&status=$status&latitude=$lat&longitude=$lng&beatId=$beatId'), headers: headers);

    if(response.statusCode == 200){

      Navigator.pop(context);
      Fluttertoast.showToast(msg: response.body.toString(),
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }else{

      Navigator.pop(context);
      Fluttertoast.showToast(msg: "Please contact admin!!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }

  }

}
