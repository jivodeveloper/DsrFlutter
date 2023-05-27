import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promoterapp/models/StateByPerson.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config/Common.dart';
import 'dart:convert';

class NewRetailer extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
   return NewRetailerState();
  }

}

class NewRetailerState extends State<NewRetailer>{

  List<String> category=["A","B","C","D"];
  List<String> group=["GT","MT"];
  String categorydropdownValue= "",groupdropdown = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("New Outlet",
              style: TextStyle(color:Color(0xFF063A06),fontFamily: 'OpenSans',fontWeight: FontWeight.w300)
          ),
      ),
      body: Column(
        children: [

          Container(
          width:double.infinity,
          height: 50,
          padding:EdgeInsets.all(7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Color(0xFFD2C7C7))
          ),
          child:DropdownButton<String>(
             value: category.first,
             elevation: 16,
             style: const TextStyle(color: Color(0xFF063A06)),
             underline: Container(),
             onChanged: (String? value) {
               // This is called when the user selects an item.
               setState(() {
                 categorydropdownValue = value!;
               });
             },
             items: category.map<DropdownMenuItem<String>>((String value) {
               return DropdownMenuItem<String>(
                 value: value,
                 child: Text(value),
               );
             }).toList(),
          ),),

          Container(
          width:double.infinity,
          height: 50,
          padding:EdgeInsets.all(7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Color(0xFFD2C7C7))
          ),
          child:DropdownButton<String>(
            value: group.first,
            elevation: 16,
            style: const TextStyle(color: Color(0xFF063A06)),
            underline: Container(),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                groupdropdown = value!;
              });
            },
            items: group.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
          ),

          TextFormField(
                decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock,
                  color: Color(0xFF063A06),),
                hintText:'Name'
            ),
          ),

          TextFormField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock,
                  color: Color(0xFF063A06),),
                hintText:'Address'
            ),
          ),

          TextFormField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock,
                  color: Color(0xFF063A06),),
                hintText:'Pin Code'
            ),
          ),

          Container(
          width:double.infinity,
          height: 50,
          padding:EdgeInsets.all(7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Color(0xFFD2C7C7))
          ),
          child:DropdownButton<String>(

            value: group.first,
            elevation: 16,
            style: const TextStyle(color: Color(0xFF063A06)),
            underline: Container(),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              setState(() {
                groupdropdown = value!;
              });
            },
            items: group.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),),

          TextFormField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock,
                  color: Color(0xFF063A06),),
                hintText:'Owner'
            ),
          ),

          TextFormField(
            decoration: InputDecoration(
                prefixIcon: Icon(Icons.lock,
                  color: Color(0xFF063A06),),
                hintText:'mobile'
            ),
          ),

        ],
      ),

    );
  }

  Future<List<StateByPerson>> loadstate() async {
    List<StateByPerson> statelist = [];
    int userid=0;

    SharedPreferences prefs= await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;

    Map<String,String> headers={
      'Content-Type': 'application/json',
    };

    var response = await http.get(Uri.parse(Common.IP_URL+'/GetShopsData?id=$userid'), headers: headers);

    List<StateByPerson> statedata = [];
    final list = jsonDecode(response.body);

    try{

      statedata = list.map<StateByPerson>((m) => StateByPerson.fromJson(Map<String, dynamic>.from(m))).toList();

      for(int i=0 ;i<statedata.length;i++){
        statelist.add(statedata[i]);
      }

    }catch(e){
      Fluttertoast.showToast(msg: "$e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }

    return statelist;
  }
}