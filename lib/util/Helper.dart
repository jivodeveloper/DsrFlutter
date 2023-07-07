import 'dart:convert';
import 'package:flutter/material.dart';
import  'package:intl/intl.dart';
import 'package:promoterapp/util/ApiHelper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:battery_plus/battery_plus.dart';
import '../config/Common.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geocoding/geocoding.dart' as geocoding;

LocationData? _currentPosition;
String? isdistanceallowed;
Location location = new Location();
bool isturnedon = false;
String? _currentAddress;
Position? position;

String getcurrentdate(){

  String cdate = DateFormat("yyyy/MM/dd").format(DateTime.now());
  return cdate;

}

String getcurrentdatewithtime(){

  // String cdate = DateTime.now().toString();
  String date =DateFormat('MM-dd-yyyy HH:mm').format(DateTime.now());
  return date;

}

double checkdistancecondition(double? latitude,double? longitude) {

  double distanceInMeters=0.0;
  SharedPreferences prefs = SharedPreferences.getInstance() as SharedPreferences;


  distanceInMeters = Geolocator.distanceBetween(_currentPosition!.latitude!.toDouble(),_currentPosition!.longitude!.toDouble(),latitude! , longitude!);



  return distanceInMeters;
}

Future<LocationData?> fetchLocation() async {

  try{

    print("_current");
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userid = prefs.getInt(Common.USER_ID)!;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return null;
      }
    }


    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return null;
      }
    }

    _currentPosition = await location.getLocation();

    bool ison = await location.serviceEnabled();
    if (!ison) {
      isturnedon = await location.requestService();
    }
    _getCurrentPosition();
    String cdate =getcurrentdatewithtime();
    int? battery;

    Battery _battery = Battery();
    var level = await _battery.batteryLevel;
    print("level$level");


    var locationentry=[{
    "personId":"$userid",
    "timeStamp":cdate,
    "latitude":_currentPosition?.latitude,
    "longitude":_currentPosition?.latitude,
    "battery":level,
    "GpsEnabled":isturnedon,
    "accuracy":_currentPosition?.accuracy,
    "speed":_currentPosition?.speed,
    "provider":_currentPosition?.provider,
    "altitude":_currentPosition?.altitude,
    "address":_currentAddress}];

    print("jsondata$locationentry");
    var request = json.encode(locationentry);

    savelocation(request);

    // location.onLocationChanged.listen((LocationData currentLocation) {
    //   setState(() {
    //     _currentPosition = currentLocation;
    //    getAddress(_currentPosition?.latitude, _currentPosition?.longitude)
    //         .then((value) {
    //       setState(() {
    //         _address = "＄{value.first.addressLine}";
    //       });
    //     });
    //   });
    // });

  }catch(e){
    print("error$e");
  }
  return _currentPosition;
}

Future<void> _getCurrentPosition() async {

  PermissionStatus _permissionGranted;
  bool _serviceEnabled;
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int userid = prefs.getInt(Common.USER_ID)!;

  _serviceEnabled = await location.serviceEnabled();
  if (!_serviceEnabled) {
    _serviceEnabled = await location.requestService();
    if (!_serviceEnabled) {
      return null;
    }
  }


  _permissionGranted = await location.hasPermission();
  if (_permissionGranted == PermissionStatus.denied) {
    _permissionGranted = await location.requestPermission();
    if (_permissionGranted != PermissionStatus.granted) {
      return null;
    }
  }

  if (!_serviceEnabled) return;
  await Geolocator.getCurrentPosition(desiredAccuracy: geolocator.LocationAccuracy.high)
      .then((Position pos) {

    _getAddressFromLatLng(pos);
  }).catchError((e) {
    debugPrint(e);
  });

}

Future<void> _getAddressFromLatLng(Position position) async {

  await geocoding.placemarkFromCoordinates(position.latitude, position!.longitude)
      .then((List<geocoding.Placemark> placemarks) {
    geocoding.Placemark place = placemarks[0];

      _currentAddress = '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea}, ${place.postalCode}';
      print("address$_currentAddress");
  }).catchError((e) {
    debugPrint(e);
  });

}

// Future<bool> _handleLocationPermission() async {
//   bool serviceEnabled;
//   LocationPermission permission;
//
//   serviceEnabled = await Geolocator.isLocationServiceEnabled();
//   if (!serviceEnabled) {
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text(
//             'Location services are disabled. Please enable the services')));
//     return false;
//   }
//   permission = await Geolocator.checkPermission();
//   if (permission == LocationPermission.denied) {
//     permission = await Geolocator.requestPermission();
//     if (permission == LocationPermission.denied) {
//       ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Location permissions are denied')));
//       return false;
//     }
//   }
//   if (permission == LocationPermission.deniedForever) {
//     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//         content: Text(
//             'Location permissions are permanently denied, we cannot request permissions.')));
//     return false;
//   }
//   return true;
// }

Future<int> getBatteryLevell() async {

  Battery _battery = Battery();
  var level = await _battery.batteryLevel;

  return level;
}

getBatteryLevel() async {

  Battery _battery = Battery();
  var level = await _battery.batteryLevel;

  return level;
}





