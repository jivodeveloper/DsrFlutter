import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config/Common.dart';
import '../models/Shops.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BeatShops extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return BeatShopsState();
  }

}

class BeatShopsState extends State<BeatShops>{

  late Future<List<Shops>> furturedist;
  int count =0;

  @override
  void initState() {
    super.initState();
    furturedist = loadbeatshop();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: Container(
          height: double.infinity,
            child: FutureBuilder<List<Shops>>(future: furturedist,
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
                      child: Column(
                        children: [
                          Text("Count : $count"),
                          Expanded(child:ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: double.infinity,
                                  height: 120,
                                  child:  Column(
                                    children: [
                                      Row(
                                        children: [
                                          Row(

                                            children: [
                                              Container(

                                                decoration :BoxDecoration(
                                                  color: Colors.orange,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),

                                              Align(
                                                child: Text('Visited'),
                                                alignment: Alignment.centerLeft,
                                              ),


                                            ],
                                          )

                                        ],
                                      ),

                                      Align(
                                        child: Text('${snapshot.data![index].retailerID}',style :TextStyle()),
                                        alignment: Alignment.centerLeft,
                                      ),

                                      Align(
                                        child: Text('${snapshot.data![index].retailerName}'),
                                        alignment: Alignment.centerLeft,
                                      ),

                                      Align(
                                        child: Text('${snapshot.data![index].address}'),
                                        alignment: Alignment.centerLeft,
                                      ),

                                      Align(
                                        child: Text('${snapshot.data![index].mobileNo}'),
                                        alignment: Alignment.centerLeft,
                                      ),

                                      Divider(
                                        thickness: 1.0,
                                          color: Color(0xFFDED7D7)
                                      )
                                    ],
                                  ),
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
                  return Container();
                }

            ),

        ),
      );

   }

  Future<List<Shops>> loadbeatshop() async {

    List<Shops> beatshoplist = [];
    int userid=0,beatId =0;

    SharedPreferences prefs= await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;
    beatId = prefs.getInt(Common.BEAT_ID)!;

    Map<String,String> headers={
      'Content-Type': 'application/json',
    };

    var response = await http.get(Uri.parse(Common.IP_URL+'/GetShopsData?id=$userid'), headers: headers);

    List<Shops> beatshopdata = [];
    final list = jsonDecode(response.body);

    try{

      beatshopdata = list.map<Shops>((m) => Shops.fromJson(Map<String, dynamic>.from(m))).toList();

      for(int i=0 ;i<beatshopdata.length;i++){
        if(beatshopdata[i].beatId == beatId){
          beatshoplist.add(beatshopdata[i]);
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

    setState(() {
      count = beatshoplist.length;

    });

    return beatshoplist;
  }

}



