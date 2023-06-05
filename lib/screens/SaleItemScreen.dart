import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/Common.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../models/Categorylist.dart';
import '../models/Item.dart';

class SalesItemScreen extends StatefulWidget{

  String retailerName="",retailerId="",address="",date="";
  int userid=0;
  SalesItemScreen({required this.retailerName,required this.retailerId, required this.address,required this.date});

  @override
  State<StatefulWidget> createState() {
   return SalesItemState();
  }

}

class SalesItemState extends State<SalesItemScreen>{

  int userid=0;
  String dropdowncategory = "",dropdownitem="",categoryname="",categoryid="";
  List catenamlist = [];
  List cateidlist = [];
  List<String> itemlist = [];
  List itemid = [];
  late Future<List> furturecategory;
  Future<List>? furturecategoryitem ;

  @override
  void initState() {
    super.initState();
    furturecategory = loadcategory();
    // furturecategoryitem = loadcategoryitem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Color(0xFF063A06),
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          ),
         title: const Text("All Items",
            style: TextStyle(color:Colors.white,fontFamily: 'OpenSans',fontWeight: FontWeight.w300)
         ),
         backgroundColor: Color(0xFF063A06),
         leading: Icon(Icons.cancel),
         iconTheme: const IconThemeData(color:Colors.white),
        ),
        body: Container(
          width: double.infinity,
          child:  Column(
            children: [

              Container(
                  height: 70,
                  margin: EdgeInsets.all(10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: Color(0xFF063A06),
                      borderRadius: BorderRadius.all(Radius.circular(10.0))
                  ),
                  child:Column(
                    children: [

                      Row(
                        children: [

                          Expanded(
                              flex: 1,
                              child: Text("${widget.retailerName}",style: TextStyle(color: Colors.white))
                          ),

                          Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text("Id : ${widget.retailerId}",style: TextStyle(color: Colors.white),)
                           )
                          )

                        ],
                      ),

                      Padding(
                        padding: EdgeInsets.only(left: 5,right: 5),
                        child:  Divider(
                            thickness: 1.0,
                            color: Colors.yellow
                        ),
                      ),

                      Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Text("Distributor Name",style: TextStyle(color: Colors.white))),
                          Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Text("Date : ${widget.date}",style: TextStyle(color: Colors.white)),
                              ))
                        ],
                      ),

                    ],
                  )
              ),

              Container(
                margin: EdgeInsets.only(top: 10),
                color:Colors.blueGrey[200],
                width: double.infinity,
                padding: EdgeInsets.all(10),
                child: Row(
                  children: [

                    Expanded(
                      flex:1,
                      child: FutureBuilder<List>(
                          future: furturecategory,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                width:double.infinity,
                                margin:EdgeInsets.only(left: 5,right: 5),
                                height: 50,
                                padding:const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    border: Border.all(color:Color(0xFF063A06))
                                ),
                                child: DropdownButton<String>(
                                    value: dropdowncategory,
                                    underline:Container(),

                                    isExpanded: true,
                                    items: snapshot.data?.map((e) =>
                                        DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(e),
                                        )
                                    ).toList(),

                                    onChanged:(newVal) {
                                      this.setState(() {
                                        dropdowncategory = newVal.toString();
                                      });
                                    //  loadcategoryitem(dropdowncategory);
                                    }
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Container();
                            }
                            return const CircularProgressIndicator();
                          }
                    ),),

                    Expanded(
                      flex:1,
                      child: FutureBuilder<List>(
                          future: furturecategoryitem,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                width:double.infinity,
                                margin:EdgeInsets.only(left: 5,right: 5),
                                height: 50,
                                padding:const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                    border: Border.all(color:Color(0xFF063A06))
                                ),
                                child: DropdownButton<String>(

                                    underline:Container(),
                                    hint: const Text("Select Category",style: TextStyle(fontFamily: 'OpenSans',fontWeight: FontWeight.w100),),
                                    isExpanded: true,
                                    items: snapshot.data?.map((e) =>
                                        DropdownMenuItem<String>(
                                          value: e,
                                          child: Text(e),
                                        )
                                    ).toList(),

                                    onChanged:(newVal) {
                                      // this.setState(() {
                                      //   dropdowncategory = newVal.toString();
                                      // });
                                      //  loadcategoryitem(dropdowncategory);
                                    }
                                ),
                              );
                            } else if (snapshot.hasError) {
                              return Container();
                            }
                            return const CircularProgressIndicator();
                          }
                      ),),

                  ],
                ),
              ),

              // Container(
              //   margin: EdgeInsets.only(top: 10),
              //   // color:Colors.blueGrey[200],
              //   width: double.infinity,
              //   padding: EdgeInsets.all(10),
              //   child: Row(
              //     children: [
              //       DropdownButton(
              //         value: dropdownvalue,
              //         icon: const Icon(Icons.keyboard_arrow_down),
              //         items: shoptype.map((String items) {
              //           return DropdownMenuItem(
              //             value: items,
              //             child: Text(items),
              //           );
              //         }).toList(),
              //         onChanged: (String? newValue) {
              //           setState(() {
              //             dropdownvalue = newValue!;
              //           });
              //         },
              //       ),
              //     ],
              //   ),
              // ),

              Card(
                margin: EdgeInsets.all(10),
                child:Container(
                  height: 135,
                  child:  Column(
                    children: [

                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(10),
                          child: Column(
                            children: [

                              Container(
                                padding:EdgeInsets.only(top:10,bottom: 10),
                                child: Text("Canola Ltr",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                                alignment: Alignment.centerLeft,
                              ),

                              SizedBox(
                                  width:double.infinity,
                                  child: Row(
                                    children: [

                                      Expanded(
                                          flex: 2,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                    width: 50,
                                                    height: 25,
                                                    margin: EdgeInsets.only(right: 15),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(width: 1.0, color:Colors.grey,),
                                                        borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                    ),
                                                    child: Center(
                                                      child: Text("Rs 2500"),
                                                    )
                                                ),
                                              ),

                                              Expanded(
                                                  flex: 1,
                                                  child:Align(
                                                    alignment: Alignment.centerLeft,
                                                    child: Container(
                                                        width: 80,
                                                        height: 25,
                                                        decoration: BoxDecoration(
                                                            border: Border.all(
                                                              width: 1.0,
                                                              color:Colors.grey,
                                                            ),
                                                            borderRadius: BorderRadius.all(Radius.circular(10.0))
                                                        ),
                                                        child: Center(
                                                          child: Text("25Ltrs"),
                                                        )
                                                    ),
                                                  )
                                              ),
                                            ],
                                          )
                                      ),

                                      Expanded(
                                          flex: 1,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                flex: 1,
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child:Align(
                                                    alignment: Alignment.centerRight,
                                                    child: Container(
                                                      width: 50,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                            width: 1.0,
                                                            color:Colors.grey,
                                                          ),
                                                          borderRadius: BorderRadius.all(Radius.circular(2.0))
                                                      ),
                                                      child: TextFormField(
                                                        decoration: InputDecoration(hintText:'boxes',border: InputBorder.none),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),

                                              Expanded(
                                                flex: 1,
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child:Center(
                                                    child: Container(
                                                      width: 50,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                            width: 1.0,
                                                            color:Colors.grey,
                                                          ),
                                                          borderRadius: BorderRadius.all(Radius.circular(2.0))
                                                      ),
                                                      child: TextFormField(
                                                        decoration: const InputDecoration(hintText:'PCS',border: InputBorder.none),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                      ),

                                    ],
                                  )
                              )

                            ],
                          )

                      ),

                      const Padding(
                        padding: EdgeInsets.only(left: 10,right: 10),
                        child:  Divider(
                            thickness: 0.1,
                            color: Color(0xFF063A06)
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(left: 5),
                        padding: EdgeInsets.only(left: 5,right: 5),
                        child:  Row(
                          children: [
                            Text("Unit Price : "),
                            Text("0.2",style: TextStyle(color: Colors.grey)),
                          ],
                        ),
                      ),

                    ],
                  ),
                )
              )

            ],
          ),
       ),
    );
  }

  Future<List> loadcategory() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.get(Uri.parse(Common.IP_URL+'GetCatgories?userid=768'), headers: headers);

    if(response.statusCode == 200){

      try{

        final list = jsonDecode(response.body);
        Fluttertoast.showToast(msg: "${list}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);

        List<Categorylist> categorydata = [];
        categorydata = list.map<Categorylist>((m) => Categorylist.fromJson(Map<String, dynamic>.from(m))).toList();

        for(int i=0 ;i<categorydata.length;i++){
            catenamlist.add(categorydata[i].typeName.toString());
            cateidlist.add(categorydata[i].id);
        }

      }catch(e){

        print("exceptiondata $e");

        Fluttertoast.showToast(msg: "Please contact admin!!",
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

    return catenamlist;
  }

  Future<List> loadcategoryitem(String item) async {

    var itemid;

    for(int i=0;i<catenamlist.length;i++){
      if(catenamlist[i]==categoryname){
          itemid = cateidlist[i];
      }
    }

    Fluttertoast.showToast(msg: "${itemid}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.get(Uri.parse(Common.IP_URL+'Getitem?itemType=2'), headers: headers);

    if(response.statusCode == 200){

      try{

        final list = jsonDecode(response.body);

        List<Item> categryitem = [];
        categryitem = list.map<Item>((m) => Item.fromJson(Map<String, dynamic>.from(m))).toList();

        for(int i=0 ;i<categryitem.length;i++){
          setState(() {
            itemlist.add(categryitem[i].itemName.toString());
        });

       }

      }catch(e){

        //Navigator.pop(context);
        Fluttertoast.showToast(msg: "Please contact admin!!",
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

    Fluttertoast.showToast(msg: "${itemlist.length}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);

    return itemlist;
  }

}


