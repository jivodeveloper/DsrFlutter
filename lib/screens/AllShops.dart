import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Shops.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../config/Common.dart';
import 'dart:convert';

class AllShops extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return AllShopsState();
  }
}

class AllShopsState extends State<AllShops>{

  late Future<List<Shops>> furturedist;
  int count =0;

  @override
  void initState() {
    super.initState();
    furturedist = loadallshops();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          child:  FutureBuilder<List<Shops>>(future: furturedist,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Container(
                      width:double.infinity,
                      height: double.infinity,
                      padding:EdgeInsets.all(7),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          border: Border.all(color: Color(0xFFD2C7C7))
                      ),
                      child:Column(
                        children: [
                          Text("Count: $count"),
                          Expanded(
                              child:ListView.builder(
                                  itemCount: snapshot.data?.length,
                                  itemBuilder: (context, index) {
                                    return Column(
                                      children: [
                                        Container(
                                          height: 40,
                                          padding: EdgeInsets.all(10),
                                          child: Row(
                                            children: [

                                              Text('${snapshot.data![index].retailerName}'),

                                            ],
                                          ),
                                        ),
                                      ],
                                    );
                                  }
                              ),
                          )
                        ],
                      )
                  );
                } else if (snapshot.hasError) {
                  return Container();

                }
                return const CircularProgressIndicator();
              }),
        ),
    );
  }


  Future<List<Shops>> loadallshops() async {

    List<Shops> beatshoplist = [];
    int userid=0,beatId =0;

    SharedPreferences prefs= await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;
    beatId = prefs.getInt(Common.BEAT_ID)!;

    Map<String,String> headers={
      'Content-Type': 'application/json',
    };

    var response = await http.get(Uri.parse(Common.IP_URL+'/GetShopsData?id=$userid'), headers: headers);

    List<Shops> allshopdata = [];
    final list = jsonDecode(response.body);

    try{

      allshopdata = list.map<Shops>((m) => Shops.fromJson(Map<String, dynamic>.from(m))).toList();

      for(int i=0 ;i<allshopdata.length;i++) {
        if (allshopdata[i].type == "Shop") {
          beatshoplist.add(allshopdata[i]);
        }

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


    // Fluttertoast.showToast(msg: "${beatshoplist.length}",
    //     toastLength: Toast.LENGTH_SHORT,
    //     gravity: ToastGravity.BOTTOM,
    //     timeInSecForIosWeb: 1,
    //     backgroundColor: Colors.black,
    //     textColor: Colors.white,
    //     fontSize: 16.0);

    setState(() {
      count = beatshoplist.length;

    });

    return beatshoplist;
  }

}
