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
  String? dist;
  int userid=0;

  SalesItemScreen({required this.retailerName,required this.retailerId, required this.dist, required this.address,required this.date});

  @override
  State<StatefulWidget> createState() {

    return SalesItemState();

  }

}

class SalesItemState extends State<SalesItemScreen>{

  int userid=0;
  String? dropdowncategory,dropdownitem,categoryname="",categoryid="";
  List catenamlist = [], cateidlist = [], itemlist = [], itemid = [];
  late Future<List> furturecategory;
  Future<List>? furturecategoryitem ;
  List<dynamicWidget> dynamicList = [];
  int numElements = 1;

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
           title: const Text("All Items", style: TextStyle(color:Colors.white,fontFamily: 'OpenSans',fontWeight: FontWeight.w300)
          ),
          actions: [

            IconButton(
            onPressed: (){
              addwidget();
            },
            icon: Icon(Icons.add))

          ],
          backgroundColor: Color(0xFF063A06),
          leading: GestureDetector(
            onTap:(){
              Navigator.of(context).pop();
            },
            child:Icon(Icons.cancel),
          ),

          iconTheme: const IconThemeData(color:Colors.white),
      ),
      body: Container(
      width: double.infinity,
      child:  Column(
      children: [

       Container(
         height: 90,
         margin: EdgeInsets.all(10),
         padding: EdgeInsets.all(10),
         decoration: const BoxDecoration(
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
                  child: Text("${widget.dist}",style: TextStyle(color: Colors.white))),

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
                 flex: 1,
                 child: FutureBuilder<List>(
                   future: furturecategory,
                   builder: (context,snapshot){

                     if(snapshot.hasData){
                       return Container(
                         width: double.infinity,
                         margin: EdgeInsets.only(left: 5,right: 5),
                         height: 50,
                         padding: const EdgeInsets.only(left: 5,right: 5),
                         decoration: BoxDecoration(
                             borderRadius: BorderRadius.all(Radius.circular(10.0)),
                             border: Border.all(color:Color(0xFF063A06))
                         ),
                         child: DropdownButton<String>(
                         value: dropdowncategory,
                         underline:Container(),
                         hint: const Text("Select category",style: TextStyle(fontFamily: 'OpenSans',fontWeight: FontWeight.w100),),
                         isExpanded: true,
                         items: snapshot.data?.map((e) =>
                             DropdownMenuItem<String>(
                                 value: e,
                                 child: Text(e),
                             )
                           ).toList(),

                         onChanged: (newVal){
                           setState(() {
                             dropdowncategory = newVal.toString();
                           });

                         loadcategoryitem(dropdowncategory!);
                          },
                         ),
                       );
                     }
                     else if(snapshot.hasError) {
                       return Container();
                     }

                     return const CircularProgressIndicator();
                   },
                )
             ),

             // Expanded(
             //     flex: 1,
             //     child: FutureBuilder<List>(
             //       future: furturecategory,
             //       builder: (context,snapshot){
             //
             //         if(snapshot.hasData){
             //           return Container(
             //             width: double.infinity,
             //             margin: EdgeInsets.only(left: 5,right: 5),
             //             height: 50,
             //             padding: const EdgeInsets.only(left: 5,right: 5),
             //             decoration: BoxDecoration(
             //                 borderRadius: BorderRadius.all(Radius.circular(10.0)),
             //                 border: Border.all(color:Color(0xFF063A06))
             //             ),
             //             child: DropdownButton<String>(
             //
             //               underline:Container(),
             //               isExpanded: true,
             //               items: snapshot.data?.map((e) =>
             //                   DropdownMenuItem<String>(
             //                     value: e,
             //                     child: Text(e),
             //                   )
             //               ).toList(),
             //
             //               onChanged: (newVal){
             //                 setState(() {
             //                   dropdownitem = newVal.toString();
             //                 });
             //               },
             //             ),
             //           );
             //         }
             //         else if(snapshot.hasError) {
             //           return Container();
             //         }
             //
             //         return const CircularProgressIndicator();
             //       },
             //     )
             // )

             Expanded(
              flex: 1,
              child:Container(
             width: double.infinity,
             margin: EdgeInsets.only(left: 5,right: 5),
             height: 50,
             padding: const EdgeInsets.only(left: 5,right: 5),
             decoration: BoxDecoration(
                 borderRadius: BorderRadius.all(Radius.circular(10.0)),
                 border: Border.all(color:Color(0xFF063A06))
             ),
             child: DropdownButton<String>(
               value: dropdownitem,
               hint: const Text("Select item",style: TextStyle(fontFamily: 'OpenSans',fontWeight: FontWeight.w100),),
               underline:Container(),
               isExpanded: true,
               items: itemlist.map((e) =>
                   DropdownMenuItem<String>(
                     value: e,
                     child: Text(e),
                   )
               ).toList(),

               onChanged: (newVal){
                 setState(() {
                   dropdownitem = newVal.toString();
                 });
               },
             ),
           ),
             )

           ]
         )
       ),

       Flexible(
            flex: 2,
            child: new ListView.builder(
              itemCount: dynamicList.length,
              itemBuilder: (_, index) => dynamicList[index],
          ),
       )

       ]
      ),
     )
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

        List<Categorylist> categorydata = [];
        categorydata = list.map<Categorylist>((m) => Categorylist.fromJson(Map<String, dynamic>.from(m))).toList();

        for(int i=0 ;i<categorydata.length;i++){
          catenamlist.add(categorydata[i].typeName.toString());
          cateidlist.add(categorydata[i].id);
        }

      }catch(e){

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

  Future<void> loadcategoryitem(String item) async {

    var itemid;

    for(int i=0;i<catenamlist.length;i++){
      if(catenamlist[i]==item){
        itemid = cateidlist[i];
      }
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    itemlist.clear();
    var response = await http.get(Uri.parse(Common.IP_URL+'Getitem?itemType=${itemid}'), headers: headers);

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

  }

  void addwidget(){

    dynamicList.add(new dynamicWidget());

  }

  // void removedynamicWidget(index) {
  //
  //   setState(() {
  //     dynamicList.remove(index);
  //     numElements--;
  //   });
  //
  // }

}

//
// class dynamicWidget extends StatelessWidget {
//
//   final Function(dynamicWidget) removedynamicWidget;
//   String dropdownitem ="";
//   TextEditingController Product = new TextEditingController();
//   TextEditingController Price = new TextEditingController();
//
//   final int index;
//
//   dynamicWidget(this.dropdownitem,this.removedynamicWidget, {Key? key,required this.index}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//
//     return ListBody(
//       children: <Widget>[
//
//         Card(
//           margin: const EdgeInsets.all(10),
//           child: SizedBox(
//             height: 128,
//             child: Column(
//               children: [
//
//                 Container(
//                   width: double.infinity,
//                   padding: EdgeInsets.only(left: 10,top: 5,right: 10,bottom: 2),
//                   child: Column(
//                     children: [
//
//                       Container(
//                           height:1,
//                           child: Align(
//                             alignment: Alignment.centerRight,
//                             child:InkWell(
//                               onTap: (){
//
//                                 removedynamicWidget(this);
//                               },
//                               child: Icon(Icons.cancel,color: Colors.green,weight: 1),
//                             ),
//                           )
//                       ),
//
//                       Container(
//                         padding: EdgeInsets.only(top: 10,bottom: 10),
//                         child: Text("${dropdownitem}",style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold ),),
//                         alignment: Alignment.centerLeft,
//                       ),
//
//                       SizedBox(
//                         width: double.infinity,
//                         child: Row(
//                           children: [
//                             Expanded(
//                                 flex: 2,
//                                 child: Row(
//                                   children: [
//
//                                     Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 50,
//                                           height: 25,
//                                           margin: EdgeInsets.only(right: 15),
//                                           decoration: BoxDecoration(
//                                               border: Border.all(width: 1.0,color:Colors.grey),
//                                               borderRadius: BorderRadius.all(Radius.circular(10.0))
//                                           ),
//                                           child: Center(
//                                             child: Text("RS 2500"),
//                                           ),
//                                         )),
//
//                                     Expanded(
//                                         flex: 1,
//                                         child: Container(
//                                           width: 50,
//                                           height: 25,
//                                           margin: EdgeInsets.only(right: 15),
//                                           decoration: BoxDecoration(
//                                               border: Border.all(width: 1.0,color:Colors.grey),
//                                               borderRadius: BorderRadius.all(Radius.circular(10.0))
//                                           ),
//                                           child: Center(
//                                             child: Text("RS 2500"),
//                                           ),
//                                         )),
//
//                                   ],
//                                 )
//                             ),
//                             Expanded(
//                                 flex: 1,
//                                 child: Row(
//                                   children: [
//
//                                     Expanded(
//                                         flex: 1,
//                                         child: SizedBox(
//                                           width: double.infinity,
//                                           child: Align(
//                                             alignment: Alignment.centerRight,
//                                             child: Container(
//                                               width: 50,
//                                               height: 30,
//                                               decoration: BoxDecoration(
//                                                   border: Border.all(
//                                                       width: 1.0,
//                                                       color: Colors.grey
//                                                   ),
//                                                   borderRadius: BorderRadius.all(Radius.circular(2.0))
//                                               ),
//                                               child: TextFormField(
//                                                 decoration: InputDecoration(hintText: 'boxes',border: InputBorder.none),
//                                               ),
//                                             ),
//                                           ),
//                                         )
//                                     ),
//
//                                     Expanded(
//                                         flex: 1,
//                                         child: SizedBox(
//                                           width: double.infinity,
//                                           child: Align(
//                                             alignment: Alignment.centerRight,
//                                             child: Container(
//                                               width: 50,
//                                               height: 30,
//                                               decoration: BoxDecoration(
//                                                   border: Border.all(
//                                                       width: 1.0,
//                                                       color: Colors.grey
//                                                   ),
//                                                   borderRadius: BorderRadius.all(Radius.circular(2.0))
//                                               ),
//                                               child: TextFormField(
//                                                 decoration: InputDecoration(hintText: 'PCS',border: InputBorder.none),
//                                               ),
//                                             ),
//                                           ),
//                                         )
//                                     )
//
//                                   ],
//                                 )),
//
//                           ],
//                         ),
//                       ),
//
//                     ],
//                   ),
//                 ),
//
//                 Padding(
//                   padding: EdgeInsets.only(left: 10,right: 10),
//                   child:  Divider(
//                       thickness: 0.1,
//                       color: Color(0xFF063A06)
//                   ),
//                 ),
//
//                 Container(
//                   margin: EdgeInsets.only(left: 5),
//                   padding: EdgeInsets.only(left: 5,right: 5),
//                   child: Row(
//                     children: [
//                       Text("Unit Price : "),
//                       Text("0.2",style: TextStyle(color:Colors.grey),)
//                     ],
//                   ),
//                 )
//
//               ],
//             ),
//           ),
//         ),
//
//       ],
//     );
//
//   }
//
// }

class dynamicWidget extends StatelessWidget {

  TextEditingController Product = new TextEditingController();
  TextEditingController Price = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Container(
      child:ListBody(
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 200,
                padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                child: new TextFormField(
                  controller: Product,
                  decoration: const InputDecoration(
                      labelText: 'Product Name',
                      border: OutlineInputBorder()
                  ),
                ),
              ),
              Container(
                width: 100,
                padding: EdgeInsets.fromLTRB(5, 5, 5, 0),
                child: new TextFormField(
                  controller: Price,
                  decoration: const InputDecoration(
                      labelText: 'Price',
                      border: OutlineInputBorder()
                  ),
                  keyboardType: TextInputType.number,
                ),
              )
            ],
          )
        ],
      ),
    );
  }

}


