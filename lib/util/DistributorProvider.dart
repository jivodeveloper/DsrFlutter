import 'package:flutter/cupertino.dart';

class DistributorProvider extends ChangeNotifier{

  List<int> itemidlist= [];
  List<int> boxeslist= [];

  // void addDropdownOptions(String option){
  //   selecteditem.add(option);
  //   notifyListeners();
  // }
  //
  // void removeDropdownOptions(int index){
  //   selecteditem.removeAt(index);
  //   selectedValues.removeAt(index);
  //   notifyListeners();
  // }
  //
  // void setSelectedValue(int index,String value){
  //   selectedValues.insert(index, value);
  //   print("valueofcategory${selectedValues.length}");
  //   // notifyListeners();
  // }

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