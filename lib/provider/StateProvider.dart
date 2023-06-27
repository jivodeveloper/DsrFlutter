import 'package:flutter/cupertino.dart';

class StateProvider extends ChangeNotifier{

  List<int> stateid= [];

  void setSelectedItemValue(int index,int boxes,int itemid){

    // itemidlist.insert(index,itemid);
    // boxeslist.insert(index, boxes);

    itemidlist.add(itemid);
    boxeslist.add(boxes);

    notifyListeners();

  }

  int remove(){

    itemidlist.clear();
    boxeslist.clear();
    notifyListeners();
    return 0;
  }

}