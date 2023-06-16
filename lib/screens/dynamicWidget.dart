import 'package:flutter/material.dart';
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

class SalesItemScreen extends StatefulWidget {

  String retailerName="",retailerId="",address="",date="";
  String? dist;
  int userid=0;

  SalesItemScreen({required this.retailerName,required this.retailerId, required this.dist, required this.address,required this.date});

  @override
  SalesItemScreenState createState() => SalesItemScreenState();
}

class SalesItemScreenState extends State<SalesItemScreen> {


  List catenamlist = [], cateidlist = [],itemlist = [], itemid = [];
  int numElements = 1;
  int userid=0;

  List<DynamicWidget> dynamicList = [];
  Future<List>? furturecategory;
  String? dropdowncategory;

  List<DynamicWidget> listDynamic = [];

  List<String> data = [];

  Icon floatingIcon = new Icon(Icons.add);

  addDynamic() {

    if (data.length != 0) {
      floatingIcon = new Icon(Icons.add);
      data = [];
      listDynamic = [];
    }

    if (listDynamic.length >= 5) {
      return;
    }

    listDynamic.add(DynamicWidget(furturecategory));
    setState(() {});

  }

  submitData() {

    floatingIcon = new Icon(Icons.arrow_back);
    data = [];

    listDynamic.forEach((widget) => data.add(widget.controller.text));

    setState(() {});
    print(data.length);
  }

  @override
  void initState() {

    super.initState();
    furturecategory = loadcategory();
  }

  @override
  Widget build(BuildContext context) {

    Widget result = new Flexible(
        flex: 1,
        child: new Card(
          child: ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, index) {
              return new Padding(
                padding: new EdgeInsets.all(10.0),
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Container(
                      margin: new EdgeInsets.only(left: 10.0),
                      child: new Text("${index + 1} : ${data[index]}"),
                    ),
                    new Divider()
                  ],
                ),
              );
            },
          ),
        ));

    Widget dynamicTextField = new Flexible(
      flex: 2,
      child: new ListView.builder(
        itemCount: listDynamic.length,
        itemBuilder: (_, index) => listDynamic[index],
      ),
    );


    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text('Dynamic App'),
        ),
        body: new Container(
          margin: new EdgeInsets.all(10.0),
          child: new Column(
            children: <Widget>[

              data.length == 0 ? dynamicTextField : result,

            ],
          ),
        ),

        floatingActionButton: new FloatingActionButton(
          onPressed: addDynamic,
          child: floatingIcon,
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

    Fluttertoast.showToast(msg: "${catenamlist.length}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);

    return catenamlist;
  }
}

class DynamicWidget extends StatelessWidget {

  TextEditingController controller = new TextEditingController();
  Future<List>? furturecategory;

  DynamicWidget(Future<List>? furturecategory);

  @override
  Widget build(BuildContext context){
    return Container(
      child:FutureBuilder<List>(
        future: furturecategory,
        builder: (context,snapshot){
          if(snapshot.hasData){
            return Container(
              width: double.infinity,
              margin: const EdgeInsets.only(right: 5),
              height: 50,
              padding: const EdgeInsets.only(left: 5,right: 5),
              decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                  border: Border.all(color:const Color(0xFF063A06))
              ),
              child: DropdownButton<String>(
                underline:Container(),
                hint: const Text("Select category"),
                isExpanded: true,
                items: snapshot.data?.map((e) =>
                    DropdownMenuItem<String>(
                      value: e,
                      child: Text(e),
                    )
                ).toList(),

                onChanged: (newVal){

                },
              ),
            );
          }
          else if(snapshot.hasError) {
            return Container();
          }

          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
