import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:promoterapp/util/DropdownProvider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/Common.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/Categorylist.dart';
import 'package:provider/provider.dart';
import 'package:battery_plus/battery_plus.dart';
import '../models/Item.dart';
import '../util/Helper.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';

class SalesItemScreen extends StatefulWidget{

  String retailerName="",retailerId="",address="",date="",status="";
  double? retlat,retlon;
  String? dist,distId;
  int userid=0;

  SalesItemScreen({required this.retailerName,required this.retailerId, required this.dist,required this.distId, required this.address,required this.date, required this.status,required this.retlat,required this.retlon});

  @override
  State<StatefulWidget> createState() {

    return SalesItemState();

  }

}

class SalesItemState extends State<SalesItemScreen>{

  String? cdate;
  Future<List>? furturecategoryitem,furturecategory ;
  String? dropdowncategory,dropdownitem,shoptype="old",isdistanceallowed;
  List<String> dropdownOptions= [];
  List<String>? selectedvalues,selectedvaluesitem,schemevalueitem;
  List<String> schemevalue=[];
  List<num>? quantity =[];
  List catenamlist = [], cateidlist = [],itemlist = [], itemid = [],categorylistscheme=[],categoryidscheme = [],itemlistscheme=[],itemidscheme = [];
  int numElements = 1,userid=0;
  List<Object> itemobjectlist = [];
  double distanceInMeters=0.0;
  List dynamicList = [];
  var pwdWidgets = <Widget>[];
  bool _isLoading = false, quantity_layout =false,isturnedon=false;
  int _batteryLevel = 0;
  Future<dynamic>? best;
  LocationData? _currentPosition;
  String? _address;
  Location location = new Location();

  @override
  void initState() {
    super.initState();

    getBatteryLevel();
    furturecategory = loadcategory();
    // furturecategoryitem = loadcategoryitem(index, val, opt);
    fetchLocation();
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

            IconButton(

                onPressed: (){

                  setState((){
                    addwidget();
                    //  dropdownOptionsProvider.addDropdownOptions(newOption);
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
        body: SizedBox(
          height: double.infinity,
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
                  height: 400,
                  child: ListView.builder(
                    itemCount: dynamicList.length,
                    itemBuilder: (_, index) =>

                        Container(
                            width: double.infinity,
                            margin: const EdgeInsets.only(right: 5),
                            padding: const EdgeInsets.only(left: 5, right: 5),
                            decoration: BoxDecoration(
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(10.0)),
                                border: Border.all(color: const Color(0xFF063A06))
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

                                FutureBuilder(
                                  future: furturecategory,
                                  builder: (context,snapshot){
                                    if(snapshot.hasData){
                                      for (int i = 0; i < dynamicList.length; i++) {
                                        dropdownOptionsProvider.selectedcategory.add("CANOLA");
                                      }
                                      return DropdownButton<String>(
                                        isExpanded: true,
                                        value:dropdownOptionsProvider.selectedcategory[index],
                                        //  hint: const Text("Select Category",style: TextStyle(fontWeight: FontWeight.w300)),
                                        onChanged: (String? newValue) {

                                          dropdownOptionsProvider.addDropdownOptions(index,newValue.toString());
                                          // dropdownOptionsProvider.setSelectedValue(index, newValue.toString());
                                          furturecategoryitem=loadcategoryitem(catenamlist.indexOf(newValue),newValue.toString(),"item");

                                        },
                                        items: catenamlist.map((e) =>
                                            DropdownMenuItem<String>(
                                              value: e,
                                              child: Text(e),
                                            )
                                        ).toList(),
                                      );
                                    }
                                    return const CircularProgressIndicator();
                                  },
                                ),

                                FutureBuilder(
                                  future: furturecategoryitem,
                                  builder: (context,snapshot){
                                    if(snapshot.hasData){
                                      return DropdownButton<String>(
                                        isExpanded: true,
                                      //  value:dropdownOptionsProvider.selecteditem[index].isEmpty?"Selct item":dropdownOptionsProvider.selecteditem[index],
                                        hint: const Text("Select item",style: TextStyle(fontWeight: FontWeight.w300),),
                                        onChanged: (String? newValue) {
                                          // dropdownOptionsProvider.setSelectedItemValue(index, newValue.toString());
                                          // dropdownOptionsProvider.setSelectedItemValue(index, newValue.toString());
                                        },
                                        items:itemlist.map((e) =>
                                            DropdownMenuItem<String>(
                                              value: e,
                                              child: dropdownOptionsProvider.selectedcategory[index].isEmpty?Text("No item"):Text(e),
                                          )
                                        ).toList(),
                                      );
                                    }
                                    return const CircularProgressIndicator();
                                  },
                                ),

                                Container(
                                  margin: EdgeInsets.all(5),
                                  child: Row(
                                    children: [

                                      Expanded(
                                          flex: 2,
                                          child:Row(
                                            children: [

                                              Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    width: 50,
                                                    height: 25,
                                                    margin: EdgeInsets.only(right: 15),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(width: 1.0,color:Colors.grey),
                                                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                    ),
                                                    child: Center(
                                                      child: Text("RS 2500"),
                                                    ),
                                                  )
                                              ),

                                              Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    width: 50,
                                                    height: 25,
                                                    margin: EdgeInsets.only(right: 15),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(width: 1.0,color:Colors.grey),
                                                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                    ),
                                                    child: Center(
                                                      child: Text("RS 2500"),
                                                    ),
                                                  )
                                              ),

                                            ],
                                          )
                                      ),

                                      Expanded(
                                          flex: 2,
                                          child:Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                      flex: 1,
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        child: Align(
                                                          alignment: Alignment.centerRight,
                                                          child: Container(
                                                            width: 50,
                                                            height: 30,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1.0,
                                                                    color: Colors.grey
                                                                ),
                                                                borderRadius: BorderRadius.all(Radius.circular(2.0))
                                                            ),
                                                            child: TextFormField(
                                                              decoration: InputDecoration(hintText: 'boxes',border: InputBorder.none),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                  ),

                                                  Expanded(
                                                      flex: 1,
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        child: Align(
                                                          alignment: Alignment.centerRight,
                                                          child: Container(
                                                            width: 50,
                                                            height: 30,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1.0,
                                                                    color: Colors.grey
                                                                ),
                                                                borderRadius: BorderRadius.all(Radius.circular(2.0))
                                                            ),
                                                            child: TextFormField(
                                                              decoration: InputDecoration(hintText: 'pieces',border: InputBorder.none),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                  ),

                                                ],
                                              ),

                                            ],
                                          )
                                      )

                                    ],
                                  ),
                                ),

                                Container(
                                    padding: EdgeInsets.only(left:5,top: 10,bottom: 5),
                                    child:Align(
                                      alignment: Alignment.centerLeft,
                                      child:  const Text("Select Scheme",style: TextStyle(fontSize: 16,color: Colors.green)),
                                    )
                                ),

                                FutureBuilder(
                                  future: furturecategory,
                                  builder: (context,snapshot){
                                    if(snapshot.hasData){
                                      for (int i = 0; i < dynamicList.length; i++) {
                                        schemevalue.add("CANOLA");
                                      }
                                      return DropdownButton<String>(
                                        isExpanded: true,
                                        value:schemevalue[index].toString(),
                                        //  hint: const Text("Select Category",style: TextStyle(fontWeight: FontWeight.w300)),
                                        onChanged: (String? newValue) {
                                          schemevalue[index] = newValue.toString();
                                          setState(() {});
                                          //  schemevalue?.insert(index, newValue.toString());
                                          //  loadcategoryitem(catenamlist.indexOf(newValue),newValue.toString());
                                        },
                                        items: categorylistscheme.map((e) =>
                                            DropdownMenuItem<String>(
                                              value: e,
                                              child: Text(e),
                                            )
                                        ).toList(),
                                      );
                                    }
                                    return const CircularProgressIndicator();
                                  },
                                ),

                                DropdownButton<String>(
                                  isExpanded: true,
                                  value: schemevalueitem?[index],
                                  hint: const Text("Select item",style: TextStyle(fontWeight: FontWeight.w300),),
                                  onChanged: (String? newValue) {
                                    schemevalueitem?.insert(index, newValue.toString());
                                    // setSelectedValueitem(index, newValue.toString());
                                  },
                                  items: itemlistscheme.map((e) =>
                                      DropdownMenuItem<String>(
                                        value: e,
                                        child: Text(e),
                                      )
                                  ).toList(),
                                ),

                                Container(
                                  margin: EdgeInsets.all(5),
                                  child: Row(
                                    children: [

                                      Expanded(
                                          flex: 2,
                                          child:Row(
                                            children: [

                                              Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    width: 50,
                                                    height: 25,
                                                    margin: EdgeInsets.only(right: 15),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(width: 1.0,color:Colors.grey),
                                                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                    ),
                                                    child: Center(
                                                      child: Text("RS 2500"),
                                                    ),
                                                  )
                                              ),

                                              Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                    width: 50,
                                                    height: 25,
                                                    margin: EdgeInsets.only(right: 15),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(width: 1.0,color:Colors.grey),
                                                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                    ),
                                                    child: Center(
                                                      child: Text("RS 2500"),
                                                    ),
                                                  )
                                              ),

                                            ],
                                          )
                                      ),

                                      Expanded(
                                          flex: 2,
                                          child:Column(
                                            children: [
                                              Row(
                                                children: [
                                                  Expanded(
                                                      flex: 1,
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        child: Align(
                                                          alignment: Alignment.centerRight,
                                                          child: Container(
                                                            width: 50,
                                                            height: 30,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1.0,
                                                                    color: Colors.grey
                                                                ),
                                                                borderRadius: BorderRadius.all(Radius.circular(2.0))
                                                            ),
                                                            child: TextFormField(
                                                              decoration: InputDecoration(hintText: 'boxes',border: InputBorder.none),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                  ),

                                                  Expanded(
                                                      flex: 1,
                                                      child: SizedBox(
                                                        width: double.infinity,
                                                        child: Align(
                                                          alignment: Alignment.centerRight,
                                                          child: Container(
                                                            width: 50,
                                                            height: 30,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                    width: 1.0,
                                                                    color: Colors.grey
                                                                ),
                                                                borderRadius: BorderRadius.all(Radius.circular(2.0))
                                                            ),
                                                            child: TextFormField(
                                                              decoration: InputDecoration(hintText: 'pieces',border: InputBorder.none),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                  ),

                                                ],
                                              ),
                                            ],
                                          )
                                      )

                                    ],
                                  ),
                                ),

                                Padding(
                                  padding: EdgeInsets.only(left: 10,right: 10),
                                  child:  Divider(
                                      thickness: 0.1,
                                      color: Color(0xFF063A06)
                                  ),
                                ),

                              ],
                            )
                        ),

                  ),
                ),
              ]
          ),
        )
    );

  }

  void addwidget(){

    setState(() {
      dynamicList.add(MyWidget());
    });
    submitsales();
    print("${_currentPosition?.latitude}");

  }

  Future<List> loadcategoryitem(int index,String val,String opt) async {

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

        List<Item> categryitem = [];
        categryitem = list.map<Item>((m) => Item.fromJson(Map<String, dynamic>.from(m))).toList();
        for(int i=0 ;i<categryitem.length;i++) {
          setState(() {
            itemlist.add(categryitem[i].itemName.toString());
          });
        }
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

  Future<List> submitsales() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;
    cdate = getcurrentdate();
    // checkdistancecondition();

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
      "timeDuration":"",
      "startLatitude":widget.retlat,
      "startLongitude":widget.retlon,
      "distId":widget.distId,
      "distance":widget.distId,
      "deliveryDate":widget.distId,
      "allowed":isdistanceallowed}];

    // Map<String, String> headers = {
    //   'Content-Type': 'application/json',
    // };
    //
    // var response = await http.get(Uri.parse('${Common.IP_URL}SaveSalesWithImgAndGetId2?userid=$userid'), headers: headers);
    //
    // if(response.statusCode == 200){
    //
    //   try{
    //
    //     final list = jsonDecode(response.body);
    //
    //     List<Categorylist> categorydata = [];
    //     categorydata = list.map<Categorylist>((m) => Categorylist.fromJson(Map<String, dynamic>.from(m))).toList();
    //
    //     for(int i=0 ;i<categorydata.length;i++){
    //       catenamlist.add(categorydata[i].typeName.toString());
    //       cateidlist.add(categorydata[i].id);
    //     }
    //
    //   }catch(e){
    //
    //     Fluttertoast.showToast(msg: "Please contact admin!!",
    //         toastLength: Toast.LENGTH_SHORT,
    //         gravity: ToastGravity.BOTTOM,
    //         timeInSecForIosWeb: 1,
    //         backgroundColor: Colors.black,
    //         textColor: Colors.white,
    //         fontSize: 16.0);
    //
    //   }
    //
    // }else{
    //
    //   Fluttertoast.showToast(msg: "Something went wrong!",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: Colors.black,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    //
    // }

    return catenamlist;
  }

  Future<void> checkdistancecondition() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    int distanceallowed = prefs.getInt(Common.DISTANCE_ALLOWED)!;
    distanceInMeters = await Geolocator.distanceBetween(_currentPosition!.latitude!.toDouble(),_currentPosition!.longitude!.toDouble(),widget.retlat as double,widget.retlon as double);

    if(distanceInMeters>distanceallowed){
      isdistanceallowed = "0";
      showdistanceallowedmessage();
    }else{
      isdistanceallowed = "1";
    }

  }

  Future<void> showdistanceallowedmessage(){
    return showDialog(
        context: context,
        builder:(BuildContext context) {
          return AlertDialog(

            content:Wrap(
              children: [
                Image.asset('assets/Images/complain.png',width: 40,height: 40,),
                Container(
                  margin: EdgeInsets.all(10),
                  child:Text("Please check your location, this location doesn\'t match with the older one."),
                )

              ],
            ),
            actions: <Widget>[

              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('Cancel'),
              ),

              TextButton(
                onPressed: () =>
                    Navigator.pop(context, 'Cancel'),
                child: const Text('Ok'),
              ),

            ],
          );
        }
    );
  }

  /* void addDropdownOptions(String option){
    dropdownOptions.add(option);
  }

  void removeDropdownOptions(int index){
    dropdownOptions.removeAt(index);
    selectedvalues?.removeAt(index);
  }

  void setSelectedValue(int index,String value){
    setState(() {
      selectedvalues?.insert(index,value);
    });

  }

  void setSelectedValueitem(int index,String value){
    selectedvaluesitem?[index]= value;
  }*/

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
      print("currentloction${_currentPosition?.latitude}");
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

  }

// Future<List<Address>> getAddress(double lat, double lang) async {
//  final coordinates = new Coordinates(latitude, longitude);
//  List<Address> address =
//  await Geocoder.local.findAddressesFromCoordinates(coordinates);
//  return address;
// }

// }

}

class MyWidget extends StatelessWidget {

  List catenamlist = [], cateidlist = [],itemlist = [], itemid = [];
  int userid=0;

  @override
  Widget build(BuildContext context) {

    final dropdownOptionsProvider = Provider.of<DropdownProvider>(context);
    Future<List>? futuree = loadcategory();

    return SizedBox(
      height: 100,
      child: ListView.builder(
          itemCount: dropdownOptionsProvider.selectedcategory.length,
          itemBuilder: (context, index) {
            return ListTile(
                title: FutureBuilder<List>(

                    future: futuree,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(right: 5),
                          height: 50,
                          color: Colors.blue,
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.all(
                                  Radius.circular(10.0)),
                              border: Border.all(color: const Color(0xFF063A06))
                          ),
                          child: DropdownButton<String>(
                            value: dropdownOptionsProvider
                                .selectedcategory[index],
                            onChanged: (String? newValue) {
                              // dropdownOptionsProvider.selecteditem(index, newValue.toString());
                            },
                            items: dropdownOptionsProvider.selectedcategory
                                .map<DropdownMenuItem<String>>(
                                  (String option) =>
                                  DropdownMenuItem<String>(
                                    value: option,
                                    child: Text(option),
                                  ),
                            ).toList(),
                          ),
                        );
                      }
                      return Container();
                    }
                ));
          }),
    );

  }

  Future<List> loadcategory() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.get(Uri.parse('${Common.IP_URL}GetCatgories?userid=768'), headers: headers);

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


}





