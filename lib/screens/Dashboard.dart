import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promoterapp/models/Item.dart';
import 'package:slide_drawer/slide_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';
import 'package:d_chart/d_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/Common.dart';
import '../models/logindetails.dart';
import '../util/Helper.dart';
import 'package:flutter_progress_hud/flutter_progress_hud.dart';

class Dashboard extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return Dashboardstate();
  }

}

class Dashboardstate extends State<Dashboard> {

  late Future<List<Map<String, dynamic>>> futurelist;
 // late Future<List<Map<String, dynamic>>> futurepielist;

  int target = 0,
      targetboxes = 0,
      userid = 0,
      pending =0 ,
      reportUom = 0,
      assignedshops = 0,
      shopscoverd = 0,
      shopsproductive = 0,
      ltrs=0,
      achiveved = 0;
  bool _isLoading = false;
  num total=0;
  String? cdate,group,targettype,attStatus;
  String personName="";

  List<Color> colorList = [
    const Color(0xffD95AF3),
    const Color(0xff3EE094),
  ];

  Map<String, dynamic> dataMap =
  {
    "id": "Bar",
    "data": [
      {'domain': 'Productive', 'measure': 1},
      {'domain': 'Unprod', 'measure': 0},
      {'domain': 'Covered', 'measure': 1},
      {'domain': 'Uncovered', 'measure': 7},
    ],
  };

  List<Map<String, dynamic>> barchart = [];

  final gradientList = <List<Color>>[

    [
      Color.fromRGBO(223, 250, 92, 1),
      Color.fromRGBO(129, 250, 112, 1),
    ],
    [
      Color.fromRGBO(129, 182, 205, 1),
      Color.fromRGBO(91, 253, 199, 1),
    ],

  ];
  int difference =0 ;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now(); // March 2022

    cdate = getcurrentdate();
    futurelist = getpersondata();

    final d1 = DateTime.now();
    final date = new DateTime(now.year, now.month + 1, 0);
    setState(() {
      difference = date.difference(d1).inDays;
    });


  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            title: Text("My Dashboard",
                style: TextStyle(color: Color(0xFF095909),
                    fontFamily: 'OpenSans',
                    fontWeight: FontWeight.w300)),
            leading: GestureDetector(
              onTap: () {
                SlideDrawer.of(context)?.toggle();
              },
              child: Image.asset(
                'assets/Icons/nav_menu.png', width: 104.0, height: 104.0,),
            )
        ),
        body:_isLoading?Center(
            child:CircularProgressIndicator()
        ):SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text("Welcome $personName",
                    style: TextStyle(fontSize: 20),),
                ),
                Container(
                  margin: EdgeInsets.all(10),
                  child: Text("Target : $target ",
                    style: TextStyle(fontSize: 20),),
                ),

                Container(
                  height: 200,
                  child: FutureBuilder<List>(
                      future: futurelist,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return AspectRatio(aspectRatio: 16/9,
                            child: DChartBar(
                              data: [
                                {
                                  'id': 'Bar',
                                  'data': [
                                    {
                                      'domain': 'Productive',
                                      'measure': shopsproductive
                                    },
                                    {'domain': 'Unprod',
                                      'measure': shopscoverd - shopsproductive},
                                    {'domain': 'Covered',
                                      'measure': shopscoverd},
                                    {
                                      'domain': 'Uncovered',
                                      'measure': assignedshops - shopscoverd
                                    },
                                  ],
                                },
                              ],

                              domainLabelPaddingToAxisLine: 16,
                              axisLineTick: 2,
                              axisLinePointTick: 2,
                              axisLinePointWidth: 10,
                              axisLineColor: Colors.green,
                              measureLabelPaddingToAxisLine: 16,
                              barColor: (barData, index, id) => Colors.green,
                              barValue: (barData, index) => '${barData['measure']}',
                              showBarValue: true,
                              barValuePosition: BarValuePosition.auto,
                              verticalDirection: false,

                            ),);
                        } else if (snapshot.hasError) {
                          return Container();
                        }
                        return Container();
                      }
                  ),
                ),

                Container(
                  margin: EdgeInsets.all(10),
                  child: Text("Per day goal :  ${(pending / difference!).toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 20),),
                ),

                PieChart(
                  dataMap: {
                    "Achieved": total.toDouble(),
                    "Pending":  pending.toDouble(),
                  },
                  colorList: colorList,
                  chartRadius: MediaQuery
                      .of(context)
                      .size
                      .width / 3,
                  centerText: "Target",
                  ringStrokeWidth: 24,
                  animationDuration: Duration(seconds: 3),
                  chartValuesOptions: ChartValuesOptions(
                      showChartValues: true,
                      showChartValuesOutside: true,
                      showChartValuesInPercentage: false,
                      showChartValueBackground: false),

                  legendOptions: LegendOptions(
                      showLegends: true,
                      legendShape: BoxShape.rectangle,
                      legendTextStyle: TextStyle(fontSize: 15),
                      legendPosition: LegendPosition.bottom,
                      showLegendsInRow: true),
                  gradientList: gradientList,
                )

                // FutureBuilder(
                //     future: futurepielist,
                //     builder: (context,snapshot){
                //       if(snapshot.hasData){
                //         return PieChart(
                //           dataMap: {
                //             "Achieved": total.toDouble(),
                //             "Pending":  pending.toDouble(),
                //           },
                //           colorList: colorList,
                //           chartRadius: MediaQuery
                //               .of(context)
                //               .size
                //               .width / 3,
                //           centerText: "Budget",
                //           ringStrokeWidth: 24,
                //           animationDuration: Duration(seconds: 3),
                //           chartValuesOptions: ChartValuesOptions(
                //               showChartValues: true,
                //               showChartValuesOutside: true,
                //               showChartValuesInPercentage: false,
                //               showChartValueBackground: false),
                //
                //           legendOptions: LegendOptions(
                //               showLegends: true,
                //               legendShape: BoxShape.rectangle,
                //               legendTextStyle: TextStyle(fontSize: 15),
                //               legendPosition: LegendPosition.bottom,
                //               showLegendsInRow: true),
                //           gradientList: gradientList,
                //         );
                //       }
                //       return Container();
                //     }),

                // Padding(
                //   padding: EdgeInsets.only(left:10,top: 60,right:10),
                //   child: AspectRatio(
                //     aspectRatio: 16 / 9,
                //     child: DChartBar(
                //       data: [
                //         {
                //           'id': 'Bar',
                //           'data': [
                //             {'domain': 'Productive', 'measure': assignedshops},
                //             {'domain': 'Unprod', 'measure': 500},
                //             {'domain': 'Covered', 'measure': 1500},
                //             {'domain': 'Uncovered', 'measure': 500},
                //           ],
                //         },
                //       ],
                //     //  data: barchart,
                //       domainLabelPaddingToAxisLine: 16,
                //       axisLineTick: 2,
                //       axisLinePointTick: 2,
                //       axisLinePointWidth: 10,
                //       axisLineColor: Colors.green,
                //       measureLabelPaddingToAxisLine: 16,
                //       barColor: (barData, index, id) => Colors.green,
                //       showBarValue: true,
                //     ),
                //   ),
                // ),

              ],
            )
        )
    );
  }

  Future<List<Map<String, dynamic>>> getpersondata() async {
    _isLoading = true;
    logindetails details;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try{
      var response = await http.post(
          Uri.parse('${Common.IP_URL}Userdetails?userId=$userid'),
          headers: headers);

      SharedPreferences prefs = await SharedPreferences.getInstance();

      try {

        details = logindetails.fromJson(json.decode(response.body));
        prefs.setString(Common.ATT_STATUS,details.attStatus.toString());
        personName=details.personName!;
        if (details.personId != 0) {
          if (details.group == "GT") {

            setState(() {
              target = details.target!.toInt();
              targettype = "Ltrs";
            });

            print("group$targettype");

          } else {

            setState(() {
              target = details.targetBoxes!.toInt();
              targettype = "Boxes";

            });

            print("Boxes${details.group }");

          }
          prefs.setInt(Common.DISTANCE_ALLOWED,details.distanceAllowed!.toInt());

          assignedshops = details.assignedshops!;
          shopscoverd = details.coveredshops!.toInt();
          shopsproductive = details.productiveshops!.toInt();

          barchart.add(dataMap);

        }else{

          print("shopsproductiveelse");

        }
      } catch (e) {

        print("shopsproductive3$e");

      }

    }catch(e){

      print("shopsproductive$e");

    }
    gettargetdata();
    _isLoading = false;
    return barchart;
  }

  Future<List<Map<String, dynamic>>> gettargetdata() async {

    // final progress  = ProgressHUD.of(context);
    // progress?.show();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;
    List<Item> detailslist = [];

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.post(Uri.parse('${Common.IP_URL}GetPersonMonthlyItemReport?id=$userid&date=$cdate'),
        headers: headers);

    if (response.body.isNotEmpty) {

      try {
        num val=0;
        final list = jsonDecode(response.body);
        detailslist = list.map<Item>((m) => Item.fromJson(Map<String, dynamic>.from(m))).toList();

        if(targettype=="Ltrs"){

          for(int i=0;i<detailslist.length;i++){

            val += detailslist[i].quantity!;

          }

          setState(() {
            total = val;
            pending = target - total.toInt();
          });

        }else{

          for(int i=0;i<detailslist.length;i++){
            setState(() {
              total += detailslist[i].boxes!;
            });

          }

        }

      } catch (e) {
          print("exception$e");
      }

    }

   // progress?.dismiss();
    return barchart;
  }

}