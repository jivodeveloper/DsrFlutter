import 'dart:io';
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

class SalesScreen extends StatefulWidget{

  String retailerName="",retailerId="",address="";
  SalesScreen({required this.retailerName,required this.retailerId, required this.address});
  int count =0;

  @override
  State<StatefulWidget> createState() {
    return SalesScreenState();
  }

}

class SalesScreenState extends State<SalesScreen>{

  var perstatus;
  int userid=0;
  List<String> status = ["Select Status",
    "Done",
    "Shop Closed",
    "Owner not available",
    "Already stocked",
    "Not interested",
  ];

  List<String> distnamelist = [];
  XFile? cameraFile;
  String statusdropdown= "Select Status",distributordropdown= "Select Distributor";
  late Future<List> furturedist;
  final dateController = TextEditingController();

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
                padding: EdgeInsets.all(10),
                child: Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.green[100],
                  child: Center(
                      child: Text("${widget.retailerName}"),
                  ),
                ),
              ),

              // Container(
              //   margin:EdgeInsets.fromLTRB(10,20,10,10),
              //   decoration: BoxDecoration(
              //       border: Border.all(color: Color(0xFFEFE4E4))
              //   ),
              //   child:FutureBuilder<List>(
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
              //                       child: Text(e.toString()),
              //                     )
              //                 ).toList(),
              //
              //                 onChanged:(newVal) {
              //                   // this.setState(() {
              //                   //   distributordropdown = newVal.toString();
              //                   // });
              //                 }
              //             ),
              //           );
              //         } else if (snapshot.hasError) {
              //           return Container();
              //         }
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

                  items: status.map<DropdownMenuItem<String>>((String value) {
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
                margin:EdgeInsets.fromLTRB(10,20,10,10),
                decoration: BoxDecoration(
                    border: Border.all(color: Color(0xFFEFE4E4))
                ),
                child: TextFormField(
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.image,
                      color: Color(0xFF063A06),),
                    hintText:'Shelf image 3',
                  ),

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
                    hintText:'Shelf image 4',
                  ),
                ),
              ),

              GestureDetector(
                onTap: (){
                  Navigator.push(
                    context,
                    PageTransition(
                        type: PageTransitionType.bottomToTop,
                        child: SalesItemScreen(retailerName : widget.retailerName,retailerId:widget.retailerId,address:widget.address,date:dateController.text),
                        inheritTheme: true,
                        ctx: context),
                  );

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

  Future<List> loadalldist() async {


    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.get(Uri.parse(Common.IP_URL+'GetShopsData?id=$userid'), headers: headers);

    if(response.statusCode == 200){

      try{

        final list = jsonDecode(response.body);
        List<Shops> retailerdata = [];
        retailerdata = list.map<Shops>((m) => Shops.fromJson(Map<String, dynamic>.from(m))).toList();

        for(int i=0 ;i<retailerdata.length;i++){
          if(retailerdata[i].type == "Distributor"){
            distnamelist.add(retailerdata[i].retailerName.toString());
          //  distIdlist.add(retailerdata[i].retailerID!.toInt());
          }
        }

        Fluttertoast.showToast(msg: "${distnamelist.length}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);

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
    return distnamelist;
  }

}
