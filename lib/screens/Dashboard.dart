import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:slide_drawer/slide_drawer.dart';
import 'package:http/http.dart' as http;
import 'package:pie_chart/pie_chart.dart';
import 'package:d_chart/d_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/Common.dart';
import '../models/logindetails.dart';

class Dashboard extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return Dashboardstate();
  }

}

class Dashboardstate extends State<Dashboard>{

  late Future<List> furturedist;
  int target=0,targetboxes=0, userid=0,reportUom=0,assignedshops=0,shopscoverd=0,shopsproductive=0;

  Map<String, double> dataMap = {
    "Acheived": 1600,
    "Pending": 400,
  };
  String targettype="";
  List<Color> colorList = [
    const Color(0xffD95AF3),
    const Color(0xff3EE094),
  ];
  List<Map<String, dynamic>> barchart=[];

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

  @override
  void initState() {
    super.initState();
    getpersondata();
  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
       appBar: AppBar(
       backgroundColor: Colors.white,
       title: Text("Dashboard",
           style: TextStyle(color:  Color(0xFF095909),fontFamily: 'OpenSans',fontWeight: FontWeight.w300)),
       leading:GestureDetector(
           onTap: (){
             SlideDrawer.of(context)?.toggle();
           },
           child:Image.asset('assets/Icons/nav_menu.png', width: 104.0, height: 104.0,) ,
       )
     ),
       body:SingleChildScrollView(
         child: Column(
           children: [

             Container(
               margin: EdgeInsets.all(10),
               child: Text("Target : $target $targettype",style: TextStyle(fontSize: 20),),
             ),

             PieChart(
               dataMap: dataMap,
               colorList: colorList,
               chartRadius: MediaQuery
                   .of(context)
                   .size
                   .width / 2,
               centerText: "Budget",
               ringStrokeWidth: 24,
               animationDuration: Duration(seconds: 3),
               chartValuesOptions: ChartValuesOptions(
                   showChartValues: true,
                   showChartValuesOutside: true,
                   showChartValuesInPercentage: true,
                   showChartValueBackground: false),

               legendOptions: LegendOptions(
                   showLegends: true,
                   legendShape: BoxShape.rectangle,
                   legendTextStyle: TextStyle(fontSize: 15),
                   legendPosition: LegendPosition.bottom,
                   showLegendsInRow: true),
                   gradientList: gradientList,
             ),

             Padding(
               padding: EdgeInsets.only(left:10,top: 60,right:10),
               child: AspectRatio(
                 aspectRatio: 16 / 9,
                 child: DChartBar(
                   data: [
                     {
                       'id': 'Bar',
                       'data': [
                         {'domain': 'Productive', 'measure': assignedshops},
                         {'domain': 'Unprod', 'measure': 500},
                         {'domain': 'Covered', 'measure': 1500},
                         {'domain': 'Uncovered', 'measure': 500},
                       ],
                     },
                   ],
                 //  data: barchart,
                   domainLabelPaddingToAxisLine: 16,
                   axisLineTick: 2,
                   axisLinePointTick: 2,
                   axisLinePointWidth: 10,
                   axisLineColor: Colors.green,
                   measureLabelPaddingToAxisLine: 16,
                   barColor: (barData, index, id) => Colors.green,
                   showBarValue: true,
                 ),
               ),
             ),

           ],
         )
       )
   );
    
  }

  Future<void> getpersondata() async {

    logindetails details;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.post(Uri.parse(Common.IP_URL+'Userdetails?userId=$userid'), headers: headers);

    if(response.body.isNotEmpty){

      try{

        details = logindetails.fromJson(json.decode(response.body));

         if(details.personId!=0){

            if(details.group=="GT"){

              target = details.target;
              targettype = "Ltrs";

            }else{

              target = details.targetBoxes;
              targettype = "Boxes";

            }

            assignedshops = details.assignedshops;
            shopscoverd = details.coveredshops;
            shopsproductive = details.productiveshops;

            // print("data $assignedshops");
            // print("data $shopscoverd");
            // print("data $shopsproductive");

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

            barchart.add(dataMap);

         }

        }catch(e){

        }

    }

  }

}
