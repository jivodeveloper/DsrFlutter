import 'package:flutter/cupertino.dart';

class DropdownProvider extends ChangeNotifier{

  List<String> selecteditem= [];
  List<String> selectedValues= [""];

  // void addDropdownOptions(String option){
  //   dropdownOptions.add(option);
  //   notifyListeners();
  // }
  //
  // void removeDropdownOptions(int index){
  //   dropdownOptions.removeAt(index);
  //   selectedValues.removeAt(index);
  //   notifyListeners();
  // }


  void setSelectedItem(int index,String value){
    // selectedValues[index]= value;
    selecteditem.insert(index,value);
    notifyListeners();
  }

  void setSelectedValue(int index,String value){
    // selectedValues[index]= value;
    selectedValues.insert(index,value);
    notifyListeners();
  }
  
  void removeSelectedValue(int index,String value){
    // selectedValues[index]= value;
    selectedValues.remove(index);
    notifyListeners();
  }

  void removeSelectedItem(int index){
    // selectedValues[index]= value;
    selectedValues.remove(index);
    notifyListeners();
  }

  String getSelectedValue(int index){
    // selectedValues[index]= value;
    var value = selectedValues.elementAt(index);
    notifyListeners();
    return value;
  }

}