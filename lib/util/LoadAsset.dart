import 'dart:convert';
import '../config/Common.dart';
import 'package:http/http.dart' as http;
import '../models/Item.dart';
import 'Category.dart';

class LoadAsset{

  Future<Category> loadcategories(String userid) async {
    var response = await http.get(Uri.parse(Common.IP_URL+'/GetCatgories?id=$userid'),
        headers: {"Accept": "application/json"});

    return Category.fromJson(
      json.decode(response.body),
    );
  }

  Future<Item> loaditems(String itemid) async {
    var response = await http.get(Uri.parse(Common.IP_URL+'/Getitem?itemType=$itemid'),
        headers: {"Accept": "application/json"});

    return Item.fromJson(
      json.decode(response.body),
    );
  }

  // Future<Item> loadbeatshops(String userid) async {
  //
  //   var response = await http.get(Uri.parse(Common.IP_URL+'/syncAllData?id=$userid'),
  //       headers: {"Accept": "application/json"});
  //
  //   return Shop.fromJson(
  //     json.decode(response.body),
  //   );
  //
  // }

}