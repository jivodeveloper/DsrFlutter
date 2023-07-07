import 'package:flutter/cupertino.dart';

class DistributorProvider extends ChangeNotifier{

  List<String> itemidlist= [];
  List<String> boxeslist= [];

  void setSelectedItemValue(int index,String boxes,String itemid){

    try{

      if(itemidlist.contains(itemid)){
        int idx = itemidlist.indexOf(itemid);
        boxeslist[idx]=boxes;
      }else{
        itemidlist.add(itemid);
        boxeslist.add(boxes);
      }

    }catch(e){
      print("exception$e");
    }

    // boxeslist.insert(index, boxes);
    // itemidlist.add(itemid);
    // boxeslist.add(boxes);

    notifyListeners();
  }

  int remove(){

    itemidlist.clear();
    boxeslist.clear();
    notifyListeners();
  return 0;
  }

}