import 'dart:async';
import  'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import '../config/Common.dart';
import 'package:battery_plus/battery_plus.dart';

LocationData? _currentPosition;
String? isdistanceallowed;
Location location = new Location();
bool isturnedon = false;

String getcurrentdate(){

  String cdate = DateFormat("yyyyMM/dd").format(DateTime.now());
  return cdate;

}

String getcurrentdatewithtime(){

  String cdate = DateTime.now().toString();
  return cdate;

}

double checkdistancecondition() {

  double distanceInMeters=0.0;
  SharedPreferences prefs = SharedPreferences.getInstance() as SharedPreferences;


  distanceInMeters = Geolocator.distanceBetween(_currentPosition!.latitude!.toDouble(),_currentPosition!.longitude!.toDouble(),widget.latitude as double,widget.longitude as double);



  return distanceInMeters;
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

}

getBatteryLevel() async {
  Battery _battery = Battery();
  final level = await _battery.batteryLevel;

}


