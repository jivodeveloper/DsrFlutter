import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:promoterapp/util/DistributorProvider.dart';
import '../config/Common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Distributoritem.dart';
import '../models/Item.dart';
import '../models/Shops.dart';
import 'package:provider/provider.dart';
import 'package:location/location.dart';
import '../util/Helper.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';

class DistributorStock extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return DistributorStockState();
  }

}

class DistributorStockState extends State<DistributorStock>{

  List<String> shoptype = ["Select shoptype","Grocery","Bakery","Chemist","General Store","Modern Store","Rural","Distributor"];
  int userid=0;
  List<String> distnamelist = [];
  List distIdlist = [];
  List itemlist = [],itemidlist=[];
  List<int> itemid = [], boxes=[];
  String? selectedValue ;
  var layout = false ,dropdown =false;
  late Future<List> futureitem;
  late Future<List> furturedist;
  TextEditingController boxescontroller =new TextEditingController();
  int _batteryLevel = 0,distid =0;
  LocationData? _currentPosition;
  String? cdate;
  TextEditingController remarks = TextEditingController();
  File? cameraFile,f;
  var perstatus;

  @override
  void initState() {
    super.initState();

    furturedist = getdistributor();
    futureitem = getdistributoritem();

  }

  void backbutton(DistributorProvider dropdownOptionsProvider){
    dropdownOptionsProvider.remove();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final dropdownOptionsProvider = Provider.of<DistributorProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
            onPressed:() => backbutton(dropdownOptionsProvider)
        ),
        title: const Text("Distributor Stock",
            style: TextStyle(color:Color(0xFF063A06),fontFamily: 'OpenSans',fontWeight: FontWeight.w300)
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color:Color(0xFF063A06)),
      ),
      body:Container(
        margin: EdgeInsets.only(left:10,top: 20,right: 10,bottom: 0),
        child: Column(
          children: [

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

                          ]
                      )
                  )

              ),
            ),

            FutureBuilder<List>(
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
                          underline:Container(),
                          value:selectedValue,
                          hint: const Text("Select Distributor",style: TextStyle(fontFamily: 'OpenSans',fontWeight: FontWeight.w100),),
                          isExpanded: true,
                          items: snapshot.data?.map((e) =>
                              DropdownMenuItem<String>(
                                value: e,
                                child: Text(e),
                              )
                          ).toList(),

                          onChanged:(newVal) {
                            this.setState(() {
                              selectedValue = newVal.toString();
                            });
                          }
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Container();
                  }
                  return const CircularProgressIndicator();
                }
            ),

            FutureBuilder<List>(
                future: futureitem,
                builder: (context, snapshot){
                  if (snapshot.hasData) {
                    return Expanded(
                        child: layout?ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context,index){
                              return Container(
                                padding: EdgeInsets.all(5),
                                child: Row(
                                  children: [

                                    Expanded(
                                        flex :6,
                                        child: Text('${snapshot.data![index]}')
                                    ),

                                    Expanded(
                                      flex: 1,
                                      child: TextFormField(

                                        decoration: InputDecoration(
                                            hintText:'Boxes'
                                        ),
                                        onChanged: (value) {
                                          // storevalue(index,int.parse(value));
                                          dropdownOptionsProvider.setSelectedItemValue(index, int.parse(value),int.parse(itemidlist[index]));
                                        },
                                      ),
                                    ),

                                  ],
                                ),
                              );
                            }
                        ):Container()
                    );
                  }else{

                  }
                  return const CircularProgressIndicator();
                }
            ),

            Align(
              alignment: FractionalOffset.bottomCenter,
              child: GestureDetector(

                onTap: (){
                  submitdiststock(dropdownOptionsProvider.itemidlist,dropdownOptionsProvider.boxeslist);
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

          ],
        ),
      ),
    );

  }

  selectFromCamera(String s) async {

    if(perstatus == PermissionStatus.denied){

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
            this.cameraFile = File(cameraFile!.path);
          });

        }

      }catch(e){

        print('Failed to pick image: $e');

      }

    }

  }

  Future<List> getdistributor() async {

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
            distIdlist.add(retailerdata[i].retailerID!.toInt());
          }

        }

        // distnamelist.sort((a, b) => a["price"].compareTo(b["price"]));
        //
        // Fluttertoast.showToast(msg: "${distnamelist.length}",
        //
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.black,
        //     textColor: Colors.white,
        //     fontSize: 16.0);

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

  Future<List> getdistributoritem() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.get(Uri.parse('${Common.IP_URL}GetShopsItemData?id=$userid'), headers: headers);

    if(response.statusCode == 200){

      try{

        final list = jsonDecode(response.body);
        List<Item> itemdata = [];
        itemdata = list.map<Item>((m) => Item.fromJson(Map<String, dynamic>.from(m))).toList();

        for(int i=0 ;i<itemdata.length;i++){
          itemlist.add(itemdata[i].itemName.toString());
          itemidlist.add(itemdata[i].itemID.toString());
        }

        layout = true;

      }catch(e){

        Navigator.pop(context);

        Fluttertoast.showToast(msg: "$e",
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

    return itemlist;

  }

  void storevalue(int index,int value){
    if(itemid.isNotEmpty){

      for(int i=0;i<itemid.length;i++){
        if(itemidlist[index]==itemid[i]){


          itemid[index]=int.parse(itemidlist[index]);
          boxes[index]=value;

        }else{
          print("does not exist ${itemidlist[index]} $value");
          print("${itemidlist[index]} $value");
          itemid.add(int.parse(itemidlist[index]));
          boxes.add(value);
        }

      }
    }else{
      print("no exist");
      itemid.add(int.parse(itemidlist[index]));
      boxes.add(value);
    }
    print("does not exist ${itemidlist[index]} $value");

    // itemid.insert(index,int.parse(itemidlist[index]));
    // boxes.insert(index,value);

    // if(itemid[index].toString().isEmpty){
    //   print("inside");
    //   itemid.add(itemidlist[index]);
    //   boxes.add(value);
    //
    // }else{
    //   print("outside index");
    //   itemid.insert(index, itemidlist[index]);
    //   boxes.insert(index,value);
    //
    // }

  }

  Future<void> submitdiststock(List<int> itemidlist,List<int> boxesidlist) async {

    List<Distributoritem> items = [];

    for(int i=0;i<itemidlist.length;i++){

      items.add(Distributoritem(itemidlist[i],boxesidlist[i]));

    }

    var salesentry=[{},{
      "distId":distid,
      "salesPersonId":userid,
      "latitude":_currentPosition?.latitude,
      "longitude":_currentPosition?.longitude,
      "battery":_batteryLevel,
      "GpsEnabled":isturnedon,
      "accuracy":_currentPosition?.accuracy,
      "speed":_currentPosition?.speed,
      "provider":_currentPosition?.provider,
      "entryType":"stock",
      "stockDate":cdate,
      "remarks":remarks.text,
      "items":items
    }];

    var body = json.encode(salesentry);

    print("body$body");

    Map<String, String> headers = {
      'Content-Type': 'application/json'};

    var request = await http.MultipartRequest(
        'POST', Uri.parse('${Common.IP_URL}CreateDistributorStock'));
    request.fields['stockEntry'] = body.toString();
    request.files.add(await http.MultipartFile.fromPath('image', f!.path));

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
      Fluttertoast.showToast(msg: "Not Saved",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }


    // try{
    //   print("boxes");
    //
    //   for(int i=0;i<itemid.length;i++){
    //     print("itemid${itemid[i]}");
    //     print("boxes${boxes[i]}");
    //   }
    //
    //   itemid.clear();
    //   boxes.clear();
    //
    // }catch(e){
    //   print("boxes$e");
    // }


    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // userid = prefs.getInt(Common.USER_ID)!;
    //
    // Map<String, String> headers = {
    //   'Content-Type': 'application/json',
    // };
    //
    // var response = await http.get(Uri.parse(Common.IP_URL+'GetShopsItemData?id=$userid'), headers: headers);
    //
    // if(response.statusCode == 200){
    //
    //   try{
    //
    //     final list = jsonDecode(response.body);
    //     List<Item> itemdata = [];
    //     itemdata = list.map<Item>((m) => Item.fromJson(Map<String, dynamic>.from(m))).toList();
    //
    //     for(int i=0 ;i<itemdata.length;i++){
    //       itemlist.add(itemdata[i].itemName.toString());
    //     }
    //
    //     layout = true;
    //     Fluttertoast.showToast(msg: "${itemlist.length}",
    //         toastLength: Toast.LENGTH_SHORT,
    //         gravity: ToastGravity.BOTTOM,
    //         timeInSecForIosWeb: 1,
    //         backgroundColor: Colors.black,
    //         textColor: Colors.white,
    //         fontSize: 16.0);
    //
    //   }catch(e){
    //
    //     Navigator.pop(context);
    //
    //     Fluttertoast.showToast(msg: "$e",
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
    // }
    //
    // return itemlist;

  }

  void submit() async{

    // dynamicList.forEach((widget) => boxes.add(widget.boxescontroller.text));



    // var salesentry=[{},{
    //   "distId":distid,
    //   "salesPersonId":userid,
    //   "latitude":_currentPosition?.latitude,
    //   "longitude":_currentPosition?.longitude,
    //   "battery":_batteryLevel,
    //   "GpsEnabled":isturnedon,
    //   "accuracy":_currentPosition?.accuracy,
    //   "speed":_currentPosition?.speed,
    //   "provider":_currentPosition?.provider,
    //   "entryType":"stock",
    //   "stockDate":cdate,
    //   "remarks":remarks.text,
    //   "items":[
    //     {
    //       "itemId":"4",
    //       "totalPieces":"6"
    //     }
    //   ]
    // }];

    // var body = json.encode(salesentry);
    //
    // print("body$body");
    //
    // Map<String, String> headers = {
    //   'Content-Type': 'application/json'};
    //
    // var request = await http.MultipartRequest(
    //     'POST', Uri.parse('${Common.IP_URL}CreateDistributorStock'));
    // request.fields['stockEntry'] = body.toString();
    // request.files.add(await http.MultipartFile.fromPath('image', f!.path));
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
    //   Fluttertoast.showToast(msg: "Not Saved",
    //       toastLength: Toast.LENGTH_SHORT,
    //       gravity: ToastGravity.BOTTOM,
    //       timeInSecForIosWeb: 1,
    //       backgroundColor: Colors.black,
    //       textColor: Colors.white,
    //       fontSize: 16.0);
    // }

  }

  getbatterylevel(){

    int level = getBatteryLevel();
    setState((){
      _batteryLevel=level;
    });

  }


}