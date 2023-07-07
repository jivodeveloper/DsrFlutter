import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import '../config/Common.dart';

Future<String> savelocation(jsondata) async {

  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  var response = await http.post(Uri.parse('${Common.IP_URL}SaveLocationsV2?locations=$jsondata'),
      headers: headers);

  try {

    if (response.statusCode == 200) {

        Fluttertoast.showToast(
          msg: "Successfully logged in",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
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

  }catch(e){

  }
  print("responsebody${response.body.toString()}");
  return response.body.toString();
}