import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:promoterapp/screens/SaleItemScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Shops.dart';
import '../config/Common.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:native_exif/native_exif.dart';



class SalesScreen extends StatefulWidget{

  String retailerName="",retailerId="",address="",mobile="";
  double? latitude,longitude;

  SalesScreen({required this.retailerName,required this.retailerId, required this.address, required this.mobile,required this.latitude,required this.longitude});

  int count =0;
  String? formatter;

  @override
  State<StatefulWidget> createState() {
    return SalesScreenState();
  }

}

class SalesScreenState extends State<SalesScreen>{

  var perstatus;
  String? persontype;
  int userid=0;
  bool _isLoaderVisible = false;

  List<String> status = [
    "DONE",
    "SHOP CLOSED",
    "OWNER NOT AVAILABLE",
    "ALREADY STOCKED",
    "NOT INTERESTED",
    "TELEPHONIC"
  ];

  int beatId=0;
  List<String> distnamelist = [],distIdlist = [];
  XFile? cameraFile,shelffile1,shelffile2,shelffile3,shelffile4;
  String? statusdropdown ,distributordropdown,distid;
  late Future<List> furturedist;
  TextEditingController dateController = TextEditingController();
  TextEditingController shelf1Controller = TextEditingController();
  TextEditingController shelf2Controller = TextEditingController();
  TextEditingController shelf3Controller = TextEditingController();
  TextEditingController shelf4Controller = TextEditingController();
  String formatter = "";
  final GlobalKey globalKey = new GlobalKey();


  final picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final now = new DateTime.now();
    formatter = DateFormat('yMd').format(now);// 28/03/2020

    if(formatter!=""){
      dateController.text = formatter;
    }

    furturedist = loadalldist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        title: const Text("Sales Screen",
            style: TextStyle(color:Color(0xFF063A06),
                fontFamily: 'OpenSans',fontWeight: FontWeight.w300)
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color:Color(0xFF063A06)),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(color: Color(0xFFC2FAC0))
                ),
                width: double.infinity,
                height: 80,
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.all(5),
                child: Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                  child: Row(
                      children: [

                        Flexible(
                          flex: 6,
                          child:Column(
                            children: [

                              Align(
                                alignment: Alignment.centerLeft,
                                child:Text("${widget.retailerName}",style: TextStyle(fontSize: 20),),
                              ),

                              Align(alignment: Alignment.centerLeft,
                                child:Text("${widget.address}"),
                              ),

                              Align(alignment: Alignment.centerLeft,
                                child:Text("${widget.mobile}"),
                              )

                            ],
                          ),
                        ),

                        Flexible(
                            flex: 1,
                            child: Align(
                              alignment:Alignment.center,
                              child: Icon(Icons.location_pin,size: 36,color: Colors.red,),
                            )
                        )

                      ]
                  ),
                )
            ),

            Container(
              margin:EdgeInsets.fromLTRB(10,20,10,10),
              child:FutureBuilder<List>(
                  future: furturedist,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        width:double.infinity,
                        height: 50,
                        padding:EdgeInsets.all(7),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            border: Border.all(color: Color(0xFFD2C7C7))
                        ),
                        child: DropdownButton<String>(
                            value : distributordropdown,
                            underline:Container(),
                            hint: const Text("Select Distributor",style: TextStyle(fontFamily: 'OpenSans',fontWeight: FontWeight.w100),),
                            isExpanded: true,
                            items: snapshot.data?.map((e) =>
                                DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e.toString()),
                                )
                            ).toList(),

                            onChanged:(newVal) {

                              setState(() {
                                distributordropdown = newVal.toString();
                              });
                              getdistId(newVal.toString());
                            }

                        ),
                      );

                    } else if (snapshot.hasError) {
                      return Container();
                    }
                    return const CircularProgressIndicator();
                  }
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
                hint: const Text("Select Status",style: TextStyle(fontFamily: 'OpenSans',fontWeight: FontWeight.w100),),
                underline: Container(),
                onChanged: (String? value) {

                  setState(() {
                    statusdropdown = value!;
                  });

                },

                items: status.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),

              ),
            ),

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
                readOnly: true,
                controller: dateController,

                onTap: () async {
                  var date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1900),
                      lastDate: DateTime(2100));
                  if (date != null) {

                    dateController.text = DateFormat('MM/dd/yyyy').format(date);

                  }
                },

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
                  selectFromCamera("camera");
                },
                child: cameraFile == null ?
                  Center(child: Image.asset('assets/Images/picture.png',width: 500)):
                   RepaintBoundary(
                    child: Stack(
                        children: <Widget>[
                    Center(child: Image.file(File(cameraFile!.path))),
                    Center(child: Text("text")),
                   ]
                  )
                   )
                ),
              ),

            Container(
              margin:EdgeInsets.fromLTRB(10,20,10,10),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFEFE4E4))
              ),
              child: TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.image,
                    color: Color(0xFF063A06),),
                  hintText:'Shelf image 1',
                ),
                readOnly: true,
                controller: shelf1Controller,

                onTap: () async {
                  selectFromCamera("shelf1");
                },

              ),
            ),

            Container(
              margin:EdgeInsets.fromLTRB(10,20,10,10),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFEFE4E4))
              ),
              child: TextFormField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.image,
                    color: Color(0xFF063A06),),
                  hintText:'Shelf image 2',
                ),
                readOnly: true,
                controller: shelf2Controller,

                onTap: () async {
                  selectFromCamera("shelf2");
                },

              ),
            ),

            Container(
              margin:EdgeInsets.fromLTRB(10,20,10,10),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFEFE4E4))
              ),
              child: TextFormField(
                controller: shelf3Controller,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.image,
                    color: Color(0xFF063A06),),
                  hintText:'Shelf image 3',
                ),
                onTap: (){
                  selectFromCamera("shelf3");
                },
              ),
            ),

            Container(
              margin:EdgeInsets.fromLTRB(10,20,10,10),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFEFE4E4))
              ),
              child: TextFormField(
                controller: shelf4Controller,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.image,
                    color: Color(0xFF063A06),),
                  hintText:'Shelf image 4',
                ),
                onTap: (){
                  selectFromCamera("shelf4");
                },
              ),
            ),

            GestureDetector(
              onTap: (){
                checkvalidtion();

              },

              child: Container(
                  margin: EdgeInsets.only(left:0,top:40,right:0,bottom: 0),
                  height: 55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF063A06),
                  ),

                  child: Row(
                    children: [

                      Expanded(flex:1,
                        child:Align(
                          alignment: Alignment.centerRight,
                          child:Text(
                            "CONTINUE  ",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),),

                      Expanded(
                          flex: 1,
                          child:Align(
                            alignment: Alignment.centerLeft,
                            child:Image.asset('assets/Images/right-arrow.png',height: 30,width: 20),
                          ))

                    ],
                  )
              ),

            )

          ],
        ),
      ),
    );
  }

  selectFromCamera(String s) async {

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

        if(s=="camera"){

          setState(() {
            this.cameraFile = cameraFile;
          });

        }else if(s=="shelf1"){

          setState(() {
            shelf1Controller.text = cameraFile!.name;
          });

        }else if(s=="shelf2"){

          setState(() {
            shelf2Controller.text = cameraFile!.name;
          });

        }else if(s=="shelf3"){

          setState(() {
            shelf3Controller.text = cameraFile!.name;
          });

        }else if(s=="shelf4"){
          setState(() {
            shelf4Controller.text = cameraFile!.name;
          });
        }



      }catch(e){

        print('Failed to pick image: $e');

      }

    }

  }

  // Future<GeoPoint?> getLocationDataFromImage(String filePath) async {
  //   GeoPoint? preciseLocation;
  //   final exif = await Exif.fromPath(filePath);
  //   final latLong = await exif.getLatLong();
  //   await exif.close();
  //   if (latLong != null) {
  //     preciseLocation = GeoPoint(latLong.latitude, latLong.longitude);
  //     return preciseLocation;
  //   }
  //   return null;
  // }

  Future<List> loadalldist() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;
    beatId = prefs.getInt(Common.BEAT_ID)!;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.get(Uri.parse('${Common.IP_URL}GetShopsData?id=$userid'), headers: headers);

    if(response.statusCode == 200){

      try{

        final list = jsonDecode(response.body);
        List<Shops> retailerdata = [];
        retailerdata = list.map<Shops>((m) => Shops.fromJson(Map<String, dynamic>.from(m))).toList();

        for(int i=0 ;i<retailerdata.length;i++){

          if(retailerdata[i].type == "Distributor"){

            distnamelist.add(retailerdata[i].retailerName.toString());
            distIdlist.add(retailerdata[i].retailerID.toString());

          }

        }

        // if(distnamelist.length== 0){
        //
        //   Fluttertoast.showToast(msg: "No distributor available in your beat!!",
        //       toastLength: Toast.LENGTH_SHORT,
        //       gravity: ToastGravity.BOTTOM,
        //       timeInSecForIosWeb: 1,
        //       backgroundColor: Colors.black,
        //       textColor: Colors.white,
        //       fontSize: 16.0);
        //
        //   Navigator.of(context).pop();
        //
        // }

      }catch(e){

        Navigator.pop(context);

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
    //  context.loaderOverlay.hide();
    return distnamelist;

  }

  void checkvalidtion() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    persontype = prefs.getString(Common.PERSON_TYPE);

    if(distributordropdown==null){

      Fluttertoast.showToast(msg: "Please select distributor",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }else if(statusdropdown==null){

      Fluttertoast.showToast(msg: "Please select status",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }else if(cameraFile==null){

      Fluttertoast.showToast(msg: "Please select image",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }else if(statusdropdown=="DONE"){

      Navigator.push(
        context,
        PageTransition(
            type: PageTransitionType.bottomToTop,
            child: SalesItemScreen(retailerName : widget.retailerName,retailerId:widget.retailerId,dist:distributordropdown,distId:distid,address:widget.address,date:dateController.text,status:statusdropdown.toString(),retlat:widget.latitude,retlon:widget.longitude),
            inheritTheme: true,
            ctx: context),
      );

    }else {

      Fluttertoast.showToast(msg: "$statusdropdown",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    }

    // else if(shelf4Controller.text=="" || shelf1Controller.text=="" ||  shelf2Controller.text=="" ||  shelf3Controller.text=="" && persontype=="MT"){
    //
    //   Fluttertoast.showToast(msg: "Please select alteast 1 shelf image",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: Colors.black,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    //
    // }

  }

  void getdistId(String dist){

    for(int i=0;i<distnamelist.length;i++){

        if(distnamelist.indexOf(dist)==distIdlist[i]){

          setState(() {
            distid = distIdlist[i];
          });

        }

    }

  }


}
