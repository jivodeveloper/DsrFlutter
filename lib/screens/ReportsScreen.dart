import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:promoterapp/models/SalesReport.dart';
import 'package:promoterapp/screens/SaleItemScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/Items.dart';
import '../models/Shops.dart';
import '../config/Common.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ReportsScreen extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return ReportsScreenState();
  }

}

class ReportsScreenState extends State<ReportsScreen>{

  Future<List<SalesReport>>? getreport;
  String from="",to="",salesid="";
  List<SalesReport> salesreport = [];
  List<Items> itemsreport = [];
  int totalPcs=0;
  int totalLtr=0;
  int count=0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sales Reports",
            style: TextStyle(color:Color(0xFF063A06),fontFamily: 'OpenSans',fontWeight: FontWeight.w300)
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color:Color(0xFF063A06)),
      ),
      body:ProgressHUD(
        child:Builder(
        builder: (context) =>SingleChildScrollView(
        child:  SizedBox(
          height: 900,
          child: Column(
            children: [
              Center(
                child:Text("DAILY SALES REPORT",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),) ,
              ),

              Container(
                alignment: Alignment.centerRight,
                margin: EdgeInsets.only(right: 10),
                child: Text("$count"),
              ),

              SizedBox(
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        child:Container(
                            margin: EdgeInsets.all(10),
                            child: Center(
                              child:Text("Total Pcs:$totalPcs"),
                            )
                        ),),
                    ),
                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                        child:Container(
                            margin: EdgeInsets.all(10),
                            child: Center(
                              child:Text("Total Ltr:$totalLtr"),
                            )
                        ),),
                    )
                  ],
                ),
              ),
              SizedBox(

                child: Row(
                  children: [

                    Expanded(
                      flex: 1,
                      child:   GestureDetector(
                        onTap: () async {
                          var date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1900),
                              lastDate: DateTime(2100));
                          if (date != null) {
                            setState((){
                              from = DateFormat('yyyy/MM/dd').format(date);
                            });

                            if(to!=""){
                              getreport = getreports(context);
                            }
                          }
                        },
                        child:Container(
                            margin: EdgeInsets.all(10),
                            color: Colors.green,
                            height: 40,
                              child:Container(

                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,

                                  children: [
                                    Image.asset('assets/Images/Calender.png', width:20,height: 20,alignment: Alignment.center,),
                                    from==""?Text("FROM",style: TextStyle(color: Colors.white), textAlign: TextAlign.center,):Text("$from",style: TextStyle(color: Colors.white),),
                                  ],
                                ),
                              )
                        ),
                      ),

                    ),

                    Expanded(
                      flex: 1,
                      child: GestureDetector(
                          onTap: ()async {
                            var date = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(1900),
                                lastDate: DateTime(2100));
                            if (date != null) {
                              setState((){
                                to = DateFormat('yyyy/MM/dd',).format(date);

                              });
                              if(from!=""){
                                getreport = getreports(context);
                              }else{

                                Fluttertoast.showToast(msg: "Please select from date",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor: Colors.black,
                                    textColor: Colors.white,
                                    fontSize: 16.0);

                              }

                            }
                          },
                          child:Container(
                              margin: EdgeInsets.all(10),
                              color: Colors.green,
                              height: 40,
                              child: Center(
                                child:Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,

                                  children: [
                                    Image.asset('assets/Images/Calender.png', width:20,height: 20),
                                    to==""?Text("TO",style: TextStyle(color: Colors.white),):Text("$to",style: TextStyle(color: Colors.white),),
                                  ],
                                ),
                              )
                          )
                      ),

                    )


                  ],
                ),
              ),

              FutureBuilder<List<SalesReport>>(
                  future: getreport,
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      return Container(
                     
                          height: 600,
                          child: ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: (){
                                    getsinglereport("${salesreport[index].salesId}");
                                  },
                                  child: Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.grey[200],
                                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                                          border: Border.all(color: Color(0xFF063A06))
                                      ),
                                      child:  Column(
                                          children:[

                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 1,
                                                  child:Text("${salesreport[index].retailerName}",style: TextStyle(fontSize: 16,color: Colors.black),),
                                                ),

                                                Expanded(
                                                  flex: 1,
                                                  child:Text("${salesreport[index].date}",style: TextStyle(fontSize: 16,color: Colors.black),),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child:Text("${salesreport[index].address}",style: TextStyle(fontSize: 16,color: Colors.black),),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child:Text("Boxes:${salesreport[index].boxes}",style: TextStyle(fontSize: 16,color: Colors.black),),

                                                ),



                                              ],
                                            ),
                                            Row(
                                              children: [
                                              Expanded(
                                                flex:3,
                                                child: Text("LTR:${salesreport[index].totalQuantity}",style: TextStyle(fontSize: 16,color: Colors.black),),),
                                                Expanded(
                                                    flex: 1,
                                                    child:Text("PCS: ${salesreport[index].pieces}",style: TextStyle(fontSize: 16,color: Colors.black),)

                                                )
                                            ],),
                                            Padding(
                                              padding: EdgeInsets.only(left: 10,right: 10),
                                              child:  Divider(
                                                  thickness: 1.0,
                                                  color: Color(0xFF063A06)
                                              ),
                                            ),
                                            Text(salesreport[index].allowed?"Status: Allowed":"Status: Not Allowed",style: TextStyle(fontSize: 16,color: Colors.black),),

                                          ]
                                      )
                                  ),
                                );

                              }
                          )

                      );
                    }
                    return Container();
                  }),


            ],
          ),
        ),
      )
    ))
    );
  }

  Future<List<SalesReport>> getreports(BuildContext context) async {

    ProgressHUD.of(context)?.show();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userid = prefs.getInt(Common.USER_ID)!;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.get(Uri.parse('${Common.IP_URL}GetDailyReport?userId=$userid&fromDate=$from&toDate=$to'), headers: headers);

    if(response.statusCode == 200){

      try{

        final list = jsonDecode(response.body);
        print("${list["salesReport"]}");
        salesreport = list["salesReport"].map<SalesReport>((m) => SalesReport.fromJson(Map<String, dynamic>.from(m))).toList();

        print("${salesreport.length}");

      }catch(e){

        print("value$e");

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
    ProgressHUD.of(context)?.dismiss();
    return salesreport;

  }

  Future<List<Items>> getsinglereport(String salesId) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userid = prefs.getInt(Common.USER_ID)!;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.get(Uri.parse('${Common.IP_URL}getsinglesalereport?salesId=$salesId'), headers: headers);
    print("${response.body.toString()}");
    if(response.statusCode == 200){

      try{

        final list = jsonDecode(response.body);

        itemsreport = list["itemList"].map<SalesReport>((m) => Items.fromJson(Map<String, dynamic>.from(m))).toList();
        setState(() {
          count = itemsreport.length;
        });

        print("${itemsreport.length}");

      }catch(e){

        print("value$e");

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
    //  context.loaderOverlay.hide();
    return itemsreport;

  }

}
