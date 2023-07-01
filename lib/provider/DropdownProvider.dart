import 'package:flutter/cupertino.dart';

class DropdownProvider extends ChangeNotifier{

  List<String> selectedcategory= [];
  List<String> selecteditem= [];

  List<String> skulist = [] ;

  void addDropdownOptions(int index,String option){
    selectedcategory[index]=option;
    // selecteditem[index]=option;
    notifyListeners();
  }

  void additemdropdown(int index,String option){
    print('printing HS new 3 $index $option');
    selecteditem[index]=option;
    notifyListeners();
  }


  void remove(){
    selectedcategory.clear();
    selecteditem.clear();
    notifyListeners();
  }

  void removeDropdownOptions(int index){
    selectedcategory.removeAt(index);
    selecteditem.removeAt(index);
    notifyListeners();
  }

// void setSelectedValue(int index,String value){
//   selectedValues.insert(index, value);
//   print("valueofcategory${selectedValues.length}");
//   // notifyListeners();
// }
//
// void setSelectedItemValue(int index,String value){
//   selecteditem.insert(index, value);
//   print("valueofcategory${selectedValues.length}");
//   // notifyListeners();
// }

}