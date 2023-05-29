import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promoterapp/models/StateByPerson.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config/Common.dart';
import 'dart:convert';
// import 'package:camera/camera.dart';

class NewRetailer extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
   return NewRetailerState();
  }

}

class NewRetailerState extends State<NewRetailer>{

  List<String> shoptype = ["Select shoptype","Grocery","Bakery","Chemist","General Store","Modern Store","Rural","Distributor"];
  List<String> category = ["Select Category","A","B","C","D"];
  List<String> group = ["Select group","GT","MT"];
  List<String> statelist = [];
  List<int> stateid = [];
  List<String> zonelist = [];
  List<int> zoneid = [];
  List<String> arealist = [];
  List<int> areaid = [];

  String categorydropdownValue= "Select Category",groupdropdown = "Select group",shoptypedown= "Select shoptype",statetypedown="Select State";
  late Future<List> futurestate;
  List distIdlist = [];

  // List<CameraDescription>? cameras; //list out the camera available
  // CameraController? controller; //controller for camera
  // XFile? image;

  @override
  void initState() {
    super.initState();
    futurestate = loadstate();
    statelist.add("Select State");
    futurestate =  loadstate();
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
                  // This is called when the user selects an item.
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
                  // This is called when the user selects an item.
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
              ),),

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

            Padding(padding: EdgeInsets.all(10),
              child:TextFormField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock,
                      color: Color(0xFF063A06),),
                    hintText:'Name'
                ),
              ),),

            Padding(padding: EdgeInsets.all(10),
              child: TextFormField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.home,
                      color: Color(0xFF063A06),),
                    hintText:'Address'
                ),
              ),),

            Padding(padding: EdgeInsets.all(10),
              child: TextFormField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.pin,
                      color: Color(0xFF063A06),),
                    hintText:'Pin Code'
                ),
              ),),

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
                        value: statelist.first,
                        elevation: 16,
                        style: const TextStyle(color: Color(0xFF063A06)),
                        underline: Container(),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            statetypedown = value!;
                          });
                        },
                        items: statelist.map<DropdownMenuItem<String>>((String value) {
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

            Padding(padding: EdgeInsets.all(10),
              child: TextFormField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.person,
                      color: Color(0xFF063A06),),
                    hintText:'Owner'
                ),
              ),),

            Padding(
              padding: EdgeInsets.all(10),
              child:TextFormField(
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.mobile_screen_share,
                      color: Color(0xFF063A06),),
                    hintText:'mobile'
                ),
              ),),

            // FutureBuilder<List>(
            //     future: furturedist,
            //     builder: (context, snapshot) {
            //       if (snapshot.hasData) {
            //         return Container(
            //           width:double.infinity,
            //           height: 50,
            //           padding:EdgeInsets.all(7),
            //           decoration: BoxDecoration(
            //               borderRadius: BorderRadius.all(Radius.circular(10.0)),
            //               border: Border.all(color: Color(0xFFD2C7C7))
            //           ),
            //           child: DropdownButton<String>(
            //
            //               underline:Container(),
            //               hint: const Text("Select Distributor",style: TextStyle(fontFamily: 'OpenSans',fontWeight: FontWeight.w100),),
            //               isExpanded: true,
            //               items: snapshot.data?.map((e) =>
            //                   DropdownMenuItem<String>(
            //                     value: e,
            //                     child: Text(e),
            //                   )
            //               ).toList(),
            //
            //               onChanged:(newVal) {
            //                 this.setState(() {
            //                   selectedValue = newVal.toString();
            //                 });
            //               }
            //           ),
            //         );
            //       } else if (snapshot.hasError) {
            //         return Container();
            //
            //       }
            //       return const CircularProgressIndicator();
            //     }),

            Container(
              width:double.infinity,
              height: 100,
              margin: EdgeInsets.all(10),
              padding:EdgeInsets.all(7),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(color: Color(0xFFD2C7C7))
              ),
              child:GestureDetector(
                child: Image.asset('assets/Images/picture.png'),
              ),
            ),

            GestureDetector(

              child: Container(
                margin: EdgeInsets.only(left:10,top:40,right:10,bottom: 10),
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                    color: Color(0xFF063A06),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))
                ),

              ),

            )
          ],
        ),
      )

    );
  }

  Future<List<String>> loadstate() async {

    int userid=0;

    SharedPreferences prefs= await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;

    Map<String,String> headers={
      'Content-Type': 'application/json',
    };

    var response = await http.get(Uri.parse(Common.IP_URL+'GetShopsData?id=$userid'), headers: headers);

    List<StateByPerson> statedata = [];
    final list = jsonDecode(response.body);

    try{

      statedata = list.map<StateByPerson>((m) => StateByPerson.fromJson(Map<String, dynamic>.from(m))).toList();
      statelist.clear();
      statelist.clear();
      statelist.clear();
      statelist.clear();

      statelist.clear();
      for(int i=0 ;i<statedata.length;i++){
        statelist.add(statedata[i].state as String);
        stateid.add(statedata[i].stateId as int);

        zonelist.add(statedata[i].zone as String);
        zoneid.add(statedata[i].zoneId as int);

        arealist.add(statedata[i].area as String);
        areaid.add(statedata[i].areaId as int);
      }

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

  // loadCamera() async {
  //   cameras = await availableCameras();
  //   if(cameras != null){
  //     controller = CameraController(cameras![0], ResolutionPreset.max);
  //     //cameras[0] = first camera, change to 1 to another camera
  //
  //     controller!.initialize().then((_) {
  //       if (!mounted) {
  //         return;
  //       }
  //       setState(() {});
  //     });
  //   }else{
  //     print("NO any camera found");
  //   }
  // }

}