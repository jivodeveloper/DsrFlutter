import 'dart:collection';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:promoterapp/models/StateByPerson.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config/Common.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import '../models/Shops.dart';
import '../util/Helper.dart';
import 'package:permission_handler/permission_handler.dart' as Permission;

import 'SalesScreen.dart';

class NewRetailer extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return NewRetailerState();
  }

}

class NewRetailerState extends State<NewRetailer>{

  final formGlobalKey = GlobalKey<FormState>();

  List<String> statelist = [],stateidlist = [],zonelist = [],arealist = [],
      group = ["GT","MT"],category = ["A","B","C","D"], beatname = [],
      shoptype = ["Grocery","Bakery","Chemist","General Store","Modern Store","Rural","Distributor"];

  List<int> zoneidlist = [], areaidlist = [], beatIdlist = [];

  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController owner = TextEditingController();
  TextEditingController mobile = TextEditingController();

  int? beatid,stateid,zoneid,areaid;
  String? statetypedown,zonetypedown,areatypedown,
      categorydropdownValue,groupdropdown,shoptypedown,
      dropdownvalue,formatter,cdate,beatdropdown;

  late Future<List> futurestate,futurezone,futurebeat;
  List distIdlist = [];
  XFile? cameraFile;
  var status;
  LocationData? _currentPosition;
  List<StateByPerson> statedata = [];
  List<Shops> shopdata = [];

  @override
  void initState() {
    super.initState();

    futurestate = loadstate();
    cdate = getcurrentdatewithtime();
    fetchLocation();
    futurebeat = getbeat();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("New Outlet",
              style: TextStyle(color:Color(0xFF063A06),fontFamily: 'OpenSans',fontWeight: FontWeight.w300)
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color:Color(0xFF063A06)),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [

              Container(
                width:double.infinity,
                height: 100,
                margin: EdgeInsets.all(10),
                padding:EdgeInsets.all(7),
                child:GestureDetector(
                  onTap: (){
                    selectFromCamera();
                  },
                  child: cameraFile == null
                      ? Center(child: Image.asset('assets/Images/picture.png'))
                      : Center(child: Image.file(File(cameraFile!.path))),
                  //   child: Image.asset('assets/Images/picture.png'),
                ),
              ),

              Container(
                width:double.infinity,
                height: 50,
                margin: EdgeInsets.all(10),
                padding:EdgeInsets.all(7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(color: Color(0xFFD2C7C7))
                ),
                child:DropdownButton<String>(
                  value: shoptypedown,
                  isExpanded: true,
                  elevation: 80,
                  hint: const Text("Select shoptype",style: TextStyle(fontFamily: 'OpenSans',fontWeight: FontWeight.w100),),
                  style: const TextStyle(color: Color(0xFF063A06)),
                  underline: Container(),
                  onChanged: (String? value) {
                    setState(() {
                      shoptypedown = value!;
                    });
                  },
                  items: shoptype.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),

              Container(
                width:double.infinity,
                height: 50,
                margin: EdgeInsets.all(10),
                padding:EdgeInsets.all(7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(color: Color(0xFFD2C7C7))
                ),
                child:DropdownButton<String>(
                  isExpanded: true,
                  value: categorydropdownValue,
                  elevation: 16,
                  hint: const Text("Select category",style: TextStyle(fontFamily: 'OpenSans',fontWeight: FontWeight.w100),),
                  style: const TextStyle(color: Color(0xFF063A06)),
                  underline: Container(),
                  onChanged: (String? value) {
                    setState(() {
                      categorydropdownValue = value!;
                    });
                  },
                  items: category.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),

              Container(
                width:double.infinity,
                height: 50,
                margin: EdgeInsets.all(10),
                padding:EdgeInsets.all(7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(color: Color(0xFFD2C7C7))
                ),
                child:DropdownButton<String>(
                  hint: const Text("Select group",style: TextStyle(fontFamily: 'OpenSans',fontWeight: FontWeight.w100),),
                  isExpanded: true,
                  value: groupdropdown,
                  elevation: 16,
                  style: const TextStyle(color: Color(0xFF063A06)),
                  underline: Container(),
                  onChanged: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      groupdropdown = value!;
                    });
                  },
                  items: group.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),

              Form(
                key: formGlobalKey,
                child: Column(
                  children: [

                    Padding(
                      padding: EdgeInsets.all(10),
                      child:TextFormField(
                        controller: name,
                        validator: (name) {
                          if (name==""){
                            return 'Please enter retailer name';
                          }
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock,
                              color: Color(0xFF063A06),),
                            hintText:'Name'
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        controller: address,
                        validator: (address) {
                          if (address==""){
                            return 'Please enter address';
                          }
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.home,
                              color: Color(0xFF063A06),),
                            hintText:'Address'
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        inputFormatters: [
                          LengthLimitingTextInputFormatter(6),
                          FilteringTextInputFormatter.allow(RegExp(r'^\d{0,6}$')),
                        ],
                        controller: pincode,
                        keyboardType: TextInputType.number,
                        validator: (pincode) {
                          if (pincode!.isEmpty) {
                            return 'Please enter a 6-digit pin code';
                          } else if (pincode.length < 6) {
                            return 'Pin code must be 6 digits';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.pin,
                            color: Color(0xFF063A06),
                          ),
                          hintText: 'Pin Code',
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        controller:owner,
                        validator: (owner) {
                          if (owner==""){
                            return 'Please enter owner name';
                          }
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person,
                              color: Color(0xFF063A06),),
                            hintText:'Owner'
                        ),
                      ),
                    ),

                    Padding(
                       padding: EdgeInsets.all(10),
                       child: TextFormField(
                       inputFormatters: [
                          LengthLimitingTextInputFormatter(10),
                          FilteringTextInputFormatter.allow(RegExp(r'^\d{0,10}$')),
                       ],
                        controller: mobile,
                        keyboardType: TextInputType.phone,
                        validator: (mobile) {
                          if (mobile!.isEmpty) {
                            return 'Please enter a mobile number';
                          } else if (mobile.length < 10) {
                            return 'Mobile number must be 10 digits';
                          }
                          return null;
                     },
                       decoration: InputDecoration(
                         prefixIcon: Icon(
                           Icons.mobile_screen_share,
                           color: Color(0xFF063A06),
                         ),
                         hintText: 'Mobile',
                       ),
                       onChanged: (value) {
                         if (value.length > 0) {
                           // Perform any additional logic here
                         }
                       },
                      ),
                    ),

                 ],
                ),
              ),

              FutureBuilder<List>(
                  future:futurebeat,
                  builder: (context,snapshot){
                    if(snapshot.hasData){

                      return Container(
                        width:double.infinity,
                        height: 50,
                        margin: const EdgeInsets.all(10),
                        padding:const EdgeInsets.all(7),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            border: Border.all(color: Color(0xFFD2C7C7))
                        ),
                        child:DropdownButton(
                          isExpanded: true,
                          value: beatdropdown,
                          hint: const Text("Select Beat",style: TextStyle(fontFamily: 'OpenSans',fontWeight: FontWeight.w100),),
                          elevation: 16,
                          style: const TextStyle(color: Color(0xFF063A06)),
                          underline: Container(),
                          onChanged: (value) {

                            for(int i=0;i<beatname.length;i++){
                              if(beatname.indexOf(value.toString()) == i){
                                beatid = beatIdlist[i];
                              }
                            }
                            setState(() {
                              beatdropdown = value.toString();
                            });

                          },
                          items:snapshot.data?.map((e) =>
                              DropdownMenuItem<String>(
                                value: e,
                                child: Text(e.toString()),
                              )
                          ).toList(),

                        ),
                      );

                    }else if(snapshot.hasError){
                      return Container();
                    }

                    return const CircularProgressIndicator();
                  }

              ),

              FutureBuilder<List>(
                  future:futurestate,
                  builder: (context,snapshot){
                    if(snapshot.hasData){

                      return Container(
                        width:double.infinity,
                        height: 50,
                        margin: EdgeInsets.all(10),
                        padding:EdgeInsets.all(7),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            border: Border.all(color: Color(0xFFD2C7C7))
                        ),
                        child:DropdownButton(
                          isExpanded: true,
                          value: statetypedown,
                          hint: const Text("Select State",style: TextStyle(fontFamily: 'OpenSans',fontWeight: FontWeight.w100),),
                          elevation: 16,
                          style: const TextStyle(color: Color(0xFF063A06)),
                          underline: Container(),
                          onChanged: (value) {

                            setState(() {
                              statetypedown = value.toString();
                            });

                          },
                          items:snapshot.data?.map((e) =>
                              DropdownMenuItem<String>(
                                value: e,
                                child: Text(e.toString()),
                              )
                          ).toList(),

                        ),
                      );

                    }else if(snapshot.hasError){
                      return Container();
                    }

                    return const CircularProgressIndicator();
                  }

              ),

              FutureBuilder<List>(
                  future:futurestate,
                  builder: (context,snapshot){
                    if(snapshot.hasData){
                      return  Container(
                        width:double.infinity,
                        height: 50,
                        margin: EdgeInsets.all(10),
                        padding:EdgeInsets.all(7),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            border: Border.all(color: Color(0xFFD2C7C7))
                        ),
                        child:DropdownButton<String>(
                          isExpanded: true,
                          value: zonetypedown,
                          hint: const Text("Select Zone",style: TextStyle(fontFamily: 'OpenSans',fontWeight: FontWeight.w100),),
                          elevation: 16,
                          style: const TextStyle(color: Color(0xFF063A06)),
                          underline: Container(),
                          onChanged:(newVal) {

                            for(int i=0;i<zonelist.length;i++){
                              if(zonelist.indexOf(newVal.toString()) == i){
                                zoneid = zoneidlist[i];
                              }
                            }

                            setState(() {
                              zonetypedown = newVal.toString();
                            });

                            getarea(newVal.toString());

                          },
                          items: zonelist.map((value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                      );
                    }else if(snapshot.hasError){
                      return Container();
                    }
                    return const CircularProgressIndicator();
                  }
              ),

              Container(
                width:double.infinity,
                height: 50,
                margin: EdgeInsets.all(10),
                padding:EdgeInsets.all(7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(color: Color(0xFFD2C7C7))
                ),
                child:DropdownButton<String>(
                  value: areatypedown,
                  isExpanded: true,
                  hint: const Text("Select Area",style: TextStyle(fontFamily: 'OpenSans',fontWeight: FontWeight.w100),),
                  elevation: 16,
                  style: const TextStyle(color: Color(0xFF063A06)),
                  underline: Container(),
                  onChanged:(newVal) {

                    for(int i=0;i<arealist.length;i++){
                      if(arealist.indexOf(newVal.toString()) == i){
                        areaid = areaidlist[i];
                      }
                    }

                    setState(() {
                      areatypedown = newVal.toString();
                    });

                  },
                  items: arealist.map((value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),

              // FutureBuilder<List>(
              //     future:futurestate,
              //     builder: (context,snapshot){
              //       if(snapshot.hasData){
              //         return  Container(
              //           width:double.infinity,
              //           height: 50,
              //           margin: EdgeInsets.all(10),
              //           padding:EdgeInsets.all(7),
              //           decoration: BoxDecoration(
              //               borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //               border: Border.all(color: Color(0xFFD2C7C7))
              //           ),
              //           child:DropdownButton<String>(
              //             isExpanded: true,
              //             hint: const Text("Select Area",style: TextStyle(fontFamily: 'OpenSans',fontWeight: FontWeight.w100),),
              //             elevation: 16,
              //             style: const TextStyle(color: Color(0xFF063A06)),
              //             underline: Container(),
              //             onChanged: (String? value) {
              //               // This is called when the user selects an item.
              //               setState(() {
              //                 areatypedown = value!;
              //               });
              //             },
              //             items: arealist.map<DropdownMenuItem<String>>((String value) {
              //               return DropdownMenuItem<String>(
              //                 value: value,
              //                 child: Text(value),
              //               );
              //             }).toList(),
              //           ),
              //         );
              //       }else if(snapshot.hasError){
              //         return Container();
              //       }
              //       return const CircularProgressIndicator();
              //     }
              // ),

              GestureDetector(
                onTap:(){
                  if (formGlobalKey.currentState!.validate()) {

                  }

                  checkvalidation();
                },
                child: Container(
                    margin: EdgeInsets.only(left:10,top:40,right:10,bottom: 10),
                    width: double.infinity,
                    height: 50,
                    decoration: BoxDecoration(
                        color: Color(0xFF063A06),
                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                    ),
                    child: Center(
                      child: Text("Submit",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                ),

              )

            ],
          ),
        )
    );
  }

  selectFromCamera() async {

    var status = await Permission.Permission.camera.status;
    if(status == Permission.PermissionStatus.denied){

      Fluttertoast.showToast(msg: "Please allow camera permission!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }else{

      try{

        final cameraFile= await ImagePicker().pickImage(
            source: ImageSource.camera
        );
        setState(() {
          this.cameraFile = cameraFile;
        });

      }catch(e){
        print('Failed to pick image: $e');
      }

    }

  }

  getarea(String zone){
    int zoneid=0;

    areaidlist.clear();
    arealist.clear();

    for(int i=0;i<zonelist.length;i++) {
      if (zonelist.indexOf(zone) == i) {
        zoneid = zoneidlist[i];
      }
    }

    for(int i=0;i<statedata.length;i++){

      if(statedata[i].zoneId==zoneid){

        setState(() {
          arealist.add(statedata[i].area.toString());
          areaidlist.add(statedata[i].areaId!);
        });

      }
    }

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

  Future<List<String>> loadstate() async {

    int userid=0;

    SharedPreferences prefs= await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;

    Map<String,String> headers={
      'Content-Type': 'application/json',
    };

    var response = await http.get(Uri.parse('${Common.IP_URL}GetStateZoneAreaByPerson?personId=$userid'), headers: headers);

    final list = jsonDecode(response.body);

    statelist.clear();
    stateidlist.clear();

    zonelist.clear();
    zoneidlist.clear();

    try{

      statedata = list.map<StateByPerson>((m) => StateByPerson.fromJson(Map<String, dynamic>.from(m))).toList();

      for(int i=0;i<statedata.length;i++){

        statelist.add(statedata[i].state.toString());
        stateidlist.add(statedata[i].stateId.toString());

        zonelist.add(statedata[i].zone.toString());
        zoneidlist.add(statedata[i].zoneId!.toInt());

      }

      statelist = LinkedHashSet<String>.from(statelist).toList();
      stateidlist = LinkedHashSet<String>.from(stateidlist).toList();

      zonelist = LinkedHashSet<String>.from(zonelist).toList();
      zoneidlist = LinkedHashSet<int>.from(zoneidlist).toList();
      // arealist = LinkedHashSet<String>.from(arealist).toList();
      // areaid = LinkedHashSet<String>.from(areaid).toList();

      // statelist = statedata.where((str) => seen.add(str.state)).cast<String>().toList();
      // stateid = statedata.where((str) => seen.add(str.stateId as String?)).cast<String>().toList();

      // zonelist = statedata.where((str) => seen.add(str.zone)).toList();
      // zoneid = statedata.where((str) => seen.add(str.zoneId as String?)).toList();
      //
      // arealist = statedata.where((str) => seen.add(str.area)).toList();
      // areaid = statedata.where((str) => seen.add(str.areaId as String?)).toList();

      // for(int i=0;i<statedata.length;i++){
      //   statelist.add(statedata)
      //
      // }

    }catch(e){

      Fluttertoast.showToast(msg: "$e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }

    return statelist;
  }

  Future<List<String>> getbeat() async {

    int userid=0;

    SharedPreferences prefs= await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;

    Map<String,String> headers={
      'Content-Type': 'application/json',
    };

    var response = await http.get(Uri.parse('${Common.IP_URL}GetBeatsByPerson?id=$userid'), headers: headers);

    final list = jsonDecode(response.body);

    beatIdlist.clear();
    beatname.clear();

    try{

      shopdata = list.map<Shops>((m) => Shops.fromJson(Map<String, dynamic>.from(m))).toList();

      for(int i=0;i<shopdata.length;i++){

        beatname.add(shopdata[i].beatName.toString());
        beatIdlist.add(shopdata[i].beatId!.toInt());

      }

      beatname = LinkedHashSet<String>.from(beatname).toList();
      beatIdlist = LinkedHashSet<int>.from(beatIdlist).toList();

    }catch(e){

      Fluttertoast.showToast(msg: "$e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }

    return beatname;
  }

  // void checkPermissionStatus() async{
  //
  //   var status = await Permission.Permission.camera.status;
  //
  //   if (status.isGranted == true) {
  //
  //     Fluttertoast.showToast(msg: "Permission not granted",
  //         toastLength: Toast.LENGTH_SHORT,
  //         gravity: ToastGravity.BOTTOM,
  //         timeInSecForIosWeb: 1,
  //         backgroundColor: Colors.black,
  //         textColor: Colors.white,
  //         fontSize: 16.0);
  //
  //   }else{
  //
  //   }
  // }

  void checkvalidation(){

    if(shoptypedown==null){

      Fluttertoast.showToast(msg: "Select shoptype",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }else if(categorydropdownValue==null){

      Fluttertoast.showToast(msg: "Select category",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }else if(groupdropdown==null){

      Fluttertoast.showToast(msg: "Select group",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }else if(zonetypedown==null){

      Fluttertoast.showToast(msg: "Select zone",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }else if(areatypedown==null){

      Fluttertoast.showToast(msg: "Select area",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }else {


      withsaledialog(context);

    }

  }

  void withsaledialog(BuildContext ctx) {
    showDialog(
      context: ctx,
      builder: (BuildContext context) =>
          AlertDialog(
            content: const Text('Add sales?'),
            actions: <TextButton>[

              TextButton(
                onPressed: () {

                  Navigator.pop(context);
                  savenewretailer();

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
                              SalesScreen(retailerName: name.text, retailerId: "", address: address.text, mobile: mobile.text, latitude: _currentPosition?.latitude, longitude: _currentPosition?.longitude)));

                },
                child: const Text('Yes'),
              )

            ],
          ),
    );
  }

  void savenewretailer() async{

    SharedPreferences prefs= await SharedPreferences.getInstance();
    int userid = prefs.getInt(Common.USER_ID)!;

    var salesentry=[{},{
      "personId":"$userid",
      "shopName":name.text,
      "address":address.text,
      "state":stateidlist[0],
      "zone":"$zoneid",
      "area":"$areaid",
      "pincode":pincode.text,
      "contactPerson":owner.text,
      "contactNo":"",
      "mobileNo":mobile.text,
      "shopType":"$shoptypedown",
      "category":"$categorydropdownValue",
      "imagePath":"",
      "creationDate":cdate,
      "latitude":"${_currentPosition?.latitude}",
      "longitude":"${_currentPosition?.longitude}",
      "shopgroup":"$groupdropdown"}];

    var body = json.encode(salesentry);

    print("savenewretailer ${body.toString()}");

    Map<String,String> headers={

      'Content-Type': 'application/json',
    };

    var request = await http.MultipartRequest('POST', Uri.parse('${Common.IP_URL}SaveNewRetailer'));
    request.fields['newRetailer']= body.toString();
    request.files.add(await http.MultipartFile.fromPath('image', cameraFile!.path));

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

    }else{

      Fluttertoast.showToast(msg: "Something went wrong!Please try again!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }


  }

}