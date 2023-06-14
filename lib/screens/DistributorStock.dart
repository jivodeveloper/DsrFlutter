import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import '../config/Common.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Item.dart';
import '../models/Shops.dart';

class DistributorStock extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
   return DistributorStockState();
  }

}

class DistributorStockState extends State<DistributorStock>{

  List<String> shoptype = ["Select shoptype","Grocery","Bakery","Chemist","General Store","Modern Store","Rural","Distributor"];
  int userid=0;
  List<String> distnamelist = [];
  List distIdlist = [];
  List itemlist = [];
  String? selectedValue ="val";
  var layout = false ,dropdown =false;
  late Future<List> futureitem;
  late Future<List> furturedist;

  @override
  void initState() {
    super.initState();
    furturedist = getdistributor();
    futureitem = getdistributoritem();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: const Text("Distributor Stock",
              style: TextStyle(color:Color(0xFF063A06),fontFamily: 'OpenSans',fontWeight: FontWeight.w300)
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color:Color(0xFF063A06)),
        ),
        body:Container(
          margin: EdgeInsets.only(left:10,top: 20,right: 10,bottom: 0),
          child: Column(
            children: [

              FutureBuilder<List>(
                  future: furturedist,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Container(
                        width:double.infinity,
                        height: 50,
                        padding:EdgeInsets.all(7),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            border: Border.all(color: Color(0xFFD2C7C7))
                        ),
                        child: DropdownButton<String>(
                            underline:Container(),
                            hint: const Text("Select Distributor",style: TextStyle(fontFamily: 'OpenSans',fontWeight: FontWeight.w100),),
                            isExpanded: true,
                            items: snapshot.data?.map((e) =>
                                DropdownMenuItem<String>(
                                  value: e,
                                  child: Text(e),
                                )
                            ).toList(),

                            onChanged:(newVal) {
                              this.setState(() {
                                selectedValue = newVal.toString();
                              });
                            }
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Container();
                  }
                 return const CircularProgressIndicator();
               }
              ),

              FutureBuilder<List>(
                  future: futureitem,
                  builder: (context, snapshot){
                    if (snapshot.hasData) {
                      return Expanded(
                          child: layout?ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (context,index){
                                return Container(
                                  padding: EdgeInsets.all(5),
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
                          ):Container()
                      );
                    }else{

                    }
                    return const CircularProgressIndicator();
                  }
              ),

              Align(
                alignment: FractionalOffset.bottomCenter,
                child: GestureDetector(

                  onTap: (){

                  },

                  child: Container(
                    margin: const EdgeInsets.all(10),
                    width: double.infinity,
                    height: 55,
                    decoration: BoxDecoration(
                        color: Color(0xFF063A06),
                        borderRadius: BorderRadius.all(Radius.circular(15.0))
                    ),

                    child: Center(
                      child: Text(
                        "SUBMIT",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),

                ),
              ),

           ],
        ),
      ),
    );

  }

  Future<List> getdistributor() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.get(Uri.parse(Common.IP_URL+'GetShopsData?id=$userid'), headers: headers);

    if(response.statusCode == 200){

      try{

        final list = jsonDecode(response.body);
        List<Shops> retailerdata = [];
        retailerdata = list.map<Shops>((m) => Shops.fromJson(Map<String, dynamic>.from(m))).toList();

        for(int i=0 ;i<retailerdata.length;i++){

          if(retailerdata[i].type == "Distributor"){
            distnamelist.add(retailerdata[i].retailerName.toString());
            distIdlist.add(retailerdata[i].retailerID!.toInt());
          }

        }

       // distnamelist.sort((a, b) => a["price"].compareTo(b["price"]));
        //
        // Fluttertoast.showToast(msg: "${distnamelist.length}",
        //
        //     toastLength: Toast.LENGTH_SHORT,
        //     gravity: ToastGravity.BOTTOM,
        //     timeInSecForIosWeb: 1,
        //     backgroundColor: Colors.black,
        //     textColor: Colors.white,
        //     fontSize: 16.0);

      }catch(e){

        Navigator.pop(context);
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
    return distnamelist;
  }

  Future<List> getdistributoritem() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.get(Uri.parse(Common.IP_URL+'GetShopsItemData?id=$userid'), headers: headers);

    if(response.statusCode == 200){

      try{

        final list = jsonDecode(response.body);
        List<Item> itemdata = [];
        itemdata = list.map<Item>((m) => Item.fromJson(Map<String, dynamic>.from(m))).toList();

        for(int i=0 ;i<itemdata.length;i++){
            itemlist.add(itemdata[i].itemName.toString());
        }

        layout = true;
        Fluttertoast.showToast(msg: "${itemlist.length}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);

      }catch(e){

        Navigator.pop(context);

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

  Future<List> submitdiststock() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.get(Uri.parse(Common.IP_URL+'GetShopsItemData?id=$userid'), headers: headers);

    if(response.statusCode == 200){

      try{

        final list = jsonDecode(response.body);
        List<Item> itemdata = [];
        itemdata = list.map<Item>((m) => Item.fromJson(Map<String, dynamic>.from(m))).toList();

        for(int i=0 ;i<itemdata.length;i++){
          itemlist.add(itemdata[i].itemName.toString());
        }

        layout = true;
        Fluttertoast.showToast(msg: "${itemlist.length}",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 16.0);

      }catch(e){

        Navigator.pop(context);

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
