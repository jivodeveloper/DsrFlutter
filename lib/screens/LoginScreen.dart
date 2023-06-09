import 'dart:async';
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promoterapp/models/logindetails.dart';
import 'package:promoterapp/screens/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config/Common.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../location_service/logic/location_controller/location_controller_cubit.dart';
import '../notification/notification.dart';
import '../util/background_service.dart';
import '../util/shared_preference.dart';
import 'package:geolocator/geolocator.dart';

class LoginScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return LoginScreenState();
  }

}

class LoginScreenState extends State<LoginScreen>{

  TextEditingController usercontroller = new TextEditingController();
  TextEditingController passcontroller = new TextEditingController();
  bool _obscureText = true;
  late BackgroundService backgroundService;

  @override
  void initState() {
    super.initState();
    // backgroundService = BackgroundService();
    askpermission();
  }

  //
  // @pragma('vm:entry-point')
  // @override
  // Future<void> didChangeDependencies() async {
  //   await context.read<NotificationService>().initialize(context);
  //
  //   //Start the service automatically if it was activated before closing the application
  //   if (await backgroundService.instance.isRunning()) {
  //     await backgroundService.initializeService();
  //   }
  //   backgroundService.instance.on('on_location_changed').listen((event) async {
  //     if (event != null) {
  //       final position = Position(
  //         longitude: double.tryParse(event['longitude'].toString()) ?? 0.0,
  //         latitude: double.tryParse(event['latitude'].toString()) ?? 0.0,
  //         timestamp: DateTime.fromMillisecondsSinceEpoch(
  //             event['timestamp'].toInt(),
  //             isUtc: true),
  //         accuracy: double.tryParse(event['accuracy'].toString()) ?? 0.0,
  //         altitude: double.tryParse(event['altitude'].toString()) ?? 0.0,
  //         heading: double.tryParse(event['heading'].toString()) ?? 0.0,
  //         speed: double.tryParse(event['speed'].toString()) ?? 0.0,
  //         speedAccuracy:
  //         double.tryParse(event['speed_accuracy'].toString()) ?? 0.0,
  //       );
  //
  //       await context
  //           .read<LocationControllerCubit>()
  //           .onLocationChanged(location: position);
  //     }
  //   });
  //
  //   super.didChangeDependencies();
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child:Scaffold(
          body: ProgressHUD(
              child:Builder(
                builder: (ctx) => Scaffold(
                    body:Container(
                      color: Colors.white,
                      child:Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Container(
                            margin: EdgeInsets.only(bottom: 0),
                            child: Align(
                                alignment: Alignment.centerLeft,
                                child: Image.asset(
                                    'assets/Images/logo.png', height: 150)
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Column(
                              children: [

                                Container(
                                  margin: EdgeInsets.only(bottom: 10),
                                  child:Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        "Proceed with your", style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF063A06),
                                        fontSize: 20,
                                      ),
                                      )
                                  ),
                                ),

                                Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      "LOGIN", style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF063A06),
                                      fontSize: 30,
                                    ),
                                    )
                                )

                              ],
                            ),

                          ),

                          Form(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  Container(
                                    margin:EdgeInsets.fromLTRB(10,20,10,10),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Color(0xFFEFE4E4))
                                    ),
                                    child: TextFormField(
                                      controller: usercontroller,
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(Icons.lock,
                                            color: Color(0xFF063A06),),
                                          hintText:'username'
                                      ),
                                    ),
                                  ),

                                  Container(

                                    margin:EdgeInsets.fromLTRB(10,10,10,10),
                                    decoration: BoxDecoration(
                                        border: Border.all(color: Color(0xFFEFE4E4))
                                    ),
                                    child: TextFormField(
                                      controller: passcontroller,
                                      obscureText:_obscureText,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(Icons.password,
                                          color: Color(0xFF063A06),),
                                        hintText: 'password',
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _obscureText = !_obscureText;
                                            });
                                          },
                                          child: Icon(
                                            _obscureText ? Icons.visibility : Icons.visibility_off,
                                            semanticLabel:
                                            _obscureText ? 'show password' : 'hide password',
                                            color:Color(0xFF063A06),
                                          ),
                                        ),
                                      ),

                                    ),
                                  )

                                ],
                              )
                          ),

                          // BlocBuilder<LocationControllerCubit, LocationControllerState>(
                          //   builder: (context, state) {
                          //
                          //       return GestureDetector(
                          //
                          //         onTap: () async {
                          //           // Workmanager().registerPeriodicTask('uniqueName', 'taskName',
                          //           //     frequency: Duration(seconds: 10));
                          //
                          //           // Timer timer;
                          //           // const duration = Duration(seconds: 10);
                          //           // timer = Timer.periodic(duration, (Timer t) {
                          //           //   fetchLocation();
                          //           // });
                          //
                          //
                          //           FocusScope.of(context).unfocus();
                          //           await Fluttertoast.showToast(
                          //             msg: "Wait for a while, Initializing the service...",
                          //           );
                          //           final permission = await context.read<LocationControllerCubit>()
                          //               .enableGPSWithPermission();
                          //
                          //           if (permission) {
                          //             await CustomSharedPreference().storeData(
                          //               key: SharedPreferenceKeys.userName,
                          //               data: usercontroller.text.trim(),
                          //             );
                          //
                          //             await context.read<LocationControllerCubit>()
                          //                 .locationFetchByDeviceGPS();
                          //             //Configure the service notification channel and start the service
                          //             await backgroundService.initializeService();
                          //             //Set service as foreground.(Notification will available till the service end)
                          //             backgroundService.setServiceAsForeGround();
                          //
                          //           }
                          //           login(ctx);
                          //           //
                          //           // progress?.dismiss();
                          //
                          //         },
                          //         child: Container(
                          //           margin: EdgeInsets.only(left:10,top:40,right:10,bottom: 10),
                          //           width: double.infinity,
                          //           height: 55,
                          //           decoration: BoxDecoration(
                          //               color: Color(0xFF063A06),
                          //               borderRadius: BorderRadius.all(Radius.circular(10.0))
                          //           ),
                          //
                          //           child: Center(
                          //             child: Text(
                          //               "LOGIN",
                          //               style: TextStyle(color: Colors.white),
                          //             ),
                          //           ),
                          //         ),
                          //
                          //       );
                          //     }
                          //
                          // ),

                          GestureDetector(
                          onTap: () async {

                            login(ctx);

                          },
                          child: Container(
                          margin: EdgeInsets.only(left:10,top:40,right:10,bottom: 10),
                          width: double.infinity,
                          height: 55,
                          decoration: BoxDecoration(
                            color: Color(0xFF063A06),
                            borderRadius: BorderRadius.all(Radius.circular(10.0))
                          ),

                          child: Center(
                            child: Text(
                            "LOGIN",
                             style: TextStyle(color: Colors.white),
                             ),
                            ),
                           ),

                          )

                        ],

                      ),
                    )
                ),
              )
           ),
         ),
        onWillPop: () async{
          return false;
        }
    );
  }

  void logout() async{
    return showDialog(
        context: context,
        builder:(BuildContext context) {
          return AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure?'),
            actions: <Widget>[

              TextButton(
                onPressed: () => Navigator.pop(context, 'Cancel'),
                child: const Text('No'),
              ),

              TextButton(
                onPressed: () async {
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  preferences.clear();

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              LoginScreen()));

                },
                child: const Text('Yes'),
              ),

            ],
          );
        }
    );
  }

  Future<logindetails> login(context) async {

    final progress  = ProgressHUD.of(context);
    progress?.show();

    logindetails details;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.post(Uri.parse(
        '${Common.IP_URL}LoginSalesPerson?user=${usercontroller.text}&password=${passcontroller.text}'),
        headers: headers);
    details = logindetails.fromJson(json.decode(response.body));

    try {

      if (response.statusCode == 200) {

        if (details.personId != 0) {
          try {
            prefs.setInt(Common.USER_ID, details.personId);
            prefs.setString(Common.PERSON_TYPE, details.personType.toString());
            prefs.setString(Common.PERSON_NAME, details.personName.toString());
            prefs.setString(Common.GROUP, details.group.toString());
          } catch (e) {
            print("distanceallowed$e");
          }

          Fluttertoast.showToast(
            msg: "Successfully logged in",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(personName: details.personName.toString()),
            ),
          );
        } else {

          Fluttertoast.showToast(
            msg: "Please check your userid and password",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0,
          );


        }
      } else {
        Fluttertoast.showToast(
          msg: "Please check your credentials",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "$e",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    progress?.dismiss();
    return details;
  }

  Future<void> askpermission() async {

    var camerastatus = await Permission.camera.status;
    var locationstatus = await Permission.camera.status;
    if(camerastatus.isGranted == true && locationstatus.isGranted ==true){
      //
      // Fluttertoast.showToast(msg: "1",
      //     toastLength: Toast.LENGTH_SHORT,
      //     gravity: ToastGravity.BOTTOM,
      //     timeInSecForIosWeb: 1,
      //     backgroundColor: Colors.black,
      //     textColor: Colors.white,
      //     fontSize: 16.0);

    }else if(camerastatus.isGranted == false && locationstatus.isGranted ==false){

      Fluttertoast.showToast(msg: "2",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);

      Map<Permission, PermissionStatus> statuses = await [Permission.location,Permission.camera].request();

      if(statuses[Permission.location]!.isDenied || statuses[Permission.camera]!.isDenied){

        SystemNavigator.pop();

        Fluttertoast.showToast(msg: "3",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);
        openAppSettings();

      }else{

      }

    }


  }

}
