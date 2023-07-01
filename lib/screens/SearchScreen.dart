import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:promoterapp/screens/SalesScreen.dart';
import 'package:promoterapp/screens/ShopsDist.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../config/Common.dart';
import '../models/Shops.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:convert';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchShopsState();
  }
}

class SearchShopsState extends State<SearchScreen> {
  late Future<List<Shops>> furturedist;
  int count = 0, shopbeatid=0, beatId = 0;
  bool _isLoading = false;

  List<Shops> allshopdata = [];
  List<Shops> beatshoplist = [];
  @override
  void initState() {
    super.initState();
    furturedist = loadallshops();
  }

  TextEditingController _searchController = TextEditingController();
  List<Shops>? filteredShops;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ShopsDist()),
            );
          },
          child: Icon(Icons.arrow_back, color: Color(0xFF063A06)),
        ),
        title: TextField(
          controller: _searchController,
          onChanged: (value) {
            filterShops(value);
          },
          decoration: InputDecoration(
            hintText: 'Search',
            border: InputBorder.none,
          ),
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Perform search operation
              String searchQuery = _searchController.text;
              filterShops(searchQuery);
              print('Search query: $searchQuery');
            },
          ),
        ],
      ),
      body: Container(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : filteredShops != null
            ? Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
            border: Border.all(color: Color(0xFFD2C7C7)),
          ),
          child: Column(
            children: [
              Text("Count : $count"),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredShops!.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        shopbeatid=filteredShops![index].beatId!;
                        if(shopbeatid==beatId){
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SalesScreen(retailerName: "${filteredShops![index].retailerName}", retailerId: "${filteredShops![index].retailerID}", address: "${filteredShops![index].address}", mobile: "${filteredShops![index].mobileNo}", latitude: double.parse(filteredShops![index].latitude.toString()), longitude: double.parse(filteredShops![index].longitude.toString()))));
                        }else {
                          Fluttertoast.showToast(
                            msg: "Sorry! This shop is not available in your beat!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.black,
                            textColor: Colors.white,
                            fontSize: 16.0,
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(12.0),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          border: Border.all(
                            color: Colors.green,
                            width: 2,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        width: double.infinity,
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Align(
                                    child: Image.asset(
                                      'assets/Images/store.png',
                                      width: 30,
                                    ),
                                    alignment: Alignment.centerLeft,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 5),
                                  child: Align(
                                    child: Text(
                                      ' ${filteredShops![index].retailerID}',
                                      style: TextStyle(
                                        fontSize: 15,
                                        color: Color(0xFF817373),
                                      ),
                                    ),
                                    alignment: Alignment.centerLeft,
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              child: Text(
                                '${filteredShops![index].retailerName}',
                                style: TextStyle(fontSize: 18),
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                            Align(
                              child: Text(
                                '${filteredShops![index].address}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF817373),
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                            Align(
                              child: Text(
                                '${filteredShops![index].mobileNo}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF817373),
                                ),
                              ),
                              alignment: Alignment.centerLeft,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        )
            : Container(),
      ),
    );
  }

  Future<List<Shops>> loadallshops() async {
    _isLoading = true;
    int userid = 0;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getInt(Common.USER_ID)!;
    beatId = prefs.getInt(Common.BEAT_ID)!;

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var response = await http.get(
      Uri.parse(Common.IP_URL + 'GetShopsData?id=$userid'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      final list = jsonDecode(response.body);
      try {
        allshopdata = list
            .map<Shops>((m) => Shops.fromJson(Map<String, dynamic>.from(m)))
            .toList();

        for (int i = 0; i < allshopdata.length; i++) {
          beatshoplist.add(allshopdata[i]);
        }
      } catch (e) {
        Fluttertoast.showToast(
          msg: "$e",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Failed to load shop data",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }

    setState(() {
      count = beatshoplist.length;
      filteredShops = beatshoplist;
    });

    _isLoading = false;
    return beatshoplist;
  }

  void filterShops(String searchQuery) {
    if (searchQuery.isNotEmpty) {
      List<Shops> filteredList = beatshoplist.where(
            (shop) =>
        shop.retailerName!
            .toLowerCase()
            .contains(searchQuery.toLowerCase()) ||
            shop.retailerID
                .toString()
                .toLowerCase()
                .contains(searchQuery.toLowerCase()),
      ).toList();

      setState(() {
        filteredShops = filteredList;
        count = filteredList.length;
      });
    } else {
      setState(() {
        filteredShops = beatshoplist;
        count = beatshoplist.length;
      });
    }
  }
}

