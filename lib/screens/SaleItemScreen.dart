import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:promoterapp/models/SalesItem.dart';
import 'package:promoterapp/models/SchemeItem.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/Common.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/Categorylist.dart';
import 'package:provider/provider.dart';
import 'package:battery_plus/battery_plus.dart';
import '../models/Item.dart';
import '../provider/DropdownProvider.dart';
import '../util/Helper.dart';
import 'package:location/location.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class SalesItemScreen extends StatefulWidget{

  String retailerName="",retailerId="",address="",date="",status="";
  double? retlat,retlon,distance;
  String? dist,distId,isdistanceallowed,deliveryDate;
  int userid=0,idx=0;
  String? elapsedTime;
  File? cameraFile;

  SalesItemScreen({required this.retailerName,required this.retailerId, required this.dist,required this.distId, required this.address,required this.date, required this.status,required this.retlat,required this.retlon, required this.distance, required this.isdistanceallowed, required this.deliveryDate,required this.elapsedTime, required this.cameraFile});

  @override
  State<StatefulWidget> createState() {
    return SalesItemState();
  }

}

class SalesItemState extends State<SalesItemScreen>{

  TextEditingController boxes = new TextEditingController();
  TextEditingController stock = new TextEditingController();
  late Timer _timer;
  String? cdate;
  Future<List>? furturecategoryitem,furturecategory;
  String? dropdowncategory,dropdownitem,shoptype="old",isdistanceallowed;
  List<String>? selectedvalues,selectedvaluesitem,schemevalueitem,schemevalue=[],dropdownOptions= [];
  List<num>? quantity =[];
  List catenamlist = [], cateidlist = [],itemlist= [], itemidlist = [],
      categorylistscheme=[],categoryidscheme = [],itemlistscheme=[],itemidscheme = [];
  int numElements = 1,userid=0;
  List<Object> itemobjectlist = [];
  double distanceInMeters=0.0;
  List dynamicList = [];
  var pwdWidgets = <Widget>[];
  bool quantity_layout =false,isturnedon=false;
  int _batteryLevel = 0,lisindex=0;
  Future<dynamic>? best;
  LocationData? _currentPosition;
  Location location = new Location();
  int idx=0;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  Stopwatch _stopwatch = Stopwatch();

  @override
  void initState() {
    super.initState();
    _startStopwatch();
    getBatteryLevel();
    furturecategory = loadcategory();
    fetchLocation();

  }

  void dispose() async {
    super.dispose();
  //  await _stopWatchTimer.dispose();  // Need to call dispose function.
  }

  void _startStopwatch() {

    _stopwatch.start();
    // _timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
    //   setState(() {
    //     widget.elapsedTime = _stopwatch.elapsed.toString().substring(0, 8);
    //   });
    // });

    _timer = Timer.periodic(Duration(hours: 01, minutes: 23, seconds: 31), (timer) {

      setState(() {
        widget.elapsedTime = _stopwatch.elapsed.toString().substring(0, 8);
      });

    });

  }

  fetchLocation() async {

    try{
      bool _serviceEnabled;
      PermissionStatus _permissionGranted;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          return;
        }
      }

      _currentPosition = await location.getLocation();
      bool ison = await location.serviceEnabled();
      if (!ison) {
        isturnedon = await location.requestService();
      }

      // location.onLocationChanged.listen((LocationData currentLocation) {
      //   setState(() {
      //     _currentPosition = currentLocation;
      //    // getAddress(_currentPosition.latitude, _currentPosition.longitude)
      //         .then((value) {
      //       setState(() {
      //         _address = "＄{value.first.addressLine}";
      //       });
      //     });
      //   });
      // });
    }catch(e){
      print("$e");
    }
    return _currentPosition;
  }

  getBatteryLevel() async {
    Battery _battery = Battery();
    final level = await _battery.batteryLevel;

    setState((){
      _batteryLevel=level;
    });

  }

  @override
  Widget build(BuildContext context) {
    final dropdownOptionsProvider = Provider.of<DropdownProvider>(context);

    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color(0xFF063A06),
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
          title: const Text("All Items", style: TextStyle(color:Colors.white,fontFamily: 'OpenSans',fontWeight: FontWeight.w300)
          ),
          actions: [

            Center(
              child: Text("${widget.elapsedTime}",style: TextStyle(color:Colors.white,fontSize: 19)),
            ),

            IconButton(

                onPressed: (){

                  setState((){
                    addwidget();

                  });

                },

                icon: Icon(Icons.add)
            )

          ],
          backgroundColor: Color(0xFF063A06),
          leading: GestureDetector(
            onTap:(){
              dropdownOptionsProvider.remove();
              Navigator.of(context).pop();

            },
            child:Icon(Icons.cancel),
          ),
          iconTheme: const IconThemeData(color:Colors.white),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: double.infinity,
            child:  Column(
                children: [

                  Container(
                      height: 90,
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                          color: Color(0xFF063A06),
                          borderRadius: BorderRadius.all(Radius.circular(10.0))
                      ),
                      child:Column(
                        children: [

                          Row(
                            children: [

                              Expanded(
                                  flex: 1,
                                  child: Text("${widget.retailerName}",style: TextStyle(color: Colors.white))
                              ),

                              Expanded(
                                  flex: 1,
                                  child: Align(
                                      alignment: Alignment.centerRight,
                                      child: Text("Id : ${widget.retailerId}",style: TextStyle(color: Colors.white),)
                                  )
                              )

                            ],
                          ),

                          Padding(
                            padding: EdgeInsets.only(left: 5,right: 5),
                            child:  Divider(
                                thickness: 1.0,
                                color: Colors.yellow
                            ),
                          ),

                          Row(
                            children: [

                              Expanded(
                                  flex: 1,
                                  child: Text("${widget.dist}",style: TextStyle(color: Colors.white))),

                              Expanded(
                                  flex: 1,
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Text("Date : ${widget.date}",style: TextStyle(color: Colors.white)),
                                  )
                              )

                            ],
                          ),

                        ],
                      )
                  ),

                  SizedBox(
                    child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: dynamicList.length,
                        itemBuilder: (_, index) =>
                        dynamicList[index]
                    ),
                  ),

                  Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: GestureDetector(

                      onTap: (){
                        submitsales(dropdownOptionsProvider);
                      },

                      child: Container(
                        margin: const EdgeInsets.all(10),
                        width: double.infinity,
                        height: 55,
                        decoration: BoxDecoration(
                            color: Color(0xFF063A06),
                            borderRadius: BorderRadius.all(Radius.circular(15.0))
                        ),

                        child: Center(
                          child: Text(
                            "SUBMIT",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),

                    ),
                  ),

                ]
            ),
          ),
        )
    );
  }

  void addwidget(){

    setState(() {
      dynamicList.add(MyWidget(catenamlist,cateidlist,idx,itemlist,itemidlist));
    });
    idx++;

  }

  Future<List> loadcategoryitem(int index,String val,int opt) async {

    Fluttertoast.showToast(msg: "Please contact admin!!$opt",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);

    int id=0;

    for(int i=0;i<catenamlist.length;i++){

      if(index==i){
        id = cateidlist[i];
      }

    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    itemlist.clear();
    var response = await http.get(Uri.parse('${Common.IP_URL}Getitem?itemType=$id'), headers: headers);

    if(response.statusCode == 200){

      try{

        final list = jsonDecode(response.body);

        List<Item> categryitem = [],itemlistt = [];
        categryitem = list.map<Item>((m) => Item.fromJson(Map<String, dynamic>.from(m))).toList();

        for(int i=0 ;i<categryitem.length;i++) {

          setState(() {
            itemlistt.add(Item(itemName: categryitem[i].itemName));
          });

        }

        itemlist.add(itemlistt);

        // if(opt=="item"){
        //
        //   for(int i=0 ;i<categryitem.length;i++){
        //
        //     setState(() {
        //       itemlist.add(categryitem[i].itemName.toString());
        //     });
        //
        //   }
        //   itemobjectlist.insert(index, itemlist);
        // }else{
        //
        //   for(int i=0 ;i<categryitem.length;i++){
        //
        //     setState(() {
        //       itemlistscheme.add(categryitem[i].itemName.toString());
        //     });
        //
        //   }
        //
        // }

      }catch(e){

        Fluttertoast.showToast(msg: "Please contact admin!!$e",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);

      }

    }else{

      Fluttertoast.showToast(msg: "Something went wrong!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }

    Fluttertoast.showToast(msg:"${itemlist.length}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);

    return itemlist;

  }

  Future<List> loadcategory() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.get(Uri.parse('${Common.IP_URL}GetCatgories?userid=$userid'), headers: headers);

    if(response.statusCode == 200){

      try{

        final list = jsonDecode(response.body);

        List<Categorylist> categorydata = [];
        categorydata = list.map<Categorylist>((m) => Categorylist.fromJson(Map<String, dynamic>.from(m))).toList();

        for(int i=0 ;i<categorydata.length;i++){
          catenamlist.add(categorydata[i].typeName.toString());
          cateidlist.add(categorydata[i].id);
        }


      }catch(e){

        Fluttertoast.showToast(msg: "Please contact admin!!",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);

      }

    }else{

      Fluttertoast.showToast(msg: "Something went wrong!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }

    return catenamlist;
  }

  Future<List> submitsales(DropdownProvider dropdownOptionsProvider) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;
    cdate = getcurrentdatewithtime();

    List<SalesItem> items = [];
    List<SchemeItem> schemeitem = [];

    for(int i=0;i<dynamicList.length;i++){

     items.add(SalesItem(int.parse(dropdownOptionsProvider.selecteditem[i].toString()),int.parse(dropdownOptionsProvider.selecteditemorder[i].toString()),int.parse(dropdownOptionsProvider.selecteditemstock[i].toString()),0));

    }

    for(int i=0;i<dynamicList.length;i++){
      schemeitem.add(SchemeItem(int.parse(dropdownOptionsProvider.selectedschemeitemid[i].toString()),dropdownOptionsProvider.selectedschemename[i].toString(),dropdownOptionsProvider.selectedschemeitemorder[i]));
    }

    var salesentry=[{
      "personId":userid,
      "shopId":widget.retailerId,
      "saleDateTime":cdate,
      "status":widget.status,
      "latitude":_currentPosition?.latitude,
      "longitude":_currentPosition?.latitude,
      "battery":_batteryLevel,
      "GpsEnabled":isturnedon,
      "accuracy":_currentPosition?.accuracy,
      "speed":_currentPosition?.speed,
      "provider":_currentPosition?.provider,
      "altitude":_currentPosition?.altitude,
      "shopType":shoptype,
      "salesType":"secondary",
      "timeDuration":"0.0",
      "startLatitude":widget.retlat,
      "startLongitude":widget.retlon,
      "distId":widget.distId,
      "distance":widget.distance,
      "deliveryDate":widget.deliveryDate,
      "allowed":widget.isdistanceallowed,
      "items":items,
      "schemes":schemeitem
    }];

    var body = json.encode(salesentry);
    print("body${body.toString()}");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var request = await http.MultipartRequest('POST', Uri.parse('${Common.IP_URL}SaveSalesWithImgAndGetId2'));
    request.fields['salesEntry']= body.toString();
    request.files.add(await http.MultipartFile.fromPath('image', widget.cameraFile!.path));

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responsedData = json.decode(responsed.body);

    if(responsedData.contains("DONE")){

      Fluttertoast.showToast(msg: "Sales Saved",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

   //   Navigator.of(context).pop();

    }else{

      Fluttertoast.showToast(msg: "Something went wrong!Please try again!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }


    return catenamlist;

  }

}

class MyWidget extends StatelessWidget {

  List catenamlist = [], cateidlist = [],itemidlist = [], itemlist=[],schemeitemidlist = [], schemeitemlist=[];
  int idx=0;
  Future<List>? furturecategoryitem,furtureschemeitem;
  TextEditingController order = new TextEditingController();
  TextEditingController stock = new TextEditingController();
  TextEditingController schemorder = new TextEditingController();
  TextEditingController textdata = new TextEditingController();

  MyWidget(this.catenamlist, this.cateidlist,this.idx,this.itemlist,this.itemidlist);

  @override
  Widget build(BuildContext context) {

    final dropdownOptionsProvider = Provider.of<DropdownProvider>(context);
    dropdownOptionsProvider.selectedcategory.add("CANOLA");
    dropdownOptionsProvider.selectedschemecategory.add("CANOLA");
 // dropdownOptionsProvider.selecteditem.add(itemlist[0]);

    return Container(

        width: double.infinity,
        margin: const EdgeInsets.only(right: 5),
        padding: const EdgeInsets.only(left: 5, right: 5),
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
                Radius.circular(10.0)
            ),
            border: Border.all(color: Color(0xFF063A06))
        ),
        child: Column(
            children: [

              Container(
                padding: EdgeInsets.only(left:5,top: 10,bottom: 5),
                child:Align(
                  alignment: Alignment.centerLeft,
                  child:  Text("Items",style: TextStyle(fontSize: 16,color: Colors.green)),
                ),
              ),

              DropdownButton<String>(
                isExpanded: true,
                value:dropdownOptionsProvider.selectedcategory[idx],
                // hint: const Text("Select Category",style: TextStyle(fontWeight: FontWeight.w300)),
                onChanged: (String? newValue) {
                  int cateid=0;

                  for(int i=0;i<catenamlist.length;i++){

                    if(catenamlist.indexOf(newValue)==i){
                      cateid = cateidlist[i];
                    }

                  }

                  dropdownOptionsProvider.addDropdownOptions(idx,newValue.toString());
                  furturecategoryitem = loadcategoryitem(cateid,itemlist,itemidlist,dropdownOptionsProvider,idx);

                },
                items: catenamlist.map((e) =>
                    DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    )
                ).toList(),
              ),

              FutureBuilder(
                future: furturecategoryitem,
                builder: (context,snapshot){

                  if(snapshot.hasData){
                    print("$idx ${dropdownOptionsProvider.selecteditem[idx].toString()}") ;
                    return DropdownButton<String>(
                      isExpanded: true,

                      value: dropdownOptionsProvider.selecteditem[idx].toString(),
                      hint: const Text("Select Item",style: TextStyle(fontWeight: FontWeight.w300)),
                      onChanged: (String? newValue) {

                        int itemid=0;
                        for(int i=0;i<itemlist.length;i++){
                          if(itemlist.indexOf(newValue) == i){
                            itemid = itemidlist[i];
                          }
                        }

                        dropdownOptionsProvider.additemdropdown(idx, itemid,newValue.toString());
                      },
                      items: itemlist.map((e) =>
                          DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          )
                      ).toList(),
                    );
                  }
                  return Container();
                },
              ),

              Container(
                  margin: EdgeInsets.all(5),
                  child: Row(
                    children: [

                      Expanded(
                          flex: 1,
                          child: SizedBox(
                            width: double.infinity,
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: const EdgeInsets.only(right: 5),
                                height: 40,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.0,
                                        color: Colors.grey
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(2.0))
                                ),
                                child: TextFormField(
                                  onChanged: (value) {

                                    dropdownOptionsProvider.additemboxes(idx,int.parse(value));

                                  },
                                  controller: order,
                                  decoration: InputDecoration(hintText: 'boxes',border: InputBorder.none),
                                ),
                              ),
                            ),
                          )
                      ),

                      Expanded(
                        flex: 1,
                        child: Align(
                          alignment: Alignment.center,
                          child: Container(
                            margin: const EdgeInsets.only(left: 5),
                            height: 40,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 1.0,
                                    color: Colors.grey
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(2.0))
                            ),
                            child: TextFormField(
                              onChanged: (value) {
                                dropdownOptionsProvider.additemstock(idx,int.parse(value));
                              },
                              controller: textdata,
                              decoration: const InputDecoration(hintText: 'pieces',border: InputBorder.none),
                            ),
                          ),
                        ),
                      ),

                    ],
                  )
              ),

              Container(
                padding: EdgeInsets.only(left:5,top: 10,bottom: 5),
                child:Align(
                  alignment: Alignment.centerLeft,
                  child:Text("Schemes",style: TextStyle(fontSize: 16,color: Colors.green)),
                ),
              ),

              DropdownButton<String>(
                isExpanded: true,
                value:dropdownOptionsProvider.selectedschemecategory.first,
                // hint: const Text("Select Category",style: TextStyle(fontWeight: FontWeight.w300)),
                onChanged: (String? newValue) {
                  int cateid=0;

                  for(int i=0;i<catenamlist.length;i++){

                    if(catenamlist.indexOf(newValue)==i){
                      cateid = cateidlist[i];
                    }

                  }
                  dropdownOptionsProvider.addDropdownschemecategory(idx,newValue.toString());
                  furtureschemeitem = loadcategoryschemeitem(cateid,schemeitemlist,schemeitemidlist);

                },
                items: catenamlist.map((e) =>
                    DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    )
                ).toList(),
              ),

              FutureBuilder(
                future: furtureschemeitem,
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    // dropdownOptionsProvider.selecteditem.add(itemlist[0]);
                    return  DropdownButton<String>(
                      isExpanded: true,
                      //value: dropdownOptionsProvider.selecteditem[idx],
                      hint: const Text("Select Item",style: TextStyle(fontWeight: FontWeight.w300)),
                      onChanged: (String? newValue) {
                        int itemid=0;
                        for(int i=0;i<schemeitemlist.length;i++){
                          if(schemeitemlist.indexOf(newValue) == i){
                            itemid = schemeitemidlist[i];
                          }
                        }

                        dropdownOptionsProvider.additemschemedropdown(idx, itemid,newValue.toString(),0);
                      },
                      items: schemeitemlist.map((e) =>
                          DropdownMenuItem<String>(
                            value: e,
                            child: Text(e),
                          )
                      ).toList(),
                    );
                  }
                  return Container();
                },
              ),

              Container(
                  margin: EdgeInsets.all(5),
                  child: Row(
                    children: [

                      Expanded(
                          flex: 1,
                          child: SizedBox(
                            width: double.infinity,
                            child: Align(
                              alignment: Alignment.center,
                              child: Container(
                                margin: EdgeInsets.only(right: 5),
                                height: 40,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 1.0,
                                        color: Colors.grey
                                    ),
                                    borderRadius: BorderRadius.all(Radius.circular(2.0))
                                ),
                                child: TextFormField(
                                  onChanged: (value){
                                    dropdownOptionsProvider.addschitemboxes(idx,int.parse(value));
                                  },
                                  controller: schemorder,
                                  decoration: InputDecoration(hintText: 'boxes',border: InputBorder.none),
                                ),
                             ),
                           ),
                        )
                      ),

                    ],
                  )
              ),

            ]
        )
    );

  }

//
// Future<List> loadcategory() async {
//
//   SharedPreferences prefs = await SharedPreferences.getInstance();
//   userid = prefs.getInt(Common.USER_ID)!;
//
//   Map<String, String> headers = {
//     'Content-Type': 'application/json',
//   };
//
//   var response = await http.get(Uri.parse('${Common.IP_URL}GetCatgories?userid=768'), headers: headers);
//
//   if(response.statusCode == 200){
//
//     try{
//
//       final list = jsonDecode(response.body);
//
//       List<Categorylist> categorydata = [];
//       categorydata = list.map<Categorylist>((m) => Categorylist.fromJson(Map<String, dynamic>.from(m))).toList();
//
//       for(int i=0 ;i<categorydata.length;i++){
//         catenamlist.add(categorydata[i].typeName.toString());
//         cateidlist.add(categorydata[i].id);
//       }
//
//
//     }catch(e){
//
//       Fluttertoast.showToast(msg: "Please contact admin!!",
//           toastLength: Toast.LENGTH_SHORT,
//           gravity: ToastGravity.BOTTOM,
//           timeInSecForIosWeb: 1,
//           backgroundColor: Colors.black,
//           textColor: Colors.white,
//           fontSize: 16.0);
//
//     }
//
//   }else{
//
//     Fluttertoast.showToast(msg: "Something went wrong!",
//         toastLength: Toast.LENGTH_SHORT,
//         gravity: ToastGravity.BOTTOM,
//         timeInSecForIosWeb: 1,
//         backgroundColor: Colors.black,
//         textColor: Colors.white,
//         fontSize: 16.0);
//
//   }
//
//   return catenamlist;
// }
//

}

Future<List> loadcategoryitem(int cid, List itemlistt,List itemid, DropdownProvider dropdownOptionsProvider,int idx) async {

  Fluttertoast.showToast(msg: "index value $idx",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);

  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  var response = await http.get(Uri.parse('${Common.IP_URL}Getitem?itemType=$cid'), headers: headers);

  if(response.statusCode == 200){

    try{

      final list = jsonDecode(response.body);

      List<Item> categryitem = [];
      categryitem = list.map<Item>((m) => Item.fromJson(Map<String, dynamic>.from(m))).toList();
      itemlistt.clear();
      itemid.clear();

      for(int i=0 ;i<categryitem.length;i++) {

        itemlistt.add(categryitem[i].itemName);
        itemid.add(categryitem[i].itemID);

        dropdownOptionsProvider.additemdropdown(idx,categryitem[idx].itemID!.toInt(),categryitem[idx].itemName.toString());

      }

    }catch(e){

      Fluttertoast.showToast(msg: "Please contact adminn!!$e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }

  }else{

    Fluttertoast.showToast(msg: "Something went wrong!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);

  }

  return itemlistt;
}

Future<List> loadcategoryschemeitem(int cid, List schemeitemlist,List schemeitemid) async {

  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  var response = await http.get(Uri.parse('${Common.IP_URL}Getitem?itemType=$cid'), headers: headers);

  if(response.statusCode == 200){

    try{

      final list = jsonDecode(response.body);

      List<Item> categryitem = [];
      categryitem = list.map<Item>((m) => Item.fromJson(Map<String, dynamic>.from(m))).toList();
      schemeitemlist.clear();
      schemeitemid.clear();

      for(int i=0 ;i<categryitem.length;i++) {

        schemeitemlist.add(categryitem[i].itemName);
        schemeitemid.add(categryitem[i].itemID);
      }

    }catch(e){

      Fluttertoast.showToast(msg: "Please contact adminn!!$e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }

  }else{

    Fluttertoast.showToast(msg: "Something went wrong!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);

  }

  return schemeitemlist;
}


