import 'package:flutter/cupertino.dart';

import '../models/StateByPerson.dart';

class StateValueModel extends ChangeNotifier{

  final List<StateByPerson> _cartList = [];

  void addstate(StateByPerson list){
      _cartList.add(list);
      notifyListeners();
  }

  List<StateByPerson> getareabyzone(int areaId){

  }

}