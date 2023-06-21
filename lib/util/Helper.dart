import 'dart:async';
import  'package:intl/intl.dart';

String getcurrentdate(){

  String cdate = DateFormat("yyyy/MM/dd").format(DateTime.now());
  return cdate;

}

