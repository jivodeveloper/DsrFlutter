import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Shops.dart';
import '../config/Common.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SalesScreen extends StatefulWidget{

  String retailerName="";
  SalesScreen(String? retailerName);
  int count =0;

  @override
  State<StatefulWidget> createState() {
    return SalesScreenState();
  }

}

class SalesScreenState extends State<SalesScreen>{
  var perstatus;

  List<String> status = ["Done",
    "Shop Closed",
    "Owner not available",
    "Already stocked",
    "Not interested",
  ];
  List<String> shoptype = ["Select shoptype","Grocery","Bakery","Chemist","General Store","Modern Store","Rural","Distributor"];
  XFile? cameraFile;
  String statusdropdown= "Done";
  late Future<List<Shops>> furturedist;

  @override
  void initState() {
    super.initState();
    furturedist = loadalldist();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Sales Screen",
              style: TextStyle(color:Color(0xFF063A06),fontFamily: 'OpenSans',fontWeight: FontWeight.w300)
          )
      ),

      body: SingleChildScrollView(
          child: Column(
            children: [

              Padding(
                padding: EdgeInsets.all(10),
                child:Text("Widget: ${widget.retailerName} "),
              ),

              // Container(
              //   margin:EdgeInsets.fromLTRB(10,20,10,10),
              //   decoration: BoxDecoration(
              //       border: Border.all(color: Color(0xFFEFE4E4))
              //   ),
              //   child:   FutureBuilder<List>(
              //       future: furturedist,
              //       builder: (context, snapshot) {
              //         if (snapshot.hasData) {
              //           return Container(
              //             width:double.infinity,
              //             height: 50,
              //             padding:EdgeInsets.all(7),
              //             decoration: BoxDecoration(
              //                 borderRadius: BorderRadius.all(Radius.circular(10.0)),
              //                 border: Border.all(color: Color(0xFFD2C7C7))
              //             ),
              //             child: DropdownButton<String>(
              //                 underline:Container(),
              //                 hint: const Text("Select Distributor",style: TextStyle(fontFamily: 'OpenSans',fontWeight: FontWeight.w100),),
              //                 isExpanded: true,
              //                 items: snapshot.data?.map((e) =>
              //                     DropdownMenuItem<String>(
              //                       value: e,
              //                       child: Text(e),
              //                     )
              //                 ).toList(),
              //
              //                 onChanged:(newVal) {
              //                   this.setState(() {
              //                     statusdropdown = newVal.toString();
              //                   });
              //                 }
              //
              //             ),
              //           );
              //
              //         } else if (snapshot.hasError) {
              //           return Container();
              //         }
              //
              //         return const CircularProgressIndicator();
              //       }
              //   ),
              // ),

              Container(
                margin:EdgeInsets.fromLTRB(10,20,10,10),
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFEFE4E4))
                ),
                child: TextFormField(
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.calendar_month,
                        color: Color(0xFF063A06),),
                      hintText:'Select Date',
                  ),
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
                  value: statusdropdown,
                  isExpanded: true,
                  elevation: 80,
                  style: const TextStyle(color: Color(0xFF063A06)),
                  underline: Container(),
                  onChanged: (String? value) {
                    // setState(() {
                    //   statusdropdown = value!;
                    // });
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
                height: 100,
                margin: EdgeInsets.all(10),
                padding:EdgeInsets.all(7),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(color: Color(0xFFD2C7C7))
                ),
                child:GestureDetector(

                  onTap: (){
                    selectFromCamera();
                  },
                  child: cameraFile == null ?
                  Center(child: Image.asset('assets/Images/picture.png')) :
                  Center(child: Image.file(File(cameraFile!.path))),

                ),
              ),

            ],
         ),
      ),
    );
  }

  selectFromCamera() async {

    if(perstatus==PermissionStatus.denied){

      Fluttertoast.showToast(msg: "Please allow camera permission!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }else{

      try{

        final cameraFile= await ImagePicker().pickImage(source: ImageSource.camera);

        setState(() {
          this.cameraFile = cameraFile;
        });

      }catch(e){

        print('Failed to pick image: $e');

      }

    }

  }

  Future<List<Shops>> loadalldist() async {

    int userid=0,beatId =0;
    List<Shops> beatshoplist = [];
    SharedPreferences prefs= await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;
    beatId = prefs.getInt(Common.BEAT_ID)!;

    Map<String,String> headers={
      'Content-Type': 'application/json',
    };

    var response = await http.get(Uri.parse('${Common.IP_URL}GetShopsData?id=$userid'), headers: headers);

    List<Shops> distlist = [];
    final list = jsonDecode(response.body);

    try{

      distlist = list.map<Shops>((m) => Shops.fromJson(Map<String, dynamic>.from(m))).toList();

      for(int i=0 ;i<distlist.length;i++){
        if(distlist[i].type == "Distributor"){
          beatshoplist.add(distlist[i]);
        }
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

    Fluttertoast.showToast(msg: "${beatshoplist.length}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);

    return beatshoplist;
  }

}