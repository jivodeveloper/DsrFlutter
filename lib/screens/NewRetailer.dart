import 'dart:collection';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promoterapp/models/StateByPerson.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:location/location.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config/Common.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import '../util/Helper.dart';

class NewRetailer extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return NewRetailerState();
  }

}

class NewRetailerState extends State<NewRetailer>{

  final formGlobalKey = GlobalKey < FormState > ();
  List<String> shoptype = ["Grocery","Bakery","Chemist","General Store","Modern Store","Rural","Distributor"];
  List<String> category = ["A","B","C","D"];
  List<String> group = ["GT","MT"];
  List<String> statelist = [],stateid = [],zonelist = [],arealist = [];
  List<int> zoneidlist = [],areaidlist = [];

  TextEditingController name = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController owner = TextEditingController();
  TextEditingController mobile = TextEditingController();

  String? statetypedown,zonetypedown,areatypedown ,categorydropdownValue,groupdropdown,
      shoptypedown,
      dropdownvalue,formatter,cdate;

  late Future<List> futurestate;
  late Future<List> futurezone;
  List distIdlist = [];
  XFile? cameraFile;
  var status;
  LocationData? _currentPosition;

  List<StateByPerson> statedata = [];
  @override
  void initState() {
    super.initState();
    futurestate = loadstate();
    cdate = getcurrentdatewithtime();
    //checkPermissionStatus();
    fetchLocation();
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
                // decoration: BoxDecoration(
                //     shape: BoxShape.circle,
                //     borderRadius: BorderRadius.all(Radius.circular(10.0)),
                //     border: Border.all(color: Color(0xFFD2C7C7))
                // ),
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
                      ),),

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
                      ),),

                    Padding(
                      padding: EdgeInsets.all(10),
                      child: TextFormField(
                        controller: pincode,
                        keyboardType: TextInputType.number,
                        validator: (pincode) {
                          if (pincode==""){
                            return 'Please enter pin code';
                          }
                        },
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.pin,
                              color: Color(0xFF063A06),),
                            hintText:'Pin Code'
                        ),
                      ),),

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
                      child:TextFormField(
                        controller:mobile,
                        keyboardType: TextInputType.phone,
                        validator: (mobile) {

                          if(mobile!.isEmpty){
                            return "Please Enter a Phone Number";
                          }else if(!RegExp(r'^\s*(?:\+?(\d{1,3}))?[-. (]*(\d{3})[-. )]*(\d{3})[-. ]*(\d{4})(?: *x(\d+))?\s*$').hasMatch(mobile)){
                            return "Please Enter a Valid Phone Number";
                          }
                        },

                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.mobile_screen_share,
                                color: Color(0xFF063A06)),
                            hintText:'mobile'
                        ),

                        onChanged: (value){
                          if(value.length>0){

                          }
                        },

                      ),
                    ),

                  ],
                ),
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

    if(status== PermissionStatus.denied){

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

    var response = await http.get(Uri.parse(Common.IP_URL+'GetStateZoneAreaByPerson?personId=$userid'), headers: headers);

    var seen = Set<String?>();

    final list = jsonDecode(response.body);
    List<String> arr=[];
    statelist.clear();
    stateid.clear();
    zonelist.clear();
    zoneidlist.clear();


    try{

      statedata = list.map<StateByPerson>((m) => StateByPerson.fromJson(Map<String, dynamic>.from(m))).toList();

      for(int i=0;i<statedata.length;i++){

        statelist.add(statedata[i].state.toString());
        stateid.add(statedata[i].stateId.toString());

        zonelist.add(statedata[i].zone.toString());
        zoneidlist.add(statedata[i].zoneId!.toInt());

      }

      statelist = LinkedHashSet<String>.from(statelist).toList();
      stateid = LinkedHashSet<String>.from(stateid).toList();
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

  // void checkPermissionStatus() async{
  //   status = await Permission.camera.status;
  //
  //   // if (status != PermissionStatus.granted) {
  //   //
  //   //   Fluttertoast.showToast(msg: "Successfully login ",
  //   //       toastLength: Toast.LENGTH_SHORT,
  //   //       gravity: ToastGravity.BOTTOM,
  //   //       timeInSecForIosWeb: 1,
  //   //       backgroundColor: Colors.black,
  //   //       textColor: Colors.white,
  //   //       fontSize: 16.0);
  //   //
  //   // }else{
  //   //   Fluttertoast.showToast(msg: "Successfully login2",
  //   //       toastLength: Toast.LENGTH_SHORT,
  //   //       gravity: ToastGravity.BOTTOM,
  //   //       timeInSecForIosWeb: 1,
  //   //       backgroundColor: Colors.black,
  //   //       textColor: Colors.white,
  //   //       fontSize: 16.0);
  //   // }
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

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (contextt) =>
                  //             SalesScreen(retailerName: retailerName, retailerId: retailerId, address: address, mobile: mobile, latitude: latitude, longitude: longitude)));
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
      "state":"$statetypedown",
      "zone":"$zonetypedown",
      "area":"$areatypedown",
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

    print("${body.toString()}");

    //
    // Map<String,String> headers={
    //   'Content-Type': 'application/json',
    // };
    //
    //
    // var request = await http.MultipartRequest('POST', Uri.parse('${Common.IP_URL}SaveNewRetailer'));
    // request.fields['newRetailer']= body.toString();
    // request.files.add(await http.MultipartFile.fromPath('image', cameraFile!.path));
    //
    // var response = await request.send();
    // var responsed = await http.Response.fromStream(response);
    // final responsedData = json.decode(responsed.body);
    //
    // if(responsedData.contains("DONE")){
    //
    //   Fluttertoast.showToast(msg: "Sales Saved",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: Colors.black,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    //
    // }else{
    //
    //   Fluttertoast.showToast(msg: "Something went wrong!Please try again!",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: Colors.black,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    //
    // }


  }

}