import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Shops.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../config/Common.dart';
import 'dart:convert';

import 'SalesScreen.dart';

class Distributor extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return DistributorState();
  }
}

class DistributorState extends State<Distributor>{

  late Future<List<Shops>> furturedist;
  int count =0;

  @override
  void initState() {
    super.initState();
    furturedist = loadalldist();
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
                    child: Column(
                      children: [
                        Text("Count : $count"),
                        Expanded(child:ListView.builder(
                            itemCount: snapshot.data?.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {

                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              SalesScreen(retailerName :snapshot.data![index].retailerName.toString(),retailerId:snapshot.data![index].retailerID.toString(),address:snapshot.data![index].address.toString(),mobile:snapshot.data![index].mobileNo.toString(),latitude:double.parse(snapshot.data![index].latitude.toString()),longitude:double.parse(snapshot.data![index].longitude.toString()))));


                                },
                                child: Container(
                                  width: double.infinity,
                                  height: 135,
                                  child:  Column(
                                    children: [

                                      Padding(
                                        padding: EdgeInsets.only(left: 30.0,top: 5),
                                        child:  Row(
                                          children: [

                                            Container(
                                              height: 10.0,
                                              width: 10.0,
                                              decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  shape: BoxShape.circle
                                              ),
                                            ),

                                            Align(
                                              child: Text(' Visited',style: TextStyle(color: Colors.green),),
                                              alignment: Alignment.centerLeft,
                                            ),

                                          ],
                                        ),
                                      ),

                                      Padding(
                                        padding: EdgeInsets.only(top: 5),
                                        child: Align(
                                          child: Text('${snapshot.data![index].retailerID}',style :TextStyle(fontSize: 15,color: Color(0xFF817373))),
                                          alignment: Alignment.centerLeft,
                                        ),
                                      ),

                                      Align(
                                        child: Text('${snapshot.data![index].retailerName}',style :TextStyle(fontSize: 18)),
                                        alignment: Alignment.centerLeft,
                                      ),

                                      Align(
                                        child: Text('${snapshot.data![index].address}',style :TextStyle(fontSize: 15,color: Color(0xFF817373))),
                                        alignment: Alignment.centerLeft,
                                      ),

                                      Align(
                                        child: Text('${snapshot.data![index].mobileNo}',style :TextStyle(fontSize: 15,color: Color(0xFF817373))),
                                        alignment: Alignment.centerLeft,
                                      ),

                                      Padding(
                                        padding: EdgeInsets.only(left: 10,right: 10),
                                        child:  Divider(
                                            thickness: 2.0,
                                            color: Color(0xFFDED7D7)
                                        ),)


                                    ],
                                  ),
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
              return const CircularProgressIndicator();
            })
      ),
    );
  }


  Future<List<Shops>> loadalldist() async {

    int userid=0,beatId =0;
    List<Shops> beatshoplist = [];
    SharedPreferences prefs= await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;
    beatId = prefs.getInt(Common.BEAT_ID)!;

    Map<String,String> headers={
      'Content-Type': 'application/json',
    };

    var response = await http.get(Uri.parse(Common.IP_URL+'GetShopsData?id=$userid'), headers: headers);

    List<Shops> distlist = [];
    final list = jsonDecode(response.body);

    try{

      distlist = list.map<Shops>((m) => Shops.fromJson(Map<String, dynamic>.from(m))).toList();

      for(int i=0 ;i<distlist.length;i++){

        if(distlist[i].type == "Distributor" && distlist[i].beatId ==beatId ){
          beatshoplist.add(distlist[i]);
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
