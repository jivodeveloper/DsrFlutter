import 'package:flutter/cupertino.dart';

class DropdownProvider extends ChangeNotifier{

  List<String> selectedcategory= [];
  List<String> selecteditem= [];
  List<int> selecteditemid= [];
  List<int> selecteditemorder= [];
  List<int> selecteditemstock= [];

  List<String> selectedschemecategory= [];
  List<int> selectedschemeitemid= [];
  List<String> selectedschemename= [];
  List<int> selectedschemeitemorder= [];
  List<String> skulist = [];

  /*add category*/
  void addDropdownOptions(int index,String option){
    selectedcategory[index]=option;
    notifyListeners();
  }

  /*add item*/
  void additemdropdown(int index,int id,String item){
    selecteditemid.insert(index,id);
    selecteditem.insert(index,item);
    notifyListeners();
  }

  /*add scheme category*/
  void addDropdownschemecategory(int index,String option){
    selectedschemecategory[index]=option;
    notifyListeners();
  }

  /*scheme item*/
  void additemschemedropdown(int index,int option,String name,int order){
    selectedschemeitemid.insert(index,option);
    selectedschemename.insert(index,name);
    notifyListeners();
  }

  /*add boxes*/
  void additemboxes(int index,int boxes){
    selecteditemorder.insert(index,boxes);
    notifyListeners();
  }

  /*add stock*/
  void additemstock(int index,int boxes){
    selecteditemstock.insert(index,boxes);
    notifyListeners();
  }

  /*add scheme boxes*/
  void addschitemboxes(int index,int boxes){
    selectedschemeitemorder.insert(index,boxes);
    notifyListeners();
  }

  /*clear all list*/
  void remove(){
    selectedcategory.clear();
    selecteditem.clear();
    selecteditemorder.clear();
    selecteditemstock.clear();
    notifyListeners();
  }


}