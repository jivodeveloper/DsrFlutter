import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config/Common.dart';
import '../models/Item.dart';

class dynamicWidget extends StatelessWidget {

  List catenamlist = [], cateidlist = [],itemlist = [], itemid = [];
  int userid=0;
  late Future<List> furturedist;

  @override
  Widget build(BuildContext context) {
    furturedist = getdistributoritem();

    return SizedBox(
      height: 100,
      child:FutureBuilder<List>(
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
            return const CircularProgressIndicator();
          }
      ),
    );
  }

  Future<List> getdistributoritem() async {
     print("value");
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

        Fluttertoast.showToast(msg: "${itemlist.length}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);

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
