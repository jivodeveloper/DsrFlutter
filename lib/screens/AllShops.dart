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
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    furturedist = loadallshops();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          color: Color(0xFFE8E4E4),
          child:_isLoading?Center(
              child:CircularProgressIndicator()
          ):FutureBuilder<List<Shops>>(future: furturedist,
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

                          Text("Total Shops : $count"),
                          Expanded(
                            child:ListView.builder(
                                itemCount: snapshot.data?.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: (){

                                      Fluttertoast.showToast(msg: "Sorry! This shop is not available in your beat !",
                                          toastLength: Toast.LENGTH_SHORT,
                                          gravity: ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor: Colors.black,
                                          textColor: Colors.white,
                                          fontSize: 16.0);

                                      // Navigator.push(
                                      //     context,
                                      //     MaterialPageRoute(
                                      //         builder: (context) =>
                                      //             SalesScreen(retailerName :snapshot.data![index].retailerName.toString(),retailerId:snapshot.data![index].retailerID.toString(),address:snapshot.data![index].address.toString(),mobile:snapshot.data![index].mobileNo.toString(),latitude:double.parse(snapshot.data![index].latitude.toString()),longitude:double.parse(snapshot.data![index].longitude.toString()))));

                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(12.0),
                                      margin:const EdgeInsets.all(5),
                                      decoration:BoxDecoration(
                                        color: Colors.grey[100],
                                        border: Border.all(color: Colors.green,width: 1, style: BorderStyle.solid,),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      width: double.infinity,
                                      child:  Column(
                                        children: [

                                          // Padding(
                                          //   padding: EdgeInsets.only(left: 30.0,top: 5),
                                          //   child:  Row(
                                          //     children: [
                                          //
                                          //       Container(
                                          //         height: 10.0,
                                          //         width: 10.0,
                                          //         decoration: BoxDecoration(
                                          //             color: Colors.green,
                                          //             shape: BoxShape.circle
                                          //         ),
                                          //       ),
                                          //       //
                                          //       // Align(
                                          //       //   child: Text(' Visited',style: TextStyle(color: Colors.green),),
                                          //       //   alignment: Alignment.centerLeft,
                                          //       // ),
                                          //
                                          //     ],
                                          //   ),
                                          // ),

                                          Row(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(top: 5),
                                                child: Align(
                                                  child: Image.asset('assets/Images/store.png',width: 25,),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ),

                                              Padding(
                                                padding: EdgeInsets.only(top: 5),
                                                child: Align(
                                                  child: Text(' ${snapshot.data![index].retailerID}',style :TextStyle(fontWeight: FontWeight.w300,fontSize: 16,color: Color(0xFF817373))),
                                                  alignment: Alignment.centerLeft,
                                                ),
                                              ),


                                            ],
                                          ),

                                          Align(
                                            child: Text('${snapshot.data![index].retailerName}',style :TextStyle(fontSize: 18,fontWeight: FontWeight.w400)),
                                            alignment: Alignment.centerLeft,
                                          ),

                                          Align(
                                            child: Text('${snapshot.data![index].address}',style :TextStyle(fontSize: 15,color: Color(0xFF817373),fontWeight: FontWeight.w300,)),
                                            alignment: Alignment.centerLeft,
                                          ),

                                          Align(
                                            child: Text('${snapshot.data![index].mobileNo}',style :TextStyle(fontSize: 15,color: Color(0xFF817373),fontWeight: FontWeight.w300)),
                                            alignment: Alignment.centerLeft,
                                          ),
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
                return Container();
              }),
      ),
    );
  }

  Future<List<Shops>> loadallshops() async {

    _isLoading = true;
    List<Shops> beatshoplist = [];
    int userid=0,beatId =0;

    SharedPreferences prefs= await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;
    beatId = prefs.getInt(Common.BEAT_ID)!;

    Map<String,String> headers={
      'Content-Type': 'application/json',
    };

    var response = await http.get(Uri.parse(Common.IP_URL+'GetShopsData?id=$userid'), headers: headers);

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

    setState(() {
      count = beatshoplist.length;

    });
    _isLoading = false;
    return beatshoplist;
  }

}
