import 'dart:io';
import 'package:flutter/rendering.dart';
import 'package:path/path.dart' as path;
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
import 'package:location/location.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import '../util/Helper.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

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

  Stopwatch _stopwatch = Stopwatch();
  late Timer _timer;
  String _elapsedTime = "00:00";
  Location location = new Location();
  var perstatus;
  int _batteryLevel = 0,userid=0,beatId=0,distanceallowed =0 ;
  double distance=0.0,distanceInMeters=0.0;

  List<String> status = [
    "DONE",
    "SHOP CLOSED",
    "OWNER NOT AVAILABLE",
    "ALREADY STOCKED",
    "NOT INTERESTED",
    "TELEPHONIC"
  ], distnamelist = [],distIdlist = [];

  LocationData? _currentPosition;
  File? cameraFile,shelffile1,shelffile2,shelffile3,shelffile4,f;
  String? statusdropdown ,distributordropdown,distid,isdistanceallowed,persontype,cdate;
  late Future<List> furturedist;

  TextEditingController dateController = TextEditingController();
  TextEditingController shelf1Controller = TextEditingController();
  TextEditingController shelf2Controller = TextEditingController();
  TextEditingController shelf3Controller = TextEditingController();
  TextEditingController shelf4Controller = TextEditingController();

  String formatter = "";
  final GlobalKey globalKey = new GlobalKey();
  bool quantity_layout = false,isturnedon = false;
  final picker = ImagePicker();
  final StopWatchTimer _stopWatchTimer = StopWatchTimer();
  String? type;

  @override
  void initState() {
    super.initState();

    if(widget.retailerId==""){
      type="newShop";
    }else{
      type="old";
    }
    setcurrenttime();
    getbatterylevel();
    furturedist = loadalldist();
    fetchLocation();
    _startStopwatch();
  }

  void dispose() async {
    super.dispose();
    await _stopWatchTimer.dispose();  // Need to call dispose function.
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final nextFifteenDays = List<DateTime>.generate(15, (index) {
      return now.add(Duration(days: index + 1));
    });
    return Scaffold(
        backgroundColor: const Color(0xFFFAFAFA),
        appBar: AppBar(
          title: const Text("Sales Screen",
              style: TextStyle(color:Color(0xFF063A06),fontWeight: FontWeight.w400)
          ),
          actions: [
            Center(
              child: Text("$_elapsedTime",style: TextStyle(color:Color(0xFF063A06),fontSize: 19)),
            )
          ],
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color:Color(0xFF063A06)),
        ),
        body: ProgressHUD(
            child:Builder(
              builder: (ctx) => SingleChildScrollView(
                child: Column(
                  children: [

                    Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            border: Border.all(color: Color(0xFFC2FAC0))
                        ),
                        width: double.infinity,
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
                                    child:GestureDetector(
                                      onTap: (){

                                      },
                                      child: Container(
                                        child: Align(
                                          alignment:Alignment.center,
                                          child: Icon(Icons.location_pin,size: 36,color: Colors.red,),
                                        ),
                                      ),
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
                              firstDate: DateTime.now().subtract(const Duration(days: 7)),
                              lastDate: DateTime.now());
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
                        checkvalidtion(ctx);
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
          )
        )
     );
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

  void _startStopwatch() {

    _stopwatch.start();

    _timer = Timer.periodic(Duration(milliseconds: 1), (timer) {
      setState(() {
        _elapsedTime = _stopwatch.elapsed.toString().substring(0, 8);
      });
    });
  }

  selectFromCamera(String s) async {

    if(perstatus== PermissionStatus.denied){

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
        File? selectedImage;
        setState(() {
          selectedImage = File(cameraFile!.path); // won't have any error now
        });

        final now = new DateTime.now();
        String dir = path.dirname(selectedImage!.path);
        String newPath = path.join(dir,("$userid-${now.day}-${now.month}-${now.year}-${now.timeZoneName}.jpg"));
        f = await File(selectedImage!.path).copy(newPath);

        if(s=="camera"){

          setState(() {
            this.cameraFile = File(cameraFile!.path);
          });

        }else if(s=="shelf1"){

          setState(() {
            shelf1Controller.text = cameraFile!.path.toString();
          });

        }else if(s=="shelf2"){

          setState(() {
            shelf2Controller.text = cameraFile!.path.toString();
          });

        }else if(s=="shelf3"){

          setState(() {
            shelf3Controller.text = cameraFile!.path.toString();
          });

        }else if(s=="shelf4"){
          setState(() {
            shelf4Controller.text = cameraFile!.path.toString();
          });
        }

      }catch(e){

        print('Failed to pick image: $e');

      }

    }

  }

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

  void checkvalidtion(context) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    persontype = prefs.getString(Common.PERSON_TYPE);
    cdate = getcurrentdatewithtime();
    distance = checkdistancecondition(widget.latitude,widget.longitude);
    distanceallowed = 500;
   // print("distanceallowed${prefs.getInt(Common.DISTANCE_ALLOWED)}");

    if(distributordropdown==null && type=="old"){

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

      if(distance > distanceallowed){

        isdistanceallowed = "0";
        showdistanceallowedmessage(context);

      }else{

        isdistanceallowed = "1";

        Navigator.push(
            context, PageTransition(
            type: PageTransitionType.bottomToTop,
            child: SalesItemScreen(retailerName : widget.retailerName,retailerId:widget.retailerId,dist:distributordropdown,distId:distid,address:widget.address,date:dateController.text,status:statusdropdown.toString(),retlat:widget.latitude,retlon:widget.longitude,distance:distance,isdistanceallowed:isdistanceallowed,deliveryDate: dateController.text, elapsedTime: _elapsedTime,cameraFile:f),
            inheritTheme: true,
            ctx: context));

        // if(type=="old")
        // {
        //   saveSales(context);
        // }else{
        //   savenewretailerwithsales(context);
        // }

      }
      //
      // Navigator.push(
      //     context, PageTransition(
      //         type: PageTransitionType.bottomToTop,
      //         child: SalesItemScreen(retailerName : widget.retailerName,retailerId:widget.retailerId,dist:distributordropdown,distId:distid,address:widget.address,date:dateController.text,status:statusdropdown.toString(),retlat:widget.latitude,retlon:widget.longitude,distance:distance,isdistanceallowed:isdistanceallowed,deliveryDate: dateController.text, elapsedTime: _elapsedTime,cameraFile:cameraFile!.path),
      //         inheritTheme: true,
      //         ctx: context));

    }else if(statusdropdown!=null && statusdropdown!="DONE"){
      submitsales(context);
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

      if(distnamelist.indexOf(dist)==i){

        setState(() {
          distid = distIdlist[i];
        });

      }

    }

  }

  Future<void> submitsales(context) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = 768;

    if(distance > distanceallowed){

      isdistanceallowed = "0";
      showdistanceallowedmessage(context);

    }else{

      isdistanceallowed = "1";
      if(type=="old")
      {
        saveSales(context);
      }else{
        savenewretailerwithsales(context);
      }

    }


  }

  double checkdistancecondition(double? latitude,double? longitude) {

    double distanceInMeters=0.0;

    distanceInMeters = Geolocator.distanceBetween(_currentPosition!.latitude!.toDouble(),_currentPosition!.longitude!.toDouble(),latitude! , longitude!);

    return distanceInMeters;
  }

  Future<void> showdistanceallowedmessage(context){
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
                onPressed: () =>{

                  Navigator.pop(context, 'Ok'),
                  // if(type=="old"){
                  //  saveSales(context),
                  // }else{
                  //  savenewretailerwithsales(context),
                  // }
                  //

                  Navigator.push(
                      context, PageTransition(
                      type: PageTransitionType.bottomToTop,
                      child: SalesItemScreen(retailerName : widget.retailerName,retailerId:widget.retailerId,dist:distributordropdown,distId:distid,address:widget.address,date:dateController.text,status:statusdropdown.toString(),retlat:widget.latitude,retlon:widget.longitude,distance:distance,isdistanceallowed:isdistanceallowed,deliveryDate: dateController.text, elapsedTime: _elapsedTime,cameraFile:f),
                      inheritTheme: true,
                      ctx: context))

                },
                child: const Text('Ok'),
              ),

            ],

          );
        }
    );
  }

  Future<void> saveSales(context) async {

    var salesentry=[{},{
      "personId":"$userid",
      "shopId":widget.retailerId,
      "saleDateTime":cdate,
      "status":statusdropdown,
      "latitude":_currentPosition?.latitude,
      "longitude":_currentPosition?.latitude,
      "battery":_batteryLevel,
      "GpsEnabled":isturnedon,
      "accuracy":_currentPosition?.accuracy,
      "speed":_currentPosition?.speed,
      "provider":_currentPosition?.provider,
      "altitude":_currentPosition?.altitude,
      "shopType":type,
      "salesType":"secondary",
      "timeDuration":_elapsedTime,
      "startLatitude":widget.latitude,
      "startLongitude":widget.longitude,
      "distId":widget.retailerId,
      "distance":distanceInMeters,
      "deliveryDate":dateController.text,
      "allowed":isdistanceallowed,
      "items":[]}];

    var body = json.encode(salesentry);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var request = await http.MultipartRequest('POST', Uri.parse('${Common.IP_URL}SaveSalesWithImgAndGetId2'));
    request.fields['salesEntry']= body.toString();
    request.files.add(await http.MultipartFile.fromPath('image', f!.path));

    var response = await request.send();
    var responsed = await http.Response.fromStream(response);
    final responsedData = json.decode(responsed.body);

    if(responsedData.contains("DONE")){

      ProgressHUD.of(context)?.dismiss();

      Fluttertoast.showToast(msg: "Sales Saved",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.of(context).pop();

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

  setcurrenttime(){

    final now = new DateTime.now();
    formatter = DateFormat('yMd').format(now);// 28/03/2020

    if(formatter!=""){
      dateController.text = formatter;
    }

  }

  Future<void> getbatterylevel() async {

    Battery _battery = Battery();
    final level = await _battery.batteryLevel;

    //  int level = getBatteryLevel();
    setState((){
      _batteryLevel=level;
    });

  }

  void savenewretailerwithsales(context) async{

    ProgressHUD.of(context)?.show();

    SharedPreferences prefs= await SharedPreferences.getInstance();
    int userid = 768;

    var salesentry=[{},{
      "personId":"$userid",
      "shopName":widget.retailerName,
      "address":widget.address,
      "state":prefs.getString(Common.STATE),
      "zone":prefs.getString(Common.ZONE),
      "area":prefs.getString(Common.AREA),
      "pincode":prefs.getString(Common.PINCODE),
      "contactPerson":prefs.getString(Common.CONTACT_PERSON),
      "contactNo":"",
      "mobileNo":prefs.getString(Common.MOBILE_NUMBER),
      "shopType":type,
      "category":prefs.getString(Common.CATEGORY),
      "imagePath":"",
      "creationDate":cdate.toString(),
      "latitude":"${_currentPosition?.latitude}",
      "longitude":"${_currentPosition?.longitude}",
      "shopgroup":prefs.getString(Common.SHOPGROUP),
      "saleDateTime":cdate.toString(),
      "status":statusdropdown,
      "battery":_batteryLevel,
      "GpsEnabled":isturnedon,
      "accuracy":_currentPosition?.accuracy,
      "speed":_currentPosition?.speed,
      "provider":_currentPosition?.provider,
      "altitude":_currentPosition?.altitude,
      "distId":distid,
      "distName":distributordropdown,
      "timeDuration":_elapsedTime,
      "items":[]
    }];

    var body = json.encode(salesentry);

    print("${body.toString()}");


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

      ProgressHUD.of(context)?.dismiss();

      Fluttertoast.showToast(msg: "Sales Saved",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

      Navigator.of(context).pop();

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