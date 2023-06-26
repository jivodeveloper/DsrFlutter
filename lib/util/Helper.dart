import  'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:location/location.dart';
import 'package:geolocator/geolocator.dart';
import 'package:battery_plus/battery_plus.dart';

LocationData? _currentPosition;
String? isdistanceallowed;
Location location = new Location();
bool isturnedon = false;

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

getBatteryLevel() async {

  Battery _battery = Battery();
  final level = await _battery.batteryLevel;

  return level;
}


