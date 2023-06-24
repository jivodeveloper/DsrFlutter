import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../config/Common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Item.dart';
import '../models/Shops.dart';
import 'package:location/location.dart';
import '../util/Helper.dart';
import 'dart:io';
import 'package:flutter/rendering.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as path;
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
  List itemlist = [];
  String? selectedValue;
  var layout = false ,dropdown =false;
  late Future<List> futureitem;
  late Future<List> furturedist;
  Location location = new Location();
  LocationData? _currentPosition;
  int _batteryLevel = 0,distid =0;
  var perstatus;
  File? cameraFile,f;
  TextEditingController remarks = TextEditingController();
  String? cdate;
  List dynamicList = [];
  List<String> distname = [],boxes = [];

  @override
  void initState() {
    super.initState();

    furturedist = getdistributor();
    // futureitem = getdistributoritem();
    addwidget();
    cdate = getcurrentdate();
    getBatteryLevel();
    fetchLocation();

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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
       appBar: AppBar(
          title: const Text("Distributor Stock",
              style: TextStyle(color:Color(0xFF063A06),fontFamily: 'OpenSans',fontWeight: FontWeight.w300)
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color:Color(0xFF063A06)),
        ),
        body:Container(
          margin: const EdgeInsets.only(left:10,top: 20,right: 10,bottom: 0),
          child: Column(
            children: [

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
                            value: selectedValue,
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
                              getdistid(newVal.toString());
                            }
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Container();
                  }
                 return Container();
                }
              ),

              SizedBox(
                height:200,
                child: ListView.builder(
                itemCount: dynamicList.length,
                  itemBuilder: (_, index) =>
                     dynamicList[index],
                ),
              ),

              TextFormField(
                decoration: const InputDecoration(
                  hintText:'remarks',
                ),
                controller: remarks,
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

              Align(
                alignment: FractionalOffset.bottomCenter,
                child: GestureDetector(

                  onTap: (){
                    submitdiststock();
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
        )
      ),
    );

  }

  void addwidget(){

    setState(() {
      dynamicList.add(dynamicWidget());
    });

  }

  selectFromCamera(String s) async {

    if (perstatus == PermissionStatus.denied) {

      Fluttertoast.showToast(msg: "Please allow camera permission!",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

    } else {

      try {

        final cameraFile = await ImagePicker().pickImage(source: ImageSource.camera);
        File? selectedImage;
        setState(() {
         selectedImage = File(cameraFile!.path); // won't have any error now
        });

        final now = new DateTime.now();
        String dir = path.dirname(selectedImage!.path);
        String newPath = path.join(dir,
            ("$userid-${now.day}-${now.month}-${now.year}-${now
                .timeZoneName}.jpg"));
        f = await File(selectedImage!.path).copy(newPath);

        setState(() {
          this.cameraFile = File(cameraFile!.path);
        });
      } catch (e) {
        print('Failed to pick image: $e');
      }
    }
  }

  void getdistid(String newval){
    for(int i=0;i<distnamelist.length;i++){
      if(distnamelist.indexOf(newval.toString())==i){
        distid=distIdlist[i];

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

  // Future<List> getdistributoritem() async {
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   userid = prefs.getInt(Common.USER_ID)!;
  //
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //   };
  //
  //   var response = await http.get(Uri.parse('${Common.IP_URL}GetShopsItemData?id=$userid'), headers: headers);
  //
  //   if(response.statusCode == 200){
  //
  //     try{
  //
  //       final list = jsonDecode(response.body);
  //       List<Item> itemdata = [];
  //       itemdata = list.map<Item>((m) => Item.fromJson(Map<String, dynamic>.from(m))).toList();
  //
  //       for(int i=0 ;i<itemdata.length;i++){
  //           itemlist.add(itemdata[i].itemName.toString());
  //           addwidget();
  //       }
  //
  //       layout = true;
  //
  //     }catch(e){
  //
  //       Fluttertoast.showToast(msg: "$e",
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
  //   }
  //
  //   return itemlist;
  //
  // }

  // Future<List> submitdiststock() async {
  //
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   userid = prefs.getInt(Common.USER_ID)!;
  //
  //   Map<String, String> headers = {
  //     'Content-Type': 'application/json',
  //   };
  //
  //   var response = await http.get(Uri.parse(Common.IP_URL+'GetShopsItemData?id=$userid'), headers: headers);
  //
  //   if(response.statusCode == 200){
  //
  //     try{
  //
  //       final list = jsonDecode(response.body);
  //       List<Item> itemdata = [];
  //       itemdata = list.map<Item>((m) => Item.fromJson(Map<String, dynamic>.from(m))).toList();
  //
  //       for(int i=0 ;i<itemdata.length;i++){
  //         itemlist.add(itemdata[i].itemName.toString());
  //       }
  //
  //       layout = true;
  //       Fluttertoast.showToast(msg: "${itemlist.length}",
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.BOTTOM,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.black,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //
  //     }catch(e){
  //
  //       Navigator.pop(context);
  //
  //       Fluttertoast.showToast(msg: "$e",
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
  //   }
  //
  //   return itemlist;
  //
  // }

  void submitdiststock() async{

   // dynamicList.forEach((widget) => boxes.add(widget.boxescontroller.text));

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
      "items":[
        {
          "itemId":"4",
          "totalPieces":"6"
        }
      ]
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

}

  getbatterylevel(){

    int level = getBatteryLevel();
    setState((){
      _batteryLevel=level;
    });

  }

}

class dynamicWidget extends StatelessWidget {

  TextEditingController boxescontroller = TextEditingController();
  List catenamlist = [], cateidlist = [],itemlist = [], itemid = [];
  int userid=0;
  late Future<List> furturedist;
  bool isLoading =false;

  @override
  Widget build(BuildContext context) {
    furturedist = getdistributoritem();

    return SizedBox(
      height: 500,
      child:isLoading?Center(
          child:CircularProgressIndicator()
      ): FutureBuilder<List>(
          future: furturedist,
          builder: (context, snapshot){
            if (snapshot.hasData) {
              return Expanded(
                  child:ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context,index){
                        return Container(
                          padding: const EdgeInsets.all(5),
                          child: Row(
                            children: [

                              Expanded(
                                  flex :6,
                                  child: Text('${snapshot.data![index]}')
                              ),

                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  controller: boxescontroller,
                                  decoration: InputDecoration(
                                      hintText:'Boxes'
                                  ),
                                ),
                              ),

                            ],
                          ),
                        );
                      }
                  )
              );
            }else{

            }
            return Container();
          }
      )
    );
  }

  Future<List> getdistributoritem() async {

    isLoading=true;

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
        }

      }catch(e){

        //  Navigator.pop(context);

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


}
