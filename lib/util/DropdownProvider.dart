import 'package:flutter/cupertino.dart';

class DropdownProvider extends ChangeNotifier{

  List<String> dropdownOptions= [];
  List<String> selectedvalues= [];

  void addDropdownOptions(String option){
    dropdownOptions.add(option);
    notifyListeners();
  }

  void removeDropdownOptions(int index){
    dropdownOptions.removeAt(index);
    selectedvalues.removeAt(index);
    notifyListeners();
  }

  void setSelectedValue(int index,String value){
    selectedvalues[index]= value;
    notifyListeners();
  }

}