import 'dart:collection';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promoterapp/models/StateByPerson.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config/Common.dart';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';

class NewRetailer extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
   return NewRetailerState();
  }

}

class NewRetailerState extends State<NewRetailer>{

  final formGlobalKey = GlobalKey < FormState > ();
  List<String> shoptype = ["Select shoptype","Grocery","Bakery","Chemist","General Store","Modern Store","Rural","Distributor"];
  List<String> category = ["Select Category","A","B","C","D"];
  List<String> group = ["Select group","GT","MT"];
  List<String> statelist = [],stateid = [],zonelist = [],zoneid = [],arealist = [],areaid = [];

  String categorydropdownValue= "Select Category",groupdropdown = "Select group",
      shoptypedown= "Select shoptype",
      dropdownvalue = 'Item 1';

  String? statetypedown,zonetypedown,areatypedown;
  late Future<List> futurestate;
  late Future<List> futurezone;
  List distIdlist = [];
  XFile? cameraFile;
  var status;

  @override
  void initState() {
    super.initState();
    futurestate = loadstate();
    checkPermissionStatus();
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
                      validator: (address) {
                        if (address==""){
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
                      validator: (address) {
                        if (address==""){
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
                      validator: (address) {
                        if (address==""){
                          return 'Please enter mobile number';
                        }
                      },
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.mobile_screen_share,
                            color: Color(0xFF063A06),),
                          hintText:'mobile'
                      ),
                    ),),

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
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Processing Data')),
                  );
                }
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

    if(status==PermissionStatus.denied){

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

  Future<List<String>> loadstate() async {

    int userid=0;

    SharedPreferences prefs= await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;

    Map<String,String> headers={
      'Content-Type': 'application/json',
    };

    var response = await http.get(Uri.parse(Common.IP_URL+'GetStateZoneAreaByPerson?personId=$userid'), headers: headers);

    List<StateByPerson> statedata = [];
    var seen = Set<String?>();

    final list = jsonDecode(response.body);
    List<String> arr=[];
    statelist.clear();
    stateid.clear();
    zonelist.clear();
    zoneid.clear();

    try{

      statedata = list.map<StateByPerson>((m) => StateByPerson.fromJson(Map<String, dynamic>.from(m))).toList();

      for(int i=0;i<statedata.length;i++){

        statelist.add(statedata[i].state.toString());
        stateid.add(statedata[i].stateId.toString());

        zonelist.add(statedata[i].zone.toString());
        zoneid.add(statedata[i].zoneId.toString());

        arealist.add(statedata[i].area.toString());
        areaid.add(statedata[i].areaId.toString());

      }

      statelist = LinkedHashSet<String>.from(statelist).toList();
      stateid = LinkedHashSet<String>.from(stateid).toList();
      zonelist = LinkedHashSet<String>.from(zonelist).toList();
      zoneid = LinkedHashSet<String>.from(zoneid).toList();
      arealist = LinkedHashSet<String>.from(arealist).toList();
      areaid = LinkedHashSet<String>.from(areaid).toList();

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

  void checkPermissionStatus() async{
    status = await Permission.camera.status;

    // if (status != PermissionStatus.granted) {
    //
    //   Fluttertoast.showToast(msg: "Successfully login ",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: Colors.black,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    //
    // }else{
    //   Fluttertoast.showToast(msg: "Successfully login2",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: Colors.black,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    // }
  }

  void checkvalidation(){

    if(shoptypedown!="Select shoptype"){

    }else if(categorydropdownValue!="Select Category"){

    }else if(groupdropdown!="Select group"){

    }

  }

}